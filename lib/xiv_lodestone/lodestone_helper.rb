require 'nokogiri'
require 'open-uri'

module XIVLodestone
  # RuntimeError if a character can't be found
  class CharacterNotFound < RuntimeError
  end
  # RuntimeError if more than one character is found
  class MoreThanOneCharacter < RuntimeError
  end
  # A class of helper methods
  class Helper
    # Validates arguments and calls corresponding method
    # Invalid arguments will rase a ArgumentError
    def self.process_args(args)
      return Helper.open_id(args[:id]) if args.key?(:id)
      return Helper.open_url(args[:name], "") if args.key?(:name)
      return Helper.open_url(args[:name], args[:server]) if args.size == 2
      fail ArgumentError, "Invalid arguments passed"
    end
    # Find a character profile from a given name and
    # server. Returns a Nokogiri XML document of the
    # characters page.
    def self.open_url(name, server)
      page = Nokogiri::HTML(open_character_url(name, server))
      check_valid_url(page)
      id = page.xpath('//h4/a')[0]['href'].split(/\//).last
      Nokogiri::HTML(open_id_url(id))
    end
    # Find a characters profiles from a given id.
    # Returns a Nokogiri XML document of the characters
    # page.
    def self.open_id(id)
      Nokogiri::HTML(open_id_url(id))
    end
    # Checks string if two handed weapon type
    # returns true if two handed weapon type
    def self.is_2hand_weapon(name)
      (name =~ /(Arm|Arms|Grimoire|Primary Tool)/i) ? true : false
    end
    # Replaces spaces wtih underscores, and downcases
    # Returns a #String
    def self.replace_downcase(string)
      string.gsub(" ", "_").downcase
    end
    # Returns a #String of the character portrait
    def self.get_server(page)
      page.at_xpath('//h2/span').text.strip.gsub(/\(|\)/, "")
    end
    # Returns a #String of the character portrait
    def self.get_portrait(page)
      page.at_xpath('//div[@class="img_area bg_chara_264"]/img')['src']
    end
    # Returns a #String of the character name
    def self.get_name(page)
      page.at_xpath('//h2/a').text
    end
    # Returns a #String of character title
    def self.get_title(page)
      page.at_xpath('//h2/div').text
    end
    # Returns a #String of character introduction
    def self.get_introduction(page)
      page.at_xpath('//div[@class="area_inner_body txt_selfintroduction"]').text.strip!
    end
    # Returns a #Integer of the characters hp
    def self.get_hp(page)
      page.at_xpath('//li[@class="hp"]').text.to_i
    end
    # Returns a #Integer of the characters mp
    def self.get_mp(page)
      page.at_xpath('//li[@class="mp"]').text.to_i
    end
    # Returns a #Integer of the characters tp
    def self.get_tp(page)
      page.at_xpath('//li[@class="tp"]').text.to_i
    end
    # Returns a #String of the characters sex
    # example "Male" or "Female"
    def self.get_sex(page)
      page.at_xpath('//div[@class="chara_profile_title"]').text.split(/\//).last =~ /♂/i ? "Male" : "Female"
    end
    # Returns a #String of the characters race
    def self.get_race(page)
      page.at_xpath('//div[@class="chara_profile_title"]').text.split(/\//).first.strip!
    end
    # Returns a #String of the characters clan
    def self.get_clan(page)
      page.at_xpath('//div[@class="chara_profile_title"]').text.split(/\//)[1].strip!
    end
    # Returns a #String with the nameday
    def self.get_nameday(page)
      page.at_xpath('(//div[@class="chara_profile_table"]/dl/dd)[1]').text
    end
    # Returns a #String with the guardian name
    def self.get_guardian(page)
      page.at_xpath('(//div[@class="chara_profile_table"]/dl/dd)[2]').text
    end
    # Returns a #String the city name
    def self.get_city(page)
      page.at_xpath('(//dd[@class="txt_name"])[1]').text
    end
    # Returns a #String with the grandcompany
    def self.get_grand_company(page)
      page.at_xpath('(//dd[@class="txt_name"])[2]').text
    end
    # Returns a #Array with the freecompany name and url
    def self.get_free_company(page)
      element = page.at_xpath('//dd[@class="txt_name"]/a')
      [ element.text, "http://na.finalfantasyxiv.com#{element['href']}" ]
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
      fail MoreThanOneCharacter if page.xpath('//h4/a').size > 1
    end

    private_class_method :open_character_url, :open_id_url
    private_class_method :check_valid_url
  end
end
