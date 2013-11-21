require_relative '../../test_helper'

module SmartAnswer::Calculators
  class ChildMaintenanceCalculatorTest < ActiveSupport::TestCase

    context "rate_type when benefits and no shared care" do
      should "show nil rate for low income or any income and benefits and shared care > 0" do
        @calculator = ChildMaintenanceCalculator.new(4, 'no')
        @calculator.income = 5.00
        assert_equal :flat, @calculator.rate_type
        @calculator = ChildMaintenanceCalculator.new(4, 'yes')
        @calculator.number_of_shared_care_nights = 1
        assert_equal :nil, @calculator.rate_type
      end
    end

    context "rate_type method based on income" do
      should "give the correct rate type based on the income of the payee" do
        @calculator = ChildMaintenanceCalculator.new(3, 'no')
        @calculator.income = 6
        assert_equal :flat, @calculator.rate_type
      end

      should "give the correct rate type based on the income of the payee" do
        @calculator = ChildMaintenanceCalculator.new(2, 'no')
        @calculator.income = 126
        assert_equal :reduced, @calculator.rate_type
      end

      should "give the correct rate type based on the income of the payee" do
        @calculator = ChildMaintenanceCalculator.new(1, 'no')
        @calculator.income = 800
        assert_equal :basic, @calculator.rate_type
      end

      should "give the correct rate type based on the income of the payee" do
        @calculator = ChildMaintenanceCalculator.new(1, 'no')
        @calculator.income = 2000
        assert_equal :basic_plus, @calculator.rate_type
      end
    end

    # example on p23
    context "calculate_reduced_rate_payment method" do
      should "give the reduced rate payment total" do
        @calculator = ChildMaintenanceCalculator.new(2, 'no')
        @calculator.income = 173.00
        @calculator.number_of_other_children = 1
        @calculator.number_of_shared_care_nights = 0
        assert_equal 0.235, @calculator.reduced_rate_multiplier
        assert_equal 0, @calculator.shared_care_multiplier
        assert_equal 24, @calculator.calculate_reduced_rate_payment
      end

      should "calculate the child maintenance payment using the correct scheme and rate - reduced rate minimum of 7 pounds" do
        @calculator = ChildMaintenanceCalculator.new(2, 'no')
        @calculator.income = 180.0
        @calculator.number_of_other_children = 1
        @calculator.number_of_shared_care_nights = 4
        assert_equal 7, @calculator.calculate_maintenance_payment
      end
    end

    context "calculate_basic_rate_payment method" do
      setup do
        @calculator = ChildMaintenanceCalculator.new(2, 'no')
        @calculator.income = 600.00
        @calculator.number_of_other_children = 0
        @calculator.number_of_shared_care_nights = 0
      end
      should "give the correct basic rate payment total" do
        assert_equal 0, @calculator.relevant_other_child_multiplier
        assert_equal 0.16, @calculator.basic_rate_multiplier
        assert_equal 0, @calculator.shared_care_multiplier
        assert_equal 96, @calculator.calculate_basic_rate_payment
      end
    end

    ## example from p30
    context "calculate_basic_rate_payment method" do
      setup do
        @calculator = ChildMaintenanceCalculator.new(3, 'no')
        @calculator.income = 517.81
        @calculator.number_of_other_children = 1
        @calculator.number_of_shared_care_nights = 2
      end
      should "give the correct basic rate payment total" do
        assert_equal 0.11, @calculator.relevant_other_child_multiplier
        assert_equal 0.19, @calculator.basic_rate_multiplier
        assert_equal 0.286, @calculator.shared_care_multiplier
        assert_equal 63, @calculator.calculate_basic_rate_payment ##62.52 unrounded
      end
    end

    #example from p20
    context "calculate_basic_plus_rate_payment method" do
      setup do
        @calculator = ChildMaintenanceCalculator.new(2, 'no')
        @calculator.income = 1000.00
        @calculator.number_of_other_children = 0
        @calculator.number_of_shared_care_nights = 0
      end
      should "give the basic plus rate payment total" do
        assert_equal 0, @calculator.relevant_other_child_multiplier
        assert_equal 0.16, @calculator.basic_rate_multiplier
        assert_equal 0.12, @calculator.basic_plus_rate_multiplier
        assert_equal 0, @calculator.shared_care_multiplier
        assert_equal 152, @calculator.calculate_basic_plus_rate_payment
      end
    end

    context "calculate_maintenance_payment method" do
      should "make shared care reductions for the basic plus scheme" do
        @calculator = ChildMaintenanceCalculator.new(3, 'no')
        @calculator.income = 925
        @calculator.number_of_other_children = 0
        @calculator.number_of_shared_care_nights = 4
        assert_equal 64.38, @calculator.calculate_maintenance_payment
      end
    end
  end
end
