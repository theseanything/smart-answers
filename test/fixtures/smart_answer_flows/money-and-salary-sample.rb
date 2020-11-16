module SmartAnswer
  class MoneyAndSalarySampleFlow < Flow
    def define
      name "money-and-salary-sample"
      status :draft

      salary_question :how_much_do_you_earn? do
        save_input_as :salary

        on_response do |response|
          self.annual_salary = SmartAnswer::Money.new(response.per_week * 52)
        end

        next_node do
          question :what_size_bonus_do_you_want?
        end
      end

      money_question :what_size_bonus_do_you_want? do
        on_response do |response|
          value = SmartAnswer::Money.new(response)
          if value < annual_salary
            raise InvalidResponse, "You can't request a bonus less than your annual salary.", caller
          end

          self.requested_bonus = value
        end

        next_node do
          outcome :ok
        end
      end

      outcome :ok
    end
  end
end
