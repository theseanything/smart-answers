require_relative "../../test_helper"

module SmartAnswer::Calculators
  class ChildBenefitTaxCalculatorTest < ActiveSupport::TestCase
    context ChildBenefitTaxCalculator do
      context "full year children only" do
        context "calculating the number of weeks/Mondays" do
        # line 247 in calculators unit/calculators/child_benefit_tax_calculator_test.rb
          context "for the full tax year 2012/2013" do
            should "calculate there are 13 Mondays" do
              calculator = ChildBenefitTaxCalculator.new(
                tax_year: "2012",
                children_count: "1",
                is_part_year_claim: "no",
              )
              start_date = calculator.child_benefit_start_date
              end_date = calculator.child_benefit_end_date
              assert_equal 13, calculator.total_number_of_mondays(start_date, end_date)
            end
          end

          context "for the full tax year 2013/2014" do
            should "calculate there are 52 Mondays" do
              calculator = ChildBenefitTaxCalculator.new(
                tax_year: "2013",
                children_count: "1",
                is_part_year_claim: "no",
              )
              start_date = calculator.child_benefit_start_date
              end_date = calculator.child_benefit_end_date
              assert_equal 52, calculator.total_number_of_mondays(start_date, end_date)
            end
          end

          context "for the full tax year 2014/2015" do
            should "calculate there are 52 Mondays" do
              calculator = ChildBenefitTaxCalculator.new(
                tax_year: "2014",
                children_count: "1",
                is_part_year_claim: "no",
              )
              start_date = calculator.child_benefit_start_date
              end_date = calculator.child_benefit_end_date
              assert_equal 52, calculator.total_number_of_mondays(start_date, end_date)
            end
          end

          context "for the full tax year 2015/2016" do
            should "calculate there are 53 Mondays" do
              calculator = ChildBenefitTaxCalculator.new(
                tax_year: "2015",
                children_count: "1",
                is_part_year_claim: "no",
              )
              start_date = calculator.child_benefit_start_date
              end_date = calculator.child_benefit_end_date
              assert_equal 53, calculator.total_number_of_mondays(start_date, end_date)
            end
          end

          context "for the full tax year 2016/2017" do
            should "calculate there are 52 Mondays" do
              calculator = ChildBenefitTaxCalculator.new(
                tax_year: "2016",
                children_count: "1",
                is_part_year_claim: "no",
              )
              start_date = calculator.child_benefit_start_date
              end_date = calculator.child_benefit_end_date
              assert_equal 52, calculator.total_number_of_mondays(start_date, end_date)
            end
          end

          context "for the full tax year 2017/2018" do
            should "calculate there are 52 Mondays" do
              calculator = ChildBenefitTaxCalculator.new(
                tax_year: "2017",
                children_count: "1",
                is_part_year_claim: "no",
              )
              start_date = calculator.child_benefit_start_date
              end_date = calculator.child_benefit_end_date
              assert_equal 52, calculator.total_number_of_mondays(start_date, end_date)
            end
          end

          context "for the full tax year 2018/2019" do
            should "calculate there are 52 Mondays" do
              calculator = ChildBenefitTaxCalculator.new(
                tax_year: "2018",
                children_count: "1",
                is_part_year_claim: "no",
              )
              start_date = calculator.child_benefit_start_date
              end_date = calculator.child_benefit_end_date
              assert_equal 52, calculator.total_number_of_mondays(start_date, end_date)
            end
          end

          context "for the full tax year 2019/2020" do
            should "calculate there are 52 Mondays" do
              calculator = ChildBenefitTaxCalculator.new(
                tax_year: "2019",
                children_count: "1",
                is_part_year_claim: "no",
              )
              start_date = calculator.child_benefit_start_date
              end_date = calculator.child_benefit_end_date
              assert_equal 52, calculator.total_number_of_mondays(start_date, end_date)
            end
          end

          context "for the full tax year 2020/2021" do
            should "calculate there are 53 Mondays" do
              calculator = ChildBenefitTaxCalculator.new(
                tax_year: "2020",
                children_count: "1",
                is_part_year_claim: "no",
              )
              start_date = calculator.child_benefit_start_date
              end_date = calculator.child_benefit_end_date
              assert_equal 53, calculator.total_number_of_mondays(start_date, end_date)
            end
          end
        end
      end

      context "calculating child benefits received" do
        context "for the tax year 2012" do
          should "give the total amount of benefits received for a full tax year 2012" do
            assert_equal 263.9, ChildBenefitTaxCalculator.new(
              tax_year: "2012",
              children_count: 1,
              is_part_year_claim: "no",
            ).benefits_claimed_amount.round(2)
          end

          should "give the total amount of benefits received for a partial tax year" do
            calculator = ChildBenefitTaxCalculator.new(
              tax_year: "2012",
              children_count: 1,
              is_part_year_claim: "yes",
              part_year_children_count: 1
            )
            calculator.child_benefit_start_dates = {
              "0" => {
                start_date: Date.parse("2012-06-01"),
                end_date: Date.parse("2013-06-01")
                }
              }
            assert_equal 263.9, calculator.benefits_claimed_amount.round(2)
          end
        end

        context "for the tax year 2013" do
          should "give the total amount of benefits received for a full tax year 2013" do
            assert_equal 1055.6, ChildBenefitTaxCalculator.new(
              tax_year: "2013",
              children_count: 1,
              is_part_year_claim: "no",
            ).benefits_claimed_amount.round(2)
          end
        end

        context "for the tax year 2019" do
          should "give the total amount received for the full tax year for one child" do
            assert_equal 1076.4, ChildBenefitTaxCalculator.new(
              tax_year: "2019",
              children_count: 1,
              is_part_year_claim: "no",
            ).benefits_claimed_amount.round(2)
          end
  
          should "give the total amount received for the full tax year for more than one child" do
            assert_equal 1788.8, ChildBenefitTaxCalculator.new(
              tax_year: "2019",
              children_count: 2,
              is_part_year_claim: "no",
            ).benefits_claimed_amount.round(2)
          end
  
          should "give the total amount for a partial tax year for one child" do
            calculator = ChildBenefitTaxCalculator.new(
              tax_year: "2019",
              children_count: 1,
              is_part_year_claim: "yes",
              part_year_children_count: 1
            )
            calculator.child_benefit_start_dates = {
              "0" => {
                start_date: Date.parse("2020-01-06"),
                end_date: Date.parse("2020-04-05")
              }
            }
            assert_equal 269.1, calculator.benefits_claimed_amount.round(2)
          end
  
          should "give the total amount for a partial tax year for more than one child" do
            calculator = ChildBenefitTaxCalculator.new(
                          tax_year: "2019",
                          children_count: 2,
                          is_part_year_claim: "yes",
                          part_year_children_count: 2)

            calculator.child_benefit_start_dates = {
              "0" => { # 18 weeks/Mondays
                start_date: Date.parse("2019-12-2"),
                end_date: Date.parse("2020-04-05")
              },
              "1" => { # 13 weeks/Mondays
                start_date: Date.parse("2020-01-06"),
                end_date: Date.parse("2020-04-05")
              }
            }
            assert_equal 550.7, calculator.benefits_claimed_amount.round(2)
          end
  
          should "give the total amount for three children, two of which are partial tax years" do
            calculator = ChildBenefitTaxCalculator.new(
              tax_year: "2019",
              children_count: 3,
              is_part_year_claim: "yes",
              part_year_children_count: 2)
            calculator.child_benefit_start_dates = {
              "0" => { # 18 weeks/Mondays
                start_date: Date.parse("2019-12-2"),
                end_date: Date.parse("2020-04-05")
              },
              "1" => { # 13 weeks/Mondays
                start_date: Date.parse("2020-01-06"),
                end_date: Date.parse("2020-04-05")
              }
            }
            assert_equal 1501.1, calculator.benefits_claimed_amount.round(2)
          end
        end  
      end
      context "starting and stopping children" do
        context "for the tax year 2012-2013" do
          should "calculate correctly with starting children" do
            calculator = ChildBenefitTaxCalculator.new(
              tax_year: "2012",
              adjusted_net_income: 61000,
              children_count: 1,
              is_part_year_claim: "yes",
              part_year_children_count: 1)

            calculator.child_benefit_start_dates = {
              "0" => {
                start_date: Date.parse("2013-03-01")
              },
            }
            assert_equal 101, calculator.tax_estimate.round(1)
          end
  
          should "not tax before Jan 7th 2013" do
            calculator = ChildBenefitTaxCalculator.new(
              adjusted_net_income: 61000,
              children_count: 1,
              is_part_year_claim: "yes",
              part_year_children_count: 1,
              tax_year: "2012"
            )
            calculator.child_benefit_start_dates = {
              "0" => {
                start_date: Date.parse("2012-05-01"),
              }
            }
            assert_equal 263, calculator.tax_estimate.round(1)
          end
        end
  
        context "for the tax year 2013-2014" do
          should "calculate correctly for 60k income" do
            calculator = ChildBenefitTaxCalculator.new(
              adjusted_net_income: 61000,
              children_count: 1,
              is_part_year_claim: "yes",
              part_year_children_count: 1,
              tax_year: "2013"
            )
            calculator.child_benefit_start_dates = {
              "0" => {
                start_date: Date.parse("2014-02-22"),
              }
            }

            # starting child for 6 weeks
            assert_equal 121, calculator.tax_estimate.round(1)
          end
        end # tax year 2013-14
  
        context "for the tax year 2016-2017" do
          should "calculate correctly with starting children" do
            calculator = ChildBenefitTaxCalculator.new(
              adjusted_net_income: 61000,
              children_count: 1,
              is_part_year_claim: "yes",
              part_year_children_count: 1,
              tax_year: "2016"
            )
            calculator.child_benefit_start_dates = {
              "0" => {
                start_date: Date.parse("2017-03-01")
              }
            }

            # child from 01/03 to 01/04 => 5 weeks * 20.7
            assert_equal 103, calculator.tax_estimate.round(1)
          end
  
          should "correctly calculate weeks for a child who started & stopped in tax year" do
            calculator = ChildBenefitTaxCalculator.new(
              adjusted_net_income: 61000,
              children_count: 1,
              is_part_year_claim: "yes",
              part_year_children_count: 1,
              tax_year: "2016"
            )
            calculator.child_benefit_start_dates = {
              "0" => {
                start_date: Date.parse("2017-02-01"),
                end_date: Date.parse("2017-03-01"),
              }
            }
            # child from 01/02 to 01/03 => 4 weeks * 20.7
            assert_equal 82, calculator.tax_estimate.round(1)
          end
        end # tax year 2016
      end # starting & stopping children

      context "HMRC test scenarios" do
        should "calculate 3 children already in the household for 2012/2013" do
          calculator = ChildBenefitTaxCalculator.new(
            tax_year: "2012",
            children_count: 3,
            is_part_year_claim: "yes",
            part_year_children_count: 3
          )
          
          calculator.child_benefit_start_dates = {
            "0" => {
              start_date: Date.parse("06-01-2013"),
              end_date: Date.parse("05-04-2013"),
            },
            "1" => {
              start_date: Date.parse("06-01-2013"),
              end_date: Date.parse("05-04-2013"),
            },
            "2" => {
              start_date: Date.parse("06-01-2013"),
              end_date: Date.parse("05-04-2013"),
            },
          }

          assert_equal 612.30, calculator.benefits_claimed_amount.round(2)
        end

        should "should calculate 3 children for 2012/2013 one child starting on 7 Jan 2013" do
          calculator = ChildBenefitTaxCalculator.new(
            adjusted_net_income: 56000,
            tax_year: "2012",
            children_count: 3,
            is_part_year_claim: "yes",
            part_year_children_count: 3
          )
          calculator.child_benefit_start_dates = {
            "0" => {
              start_date: Date.parse("06-01-2013"),
              end_date: Date.parse("05-04-2013"),
            },
            "1" => {
              start_date: Date.parse("06-01-2013"),
              end_date: Date.parse("05-04-2013"),
            },
            "2" => {
              start_date: Date.parse("07-01-2013"),
              end_date: Date.parse("05-04-2013"),
            },
          }

          assert_equal 612.30, calculator.benefits_claimed_amount.round(2)
          assert_equal 367, calculator.tax_estimate
        end

        should "calculate two weeks for one child observing the 'Monday' rules." do
          calculator = ChildBenefitTaxCalculator.new(
            tax_year: "2012",
            children_count: 1,
            is_part_year_claim: "yes",
            part_year_children_count: 1
          )
          calculator.child_benefit_start_dates = {
            "0" => {
              start_date: Date.parse("14-01-2013"),
              end_date: Date.parse("21-01-2013")
            }
          }

          assert_equal 40.60, calculator.benefits_claimed_amount.round(2)
        end

        should "should calculate 3 children already in the household for 2013/2014" do
          calculator = ChildBenefitTaxCalculator.new(
            adjusted_net_income: 52000,
            tax_year: "2013",
            children_count: 3,
            is_part_year_claim: "no",
          )
          assert_equal 2449.20, calculator.benefits_claimed_amount.round(2)
          assert_equal 489, calculator.tax_estimate.round(2)
        end

        should "calculate 3 children already in the household for 2013/2014 one stops on 14 June 2013" do
          calculator = ChildBenefitTaxCalculator.new(
            adjusted_net_income: 53000,
            tax_year: "2013",
            children_count: 3,
            is_part_year_claim: "yes",
            part_year_children_count: 1
          )

          calculator.child_benefit_start_dates = {
            "0" => {
              start_date: Date.parse("06-04-2013"),
              end_date: Date.parse("14-06-2013")
            }
          }
          assert_equal 1886.40, calculator.benefits_claimed_amount.round(2)
          assert_equal 565.0, calculator.tax_estimate.round(2)
        end

        should "give an accurate figure for 40 weeks at £20.30" do
          calculator = ChildBenefitTaxCalculator.new(
            adjusted_net_income: 61000,
            tax_year: "2013",
            children_count: 1,
            is_part_year_claim: "yes",
            part_year_children_count: 1
          )

          calculator.child_benefit_start_dates = {
            "0" => {
              start_date: Date.parse("01-07-2013")
            }
          }

          assert_equal 812.0, calculator.benefits_claimed_amount
          assert_equal 812, calculator.tax_estimate
        end

        context "tests for 2014 rates" do
          should "calculate 3 children already in the household for all of 2014/15" do
            calculator = ChildBenefitTaxCalculator.new(
              tax_year: "2014",
              children_count: 3,
              is_part_year_claim: "no",
            )
            assert_equal 2475.2, calculator.benefits_claimed_amount.round(2)
          end

          should "give the total amount of benefits received for a full tax year 2014" do
            calculator = ChildBenefitTaxCalculator.new(
              tax_year: "2014",
              children_count: 1,
              is_part_year_claim: "no",
            )
            assert_equal 1066.0, calculator.benefits_claimed_amount.round(2)
          end

          should "give total amount of benefits one child full year one child half a year" do
            calculator = ChildBenefitTaxCalculator.new(
              tax_year: "2014",
              children_count: 2,
              is_part_year_claim: "yes",
              part_year_children_count: 1
            )

            calculator.child_benefit_start_dates = {
              "0" => {
                start_date: Date.parse("06-04-2014"),
                end_date: Date.parse("06-11-2014")
              }
            }
            assert_equal 1486.05, calculator.benefits_claimed_amount.round(2)
          end

          should "give total amount of benefits for one child for half a year" do
            calculator = ChildBenefitTaxCalculator.new(
              tax_year: "2014",
              children_count: 1,
              is_part_year_claim: "yes",
              part_year_children_count: 1
            )
            calculator.child_benefit_start_dates = {
              "0" => {
                start_date: Date.parse("06-04-2014"),
                end_date: Date.parse("06-11-2014")
              },
            }
            assert_equal 635.5, calculator.benefits_claimed_amount.round(2)
          end
        end #tests for 2014 rates

        context "tests for 2015 rates" do
          should "calculate 3 children already in the household for all of 2015/16" do
            calculator = ChildBenefitTaxCalculator.new(
              tax_year: "2015",
              children_count: 3,
              is_part_year_claim: "no",
            )
            assert_equal 2549.3, calculator.benefits_claimed_amount.round(2)
          end
  
          should "give the total amount of benefits received for a full tax year 2015" do
            calculator = ChildBenefitTaxCalculator.new(
              tax_year: "2015",
              children_count: 1,
              is_part_year_claim: "no",
            )
            assert_equal 1097.1, calculator.benefits_claimed_amount.round(2)
          end
          
          should "give total amount of benefits one child full year one child half a year" do
            calculator = ChildBenefitTaxCalculator.new(
              tax_year: "2015",
              children_count: 2,
              is_part_year_claim: "yes",
              part_year_children_count: 1
            )
            calculator.child_benefit_start_dates = {
                "0" => {
                  start_date: Date.parse("06-04-2015"),
                  end_date: Date.parse("06-11-2016")
                }
              }
            assert_equal 1823.2, calculator.benefits_claimed_amount.round(2)
          end

          should "give total amount of benefits for one child for half a year" do
            calculator = ChildBenefitTaxCalculator.new(
              tax_year: "2015",
              children_count: 1,
              is_part_year_claim: "yes",
              part_year_children_count: 1
            )
            calculator.child_benefit_start_dates = {
              "0" => {
                start_date: Date.parse("06-04-2015"),
                end_date: Date.parse("06-11-2015")
              }
            }

            assert_equal 641.7, calculator.benefits_claimed_amount.round(2)
          end
        end # tests for 2015 rates
  


        context "tests for 2016 rates" do
          should "calculate 3 children already in the household for all of 2016/17" do
            calculator = ChildBenefitTaxCalculator.new(
              tax_year: "2016",
              children_count: 3,
              is_part_year_claim: "no",
            )
            assert_equal 2501.2, calculator.benefits_claimed_amount.round(2)
          end
  
          should "give the total amount of benefits received for a full tax year 2016" do
            calculator = ChildBenefitTaxCalculator.new(
              tax_year: "2016",
              children_count: 1,
              is_part_year_claim: "no",
            )
            assert_equal 1076.4, calculator.benefits_claimed_amount.round(2)
          end
  
          should "give total amount of benefits one child full year one child half a year" do
            calculator = ChildBenefitTaxCalculator.new(
              tax_year: "2016",
              children_count: 2,
              is_part_year_claim: "yes",
              part_year_children_count: 1
            )
            calculator.child_benefit_start_dates = {
              "0" => {
                start_date: Date.parse("06-04-2016"),
                end_date: Date.parse("06-10-2016"),
              }
            }
            assert_equal 1432.6, calculator.benefits_claimed_amount.round(2)
          end
  
          should "give total amount of benefits for one child for half a year" do
            calculator = ChildBenefitTaxCalculator.new(
              tax_year: "2016",
              children_count: 1,
              is_part_year_claim: "yes",
              part_year_children_count: 1
            )
            calculator.child_benefit_start_dates = {
              "0" => {
                start_date: Date.parse("06-04-2016"),
                end_date: Date.parse("06-11-2016")
              }
            }

            assert_equal 621.0, calculator.benefits_claimed_amount.round(2)
          end
  
          should "set the start date to start of the selected tax year" do
            calculator = ChildBenefitTaxCalculator.new(
              tax_year: "2016",
              children_count: 1,
              is_part_year_claim: "no",
            )
  
            assert_equal Date.parse("06 April 2016"), calculator.child_benefit_start_date
            assert_equal Date.parse("05 April 2017"), calculator.child_benefit_end_date
          end
  
          should "set the stop date to end of the selected tax year" do
            calculator = ChildBenefitTaxCalculator.new(
              tax_year: "2016",
              children_count: 1,
              is_part_year_claim: "yes",
              part_year_children_count: 1
            )
            calculator.child_benefit_start_dates = {
              "0" => {
                start_date: Date.parse("06-04-2016")
              }
            }

            assert_equal Date.parse("05 April 2017"), calculator.child_benefit_end_date
          end
  
          should "correctly calculate the benefit amount for multiple full year and part year children" do
            calculator = ChildBenefitTaxCalculator.new(
              tax_year: "2016",
              children_count: 4,
              is_part_year_claim: "yes",
              part_year_children_count: 2
            )
            calculator.child_benefit_start_dates = {
              "0" => {
                start_date: Date.parse("01-06-2016"),
                end_date: Date.parse("01-09-2016")
              },
              "1" => {
                start_date: Date.parse("01-01-2017"),
                end_date: Date.parse("01-04-2017")
              }
            }
            
            assert_equal 2145, calculator.benefits_claimed_amount.round(2)
          end
        end # tests for 2016 rates      
      end # HMRC test scenarios
    end # ChildBenefitTaxCalculator
  end
end
