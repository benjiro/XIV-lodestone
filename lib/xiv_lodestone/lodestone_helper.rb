require 'nokogiri'
require 'open-uri'

module XIVLodestone
  # RuntimeError if a character can't be found
  class CharacterNotFound < RuntimeError
  end
  # A class of helper methods
  class Helper
    # Validates arguments and calls corresponding method
    # Invalid arguments will rase a ArgumentError
    def self.process_args(args)
      return Helper.open_id(args[:id]) if args.key?(:id)
      return Helper.open_url(args[:name], args[:server]) if args.size == 2
      return Helper.open_url(args[:name], "") if args.key?(:name)
      fail ArgumentError, "Invalid arguments passed"
    end
    # Opens the FFXIV server status page
    # returns a Nokogiri document
    def self.open_server_status()
      Nokogiri::HTML(open("http://na.finalfantasyxiv.com/lodestone/worldstatus/"))
    end
    # Opens the FFXIV registration page
    # returns a Nokogiri document
    def self.open_registration_status()
      Nokogiri::HTML(open("http://na.finalfantasyxiv.com/lodestone/news/detail/80cd4583bf743600105b947d6906d0909189e479"))
    end
    # Find a character profile from a given name and
    # server. Returns a Nokogiri XML document of the
    # characters page.
    def self.open_url(name, server)
      page = Nokogiri::HTML(open_character_url(name, server))
      check_valid_url(page)
      id = page.at_xpath('//h4/a')['href'].split(/\//).last
      Nokogiri::HTML(open_id_url(id))
    end
    # Find a characters profiles from a given id.
    # Returns a Nokogiri XML document of the characters
    # page.
    def self.open_id(id)
      Nokogiri::HTML(open_id_url(id))
    end
    # Replaces spaces wtih underscores, and downcases
    # Returns a #String
    def self.replace_downcase(string)
      string.gsub(" ", "_").downcase
    end
    # Returns a #String of the character portrait
    def self.get_server(page)
      server = page.at_xpath('//h2/span')
      server ? server.text.strip.gsub(/\(|\)/, "") : ""
    end
    # Returns a #String of the character portrait
    def self.get_portrait(page)
      port = page.at_xpath('//div[@class="img_area bg_chara_264"]/img')
      port ? port['src'] : ""
    end
    # Returns a #String of the character name
    def self.get_name(page)
      name = page.at_xpath('//h2/a')
      name ? name.text : ""
    end
    # Returns a #String of character title
    def self.get_title(page)
      title = page.at_xpath('//h2/div')
      title ? title.text : ""
    end
    # Returns a #String of character introduction
    def self.get_introduction(page)
      intro = page.at_xpath('//div[@class="area_inner_body txt_selfintroduction"]')
      intro ? intro.text.strip! : ""
    end
    # Returns a #Integer of the characters hp
    def self.get_hp(page)
      hp = page.at_xpath('//li[@class="hp"]')
      hp ? hp.text.to_i : 0
    end
    # Returns a #Integer of the characters mp
    def self.get_mp(page)
      mp = page.at_xpath('//li[@class="mp"]')
      mp ? mp.text.to_i : 0
    end
    # Returns a #Integer of the characters tp
    def self.get_tp(page)
      tp = page.at_xpath('//li[@class="tp"]')
      tp ? tp.text.to_i : 0
    end
    # Returns a #String of the characters sex
    # example "Male" or "Female"
    def self.get_sex(page)
      sex = page.at_xpath('//div[@class="chara_profile_title"]').text.split(/\//).last =~ /♂/i ? "Male" : "Female"
    end
    # Returns a #String of the characters race
    def self.get_race(page)
      race = page.at_xpath('//div[@class="chara_profile_title"]')
      race ? race.text.split(/\//).first.strip! : ""
    end
    # Returns a #String of the characters clan
    def self.get_clan(page)
      clan = page.at_xpath('//div[@class="chara_profile_title"]')
      clan ? clan.text.split(/\//)[1].strip! : ""
    end
    # Returns a #String with the nameday
    def self.get_nameday(page)
      nameday = page.at_xpath('(//dd[@class="txt_name"])[1]')
      nameday ? nameday.text : ""
    end
    # Returns a #String with the guardian name
    def self.get_guardian(page)
      guardian = page.at_xpath('(//dd[@class="txt_name"])[2]')
      guardian ? guardian.text : ""
    end
    # Returns a #String the city name
    def self.get_city(page)
      city = page.at_xpath('(//dd[@class="txt_name"])[3]')
      city ? city.text : ""
    end
    # Returns a #String with the grandcompany
    def self.get_grand_company(page)
      company = page.at_xpath('(//dd[@class="txt_name"])[4]')
      company ? company.text : ""
    end
    # Returns a #Array with the freecompany name and url
    def self.get_free_company(page)
      element = page.at_xpath('//dd[@class="txt_name"]/a')
      element ? [ element.text, "http://na.finalfantasyxiv.com#{element['href']}" ] : [ "", "" ]
    end
    # Open a URL with the given name and server.
    # Returns a file stream.
    def self.open_character_url(name, server)
      open('http://na.finalfantasyxiv.com/lodestone/character/' \
           "?q=#{name}&worldname=#{server}")
    end
    # Open a URL with the given id.
    # Reutrn a file stream.
    def self.open_id_url(id)
      open("http://na.finalfantasyxiv.com/lodestone/character/#{id}")
    end
    # Validates a Nokogiri document for a character.
    # Throws a CharacterNotFound exception.
    # Throws a MoreThanOneCharacter exception.
    def self.check_valid_url(page)
      fail CharacterNotFound unless page.at_xpath('//h4/a')
    end

    private_class_method :open_character_url, :open_id_url
    private_class_method :check_valid_url
  end
end
