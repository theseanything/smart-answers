module SmartAnswer::Calculators
  class ChildBenefitTaxCalculator
    attr_accessor :children_count,
                  :tax_year,
                  :is_part_year_claim,
                  :part_year_children_count,
                  :income_details,
                  :allowable_deductions,
                  :other_allowable_deductions,
                  :child_benefit_start_dates,
                  :child_index,
                  :adjusted_net_income

    NET_INCOME_THRESHOLD = 50_000
    TAX_COMMENCEMENT_DATE = Date.parse("7 Jan 2013") # special case for 2012-13, only weeks from 7th Jan 2013 are taxable

    # START_YEAR = 2012
    # END_YEAR = 1.year.from_now.year
    # TAX_YEARS = (START_YEAR...END_YEAR).each_with_object({}) { |year, hash|
    # hash[year.to_s] = [Date.new(year, 4, 6), Date.new(year + 1, 4, 5)]
    # }.freeze

    def initialize(children_count: 0,
                  tax_year: nil,
                  is_part_year_claim: nil,
                  part_year_children_count: 0,
                  income_details: 0,
                  allowable_deductions: 0,
                  other_allowable_deductions: 0,
                  adjusted_net_income: 0)

      @children_count = children_count
      @tax_year = tax_year
      @is_part_year_claim = is_part_year_claim
      @part_year_children_count = part_year_children_count
      @income_details = income_details
      @allowable_deductions = allowable_deductions
      @other_allowable_deductions = other_allowable_deductions

      @child_benefit_data = self.class.child_benefit_data
      @child_benefit_start_dates = HashWithIndifferentAccess.new
      @tax_years = tax_year_dates
      @adjusted_net_income = adjusted_net_income
      @child_index = 0
    end

    def self.tax_years
      self.child_benefit_data.each_with_object(Array.new) do |(key), tax_year|
        tax_year << key
      end
    end

    def tax_year_dates
      @child_benefit_data.each_with_object(Array.new) { |(key), tax_year|
        tax_year << [@child_benefit_data.fetch(key)["start_date"], @child_benefit_data.fetch(key)["end_date"]]
      }
    end

    def benefits_claimed_amount
      no_of_full_year_children = @children_count - @part_year_children_count
      first_child_calculated = false
      total_benefit_amount = 0

      if no_of_full_year_children.positive?
        no_of_weeks = total_number_of_mondays(child_benefit_start_date, child_benefit_end_date)
        no_of_additional_children = no_of_full_year_children - 1
        total_benefit_amount = first_child_rate_total(no_of_weeks) + additional_child_rate_total(no_of_weeks, no_of_additional_children)
        first_child_calculated = true
      else
        first_child_calculated = false
      end
      if @child_benefit_start_dates.count.positive?
        first_child = 0

        @child_benefit_start_dates.values.each_with_index do |child, index|
          start_date = if (child[:start_date] < child_benefit_start_date) || ((@tax_year == 2012) && (child[:start_date] < TAX_COMMENCEMENT_DATE))
                         child_benefit_start_date
                       else
                         child[:start_date]
                       end

          end_date = if child[:end_date].nil? || (child[:end_date] > child_benefit_end_date)
                       child_benefit_end_date
                     else
                       child[:end_date]
                     end

          no_of_weeks = total_number_of_mondays(start_date, end_date)

          total_benefit_amount = if index.equal?(first_child) && (first_child_calculated == false)
                                   total_benefit_amount + first_child_rate_total(no_of_weeks)
                                 else
                                   total_benefit_amount + additional_child_rate_total(no_of_weeks, 1)
                                 end
        end
      end
      total_benefit_amount.to_f
    end

    def calculate_adjusted_net_income
      @income_details - (@allowable_deductions * 1.25) - @other_allowable_deductions
    end

    def nothing_owed?
      @adjusted_net_income < NET_INCOME_THRESHOLD || tax_estimate.abs.zero?
    end

    def valid_income?
      @income_details.positive?
    end

    def format_income
      # if @income_details.present?
      #   @income_details.gsub(/[£, -]/, "").to_i
      # end
    end

    def valid_number_of_children?
      @children_count > @part_year_children_count
    end

    def percent_tax_charge
      if @adjusted_net_income >= 60_000
        100
      elsif (59_900..59_999).cover?(@adjusted_net_income)
        99
      else
        ((@adjusted_net_income - 50_000) / 100.0).floor
      end
    end

    def tax_estimate
      (benefits_claimed_amount * (percent_tax_charge / 100.0)).floor
    end

    def first_child_rate_total(no_of_weeks)
      @child_benefit_data.fetch(@tax_year)["first_child"] * no_of_weeks
    end

    def additional_child_rate_total(no_of_weeks, no_of_children)
      @child_benefit_data.fetch(@tax_year)["additional_child"] * no_of_children * no_of_weeks
    end

    def total_number_of_mondays(child_benefit_start_date, child_benefit_end_date)
      (child_benefit_start_date..child_benefit_end_date).count(&:monday?)
    end

    def child_benefit_start_date
      @tax_year.to_i == 2012 ? TAX_COMMENCEMENT_DATE : selected_tax_year["start_date"]
    end

    def child_benefit_end_date
      selected_tax_year["end_date"]
    end

    def selected_tax_year
      @child_benefit_data[@tax_year]
    end

    def self.child_benefit_data
      @child_benefit_data ||= YAML.load_file(Rails.root.join("config/smart_answers/rates/child_benefit_rates.yml")).with_indifferent_access
    end

    def store_date(date_type, response)
      if @child_benefit_start_dates[child_index].nil?
        @child_benefit_start_dates[child_index] = {date_type => response}
      else
        @child_benefit_start_dates[child_index] = @child_benefit_start_dates[child_index].merge!({date_type => response})
      end
    end
  end
end
