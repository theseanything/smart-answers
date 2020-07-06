module SmartAnswer
  class ChildBenefitTaxCalculatorFlow < Flow
    def define
      name 'child-benefit-tax-calculator'
      start_page_content_id "201fff60-1cad-4d91-a5bf-d7754b866b87"
      flow_content_id "26f5df1d-2d73-4abc-85f7-c09c73332693"
      status :draft

      calculator = Calculators::ChildBenefitTaxCalculator.new
      # Q1
      multiple_choice :how_many_children? do
        (1..10).each do | children |
          option :"#{children}"
        end

        # save_input_as :children_count

        on_response do |response|
          calculator.children_count = response
        end

        next_node do
          question :which_tax_year?
        end
      end

      # Q2
      multiple_choice :which_tax_year? do
        option :"2012"
        option :"2013"
        option :"2014"
        option :"2015"
        option :"2016"
        option :"2017"
        option :"2018"
        option :"2019"
        option :"2020"

        # save_input_as :tax_year

        on_response do |response|
          calculator.tax_year = response
        end

        next_node do
          question :claim_part_year?
        end
      end

      # Q3
      multiple_choice :claim_part_year? do
        option :"yes"
        option :"no"

        # save_input_as :claim_part_year

        on_response do |response|
          calculator.claim_part_year = response
        end

        next_node do |response|
          if response == "yes"
            question :how_many_children_part_year?
          else
            question :income_details
          end
        end
      end

      # Q3a/Q3b (part time children start/stop dates)
      multiple_choice :how_many_children_part_year? do
        children_count = calculator.children_count.to_i+1
        (0..children_count).each do | children |
          option :"#{children+1}"
        end

        on_response do |response|
          calculator.part_year_children_count = response
        end

        # save_input_as :part_year_children_count

        next_node do |response|
          question :starting_children_0
        end
      end

      part_year_children_count = calculator.part_year_children_count.to_i+1
      (0..part_year_children_count).each_with_index do |child_number, index|
        date_question "starting_children_#{child_number}".to_sym do
          from { Date.new(2011, 1, 1) }
          to { Date.new(2021, 4, 5) }

          save_input_as "starting_children_#{child_number}".to_sym

          next_node do |response|
            question "stopping_children_#{child_number}".to_sym
          end
        end

        date_question "stopping_children_#{child_number}".to_sym do
          from { Date.new(2011, 1, 1) }
          to { Date.new(2021, 4, 5) }

          save_input_as "stopping_children_#{child_number}".to_sym

          next_node do |response|
            if index < part_year_children_count.to_i - 1
              question "starting_children_#{index+1}".to_sym
            else
              question :income_details
            end
          end
        end
      end

      value_question :income_details do
        save_input_as :income_details

        next_node do |response|
          question :allowable_deductions
        end
      end

      value_question :allowable_deductions do
        save_input_as :allowable_deductions

        next_node do |response|
        end
      end

      # outcome :outcome_1
    end
  end
end