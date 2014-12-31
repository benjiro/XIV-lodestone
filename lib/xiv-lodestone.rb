require 'nokogiri'
require 'open-uri'

module XIVLodestone
  class CharacterNotFound < RuntimeError
  end

  class MoreThanOneCharacter < RuntimeError
  end
    
  class Helper
    def self.open_url(name, server)
      search = Nokogiri::HTML(open_character_url(name, server))

      raise CharacterNotFound, 'Character not found' if !search.at_xpath('//h4/a')
      raise MoreThanOneCharacter, 'Multiple characters found' if search.xpath('//h4/a').size > 1
       
      page = Nokogiri::HTML(open_id_url(search.xpath('//h4/a')[0]['href'].split(/\//).last))
    end

    def self.open_id(id)
      page = Nokogiri::HTML(open_id_url(id))
    end

    def self.open_character_url(name, server)
      open("http://na.finalfantasyxiv.com/lodestone/character/?q=#{name}&worldname=#{server}")
    end

    def self.open_id_url(id)
      open("http://na.finalfantasyxiv.com/lodestone/character/#{id}")
    end

    private_class_method :open_character_url, :open_id_url
  end

  class Character
  end

end

