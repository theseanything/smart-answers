module SmartAnswer::Calculators
  class ArrestedAbroad
    # created for the help-if-you-are-arrested-abroad calculator
    attr_reader :country

    PRISONER_PACKS = YAML.load_file(Rails.root.join("config/smart_answers/prisoner_packs.yml")).freeze
    COUNTRIES_WITH_REGIONS = %w[cyprus].freeze
    COUNTRIES_WITHOUT_TRANFSERS_BACK = %w[austria
                                          belgium
                                          croatia
                                          denmark
                                          finland
                                          hungary
                                          italy
                                          latvia
                                          luxembourg
                                          malta
                                          netherlands
                                          slovakia].freeze

    def initialize(country)
      @country = country
    end

    def country_data
      @country_data ||= PRISONER_PACKS.find { |c| c["slug"] == country }
    end

    def generate_url_for_download(field, text)
      return "" unless country_data && country_data[field]

      urls = country_data[field].split(" ")
      output = urls.map do |url|
        new_link = "- [#{text}](#{url})"
        new_link += '{:rel="external"}' if url.include? "http"
        new_link
      end
      output.join("\n")
    end

    def get_country_regions
      country_data["regions"]
    end

    def location
      @location ||= WorldLocation.find(country)
      raise InvalidResponse unless @location

      @location
    end

    def organisation
      location.fco_organisation
    end

    def country_name
      location.name
    end

    def pdf
      generate_url_for_download("pdf", "Prisoner pack for #{country_name}")
    end

    def doc
      generate_url_for_download("doc", "Prisoner pack for #{country_name}")
    end

    def benefits
      generate_url_for_download("benefits", "Benefits or legal aid in #{country_name}")
    end

    def prison
      generate_url_for_download("prison", "Information on prisons and prison procedures in #{country_name}")
    end

    def judicial
      generate_url_for_download("judicial", "Information on the judicial system and procedures in #{country_name}")
    end

    def police
      generate_url_for_download("police", "Information on the police and police procedures in #{country_name}")
    end

    def consul
      generate_url_for_download("consul", "Consul help available in #{country_name}")
    end

    def lawyer
      generate_url_for_download("lawyer", "English speaking lawyers and translators/interpreters in #{country_name}")
    end

    def has_extra_downloads
      extra_downloads = [police, judicial, consul, prison, lawyer, benefits, doc, pdf]

      extra_downloads.any?(&:present?) || COUNTRIES_WITH_REGIONS.include?(country)
    end

    def region_downloads
      return "" unless COUNTRIES_WITH_REGIONS.include?(country)

      links = get_country_regions.values.map do |region|
        "- [#{region['url_text']}](#{region['link']})"
      end

      links.join("\n")
    end

    def transfer_back
      COUNTRIES_WITHOUT_TRANFSERS_BACK.exclude?(country)
    end
  end
end
