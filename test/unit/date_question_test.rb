require_relative "../test_helper"
require "ostruct"

module SmartAnswer
  class DateQuestionTest < ActiveSupport::TestCase
    def setup
      @initial_state = State.new(:example)
    end

    context "#parse_input" do
      setup do
        @question = Question::Date.new(nil, :example)
      end

      context "when supplied with a hash" do
        should "return a date representing the hash" do
          date = @question.parse_input(day: 1, month: 2, year: 2015)
          assert_equal Date.parse("2015-02-01"), date
        end

        should "raise an InvalidResponse exception when the hash represents an invalid date" do
          assert_raises(InvalidResponse) do
            @question.parse_input(day: 32, month: 2, year: 2015)
          end
        end

        context "and the day is missing" do
          should "raise an InvalidResponse exception" do
            assert_raises(InvalidResponse) do
              @question.parse_input(day: nil, month: 2, year: 2015)
            end
          end

          should "return the date using the default day when specified" do
            @question.default_day { 1 }
            date = @question.parse_input(day: nil, month: 2, year: 2015)
            assert_equal Date.parse("2015-02-01"), date
          end
        end

        context "and the month is missing" do
          should "raise an InvalidResponse exception" do
            assert_raises(InvalidResponse) do
              @question.parse_input(day: 1, month: nil, year: 2015)
            end
          end

          should "return the date using the default month when specified" do
            @question.default_month { 2 }
            date = @question.parse_input(day: 1, month: nil, year: 2015)
            assert_equal Date.parse("2015-02-01"), date
          end
        end

        context "and the year is missing" do
          should "raise an InvalidResponse exception" do
            assert_raises(InvalidResponse) do
              @question.parse_input(day: 1, month: 2, year: nil)
            end
          end

          should "return the date using the default year when specified" do
            @question.default_year { 2015 }
            date = @question.parse_input(day: 1, month: 2, year: nil)
            assert_equal Date.parse("2015-02-01"), date
          end
        end
      end

      context "when supplied with a string" do
        should "return a date representing the string" do
          date = @question.parse_input("2015-02-01")
          assert_equal Date.parse("2015-02-01"), date
        end

        should "raise an InvalidResponse exception when the string represents an invalid date" do
          assert_raises(InvalidResponse) do
            @question.parse_input("2015-02-32")
          end
        end
      end

      context "when supplied with a date" do
        should "return the date" do
          date = @question.parse_input(Date.parse("2015-02-01"))
          assert_equal Date.parse("2015-02-01"), date
        end
      end

      context "when supplied with another object" do
        should "raise an InvalidResponse exception" do
          assert_raises(InvalidResponse) do
            @question.parse_input(Object.new)
          end
        end
      end
    end

    test "to_response returns a hash of day, month and year representing the date returned from parse_input" do
      valid_date = Date.parse("2015-02-01")
      q = Question::Date.new(nil, :example)
      q.stubs(:parse_input).with("valid-date").returns(valid_date)

      expected_hash = { day: 1, month: 2, year: 2015 }
      assert_equal expected_hash, q.to_response("valid-date")
    end

    test "to_response returns nil if parse_input raises an InvalidResponse exception" do
      q = Question::Date.new(nil, :example)
      q.stubs(:parse_input).with("invalid-date").raises(InvalidResponse)
      assert_nil q.to_response("invalid-date")
    end

    test "to_response raises the exception if parse_input raises anything other than an InvalidResponse exception" do
      q = Question::Date.new(nil, :example)
      q.stubs(:parse_input).with("anything").raises(StandardError)
      assert_raises(StandardError) do
        q.to_response("anything")
      end
    end

    test "dates are parsed from Hash into Date before being saved" do
      q = Question::Date.new(nil, :example) do
        on_response do |response|
          self.date = response
        end

        next_node { outcome :done }
      end

      new_state = q.transition(@initial_state, year: "2011", month: "2", day: "1")
      assert_equal Date.parse("2011-02-01"), new_state.date
    end

    test "incomplete dates raise an error" do
      q = Question::Date.new(nil, :example) do
        on_response do |response|
          self.date = response
        end

        next_node { outcome :done }
      end

      assert_raise SmartAnswer::InvalidResponse do
        q.transition(@initial_state, year: "", month: "2", day: "1")
      end
    end

    test "range returns false when neither from nor to are set" do
      q = Question::Date.new(nil, :question_name)
      assert_equal false, q.range
    end

    test "range returns false when only the from date is set" do
      q = Question::Date.new(nil, :question_name) do
        from { Time.zone.today }
      end
      assert_equal false, q.range
    end

    test "range returns false when only the to date is set" do
      q = Question::Date.new(nil, :question_name) do
        to { Time.zone.today }
      end
      assert_equal false, q.range
    end

    test "define allowable range of dates" do
      q = Question::Date.new(nil, :example) do
        on_response do |response|
          self.date = response
        end

        next_node { outcome :done }
        from { Date.parse("2011-01-01") }
        to { Date.parse("2011-01-03") }
      end
      assert_equal ::Date.parse("2011-01-01")..::Date.parse("2011-01-03"), q.range
    end

    test "a day before the allowed range is invalid" do
      assert_raises(InvalidResponse) do
        date_question_2011.transition(@initial_state, "2010-12-31")
      end
    end

    test "a day after the allowed range is invalid" do
      assert_raises(InvalidResponse) do
        date_question_2011.transition(@initial_state, "2012-01-01")
      end
    end

    test "the first day of the allowed range is valid" do
      new_state = date_question_2011.transition(@initial_state, "2011-01-01")
      assert @initial_state != new_state
    end

    test "the last day of the allowed range is valid" do
      new_state = date_question_2011.transition(@initial_state, "2011-12-31")
      assert @initial_state != new_state
    end

    test "do not complain when the input is within the allowed range when the dates are in descending order" do
      q = Question::Date.new(nil, :example) do
        on_response do |response|
          self.date = response
        end

        next_node { outcome :done }
        from { Date.parse("2011-01-03") }
        to { Date.parse("2011-01-01") }
        validate_in_range
      end

      q.transition(@initial_state, "2011-01-02")
    end

    test "define default day" do
      q = Question::Date.new(nil, :example) do
        default_day { 11 }
      end
      assert_equal 11, q.default_day
    end

    test "define default month" do
      q = Question::Date.new(nil, :example) do
        default_month { 2 }
      end
      assert_equal 2, q.default_month
    end

    test "define default year" do
      q = Question::Date.new(nil, :example) do
        default_year { 2013 }
      end
      assert_equal 2013, q.default_year
    end

    test "incomplete dates are accepted if appropriate defaults are defined" do
      q = Question::Date.new(nil, :example) do
        default_day { 11 }
        default_month { 2 }
        default_year { 2013 }
        on_response do |response|
          self.date = response
        end

        next_node { outcome :done }
      end

      new_state = q.transition(@initial_state, year: "", month: "", day: "")
      assert_equal Date.parse("2013-02-11"), new_state.date
    end

    test "default the day to the last in the month of an incomplete date" do
      q = Question::Date.new(nil, :example) do
        default_day { -1 }
        on_response do |response|
          self.date = response
        end

        next_node { outcome :done }
      end

      incomplete_date = { year: "2013", month: "2", day: "" }
      new_state = q.transition(@initial_state, incomplete_date)
      assert_equal Date.parse("2013-02-28"), new_state.date
    end

    test "#date_of_birth_defaults prevent very old values" do
      assert_raise SmartAnswer::InvalidResponse do
        dob_question.transition(@initial_state, 125.years.ago.to_date.to_s)
      end
    end

    test "#date_of_birth_defaults prevent next year dates" do
      assert_raise SmartAnswer::InvalidResponse do
        next_year_start = 1.year.from_now.beginning_of_year.to_date.to_s
        dob_question.transition(@initial_state, next_year_start)
      end
    end

    test "#date_of_birth_defaults accepts 120 years old values" do
      dob_question.transition(@initial_state, 120.years.ago.to_date.to_s)
    end

  private

    def date_question_2011
      Question::Date.new(nil, :example) do
        on_response do |response|
          self.date = response
        end

        next_node { outcome :done }
        from { Date.parse("2011-01-01") }
        to { Date.parse("2011-12-31") }
        validate_in_range
      end
    end

    def dob_question
      Question::Date.new(nil, :example) do
        date_of_birth_defaults
        on_response do |response|
          self.date = response
        end

        next_node { outcome :done }
      end
    end
  end
end
