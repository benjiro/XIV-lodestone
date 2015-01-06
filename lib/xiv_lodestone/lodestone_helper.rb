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
      if args.count == 1 && args.all? {|x| x.is_a? Fixnum}
        return Helper.open_id(args.first)
      elsif args.count == 1 && args.all? {|x| x.is_a? String}
        return Helper.open_url(args.first, "")
      elsif args.count == 2 && args.all? {|x| x.is_a? String}
        return Helper.open_url(args.at(0), args.at(1))
      else
        fail ArgumentError, "Invalid Arguments: player_id(Fixnum) or player_name(String), server_name(String)]"
      end
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
