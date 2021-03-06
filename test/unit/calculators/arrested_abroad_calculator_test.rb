require_relative "../../test_helper"

module SmartAnswer::Calculators
  class ArrestedAbroadCalculatorTest < ActiveSupport::TestCase
    context ArrestedAbroad do
      context "generating a URL" do
        should "not error if the country doesn't exist" do
          assert_nothing_raised do
            calc = ArrestedAbroad.new("doesntexist")
            calc.generate_url_for_download("pdf", "hello world")
          end
        end

        should "generate link if country exists" do
          calc = ArrestedAbroad.new("argentina")
          link = calc.generate_url_for_download("pdf", "Prisoner pack")
          assert_equal "- [Prisoner pack](/government/publications/argentina-prisoner-pack)", link
        end

        should "not include external tag if URL is internal" do
          calc = ArrestedAbroad.new("israel")
          link = calc.generate_url_for_download("pdf", "Foo")
          assert_not link.include?("{:rel=\"external\"}")
        end
      end

      context "has extra downloads" do
        should "return true for countries with regions" do
          calc = ArrestedAbroad.new("cyprus")
          calc.stubs(:country_name).returns("Cyprus")
          assert calc.has_extra_downloads
        end

        should "return false if not a country with regions nor has extra download links" do
          calc = ArrestedAbroad.new("bermuda")
          calc.stubs(:country_name).returns("Bermuda")
          assert_not calc.has_extra_downloads
        end

        should "return true if country has extra download links" do
          calc = ArrestedAbroad.new("australia")
          calc.stubs(:country_name).returns("Australia")
          assert calc.has_extra_downloads
        end
      end

      context "region downloads" do
        should "return list of region links for countries with regions" do
          calc = ArrestedAbroad.new("cyprus")
          calc.stubs(:get_country_regions).returns({
            "a": { "url_text" => "Text 1", "link" => "link1" },
            "b": { "url_text" => "Text 2", "link" => "link2" },
          })
          assert_equal calc.region_downloads, "- [Text 1](link1)\n- [Text 2](link2)"
        end

        should "return empty for countries without regions" do
          calc = ArrestedAbroad.new("bermuda")
          assert_equal calc.region_downloads, ""
        end
      end

      context "countries with regions" do
        should "pull out regions of the YML for Cyprus" do
          calc = ArrestedAbroad.new("cyprus")
          resp = calc.get_country_regions
          assert resp["north"]
          assert resp["north_lawyer"]
          assert resp["republic"]
          assert resp["republic_lawyers"]
        end

        should "pull the regions out of the YML for Cyprus" do
          calc = ArrestedAbroad.new("cyprus")
          resp = calc.get_country_regions["north"]
          expected = {
            "link" => "/government/publications/cyprus-north-prisoner-pack",
            "url_text" => "Prisoner pack for the north of Cyprus",
          }
          assert_equal expected, resp
        end
      end
    end
  end
end
