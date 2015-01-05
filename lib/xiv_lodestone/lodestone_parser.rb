require 'nokogiri'

module XIVLodestone
  class Parser
    # An exception for a invalid Nokogiri page
    class InvalidDocument < Exception
    end
    # default constructor, initalises @page with a
    # Nokogiri document. Raises a InvalidDocument eception
    # if page is invalid
    def initialize(page)
      fail InvalidDocument, 'Invalid page' if page.nil?
      @page = page
    end
    # Returns a #Hash of the characters class levels
    # Example { :Gladitor => 10, ... }
    # If no classes found returns a empty #Hash
    def get_classes()
      class_list = Hash.new
      @page.xpath('//table[@class="class_list"]/tr/td').each_slice(3) do |td|
        # Not a valid class
        next if td[0].text.empty?
        exp = td[2].text.split(/\//)

        class_list[td[0].text.downcase.to_sym] = [td[0].text,
          td[1].text.to_i,
          exp[0].to_i,
          exp[1].to_i,
          td[0].at_css('img')['src']]
      end
      class_list
    end
    # Returns a #Hash of the character attributes
    # Example { :str => 243, ... }
    # If no attributes found returns a empty #Hash
    def get_attributes()
      stats = Hash.new
      @page.xpath('//div[starts-with(@class, "param_left_area_inner")]/ul/li').each_with_index do |li, index|
        if index < 6
          stats[replace_downcase(li['class']).to_sym] = li.text.to_i
        else
          ele = li.text.split(/(?<=\D)(?=\d)/)
          stats[replace_downcase(ele[0]).to_sym] = ele[1].to_i
        end
      end
      stats
    end
    # Returns a #Hash of the characters gear list
    # Example { :head => [ "item_name", "item_url" ], ... }
    # If no gear found returns a empty #Hash
    def get_gear()
      items = Hash.new
      @page.xpath("(//div[@class='item_detail_box'])[position() < 13]").each do |item|
        type = get_item_type(item.at_css('h3.category_name').text)
        items[type.to_sym] = [ item.css('h2').text,
          item.at_css('div.pt3.pb3').text.split(/ /).last.to_i,
          item.at_css('h3.category_name').text,
          "http://na.finalfantasyxiv.com#{item.css('a')[0]['href']}" ]
      end
      items
    end
    # Returns a #Integer of the characters hp
    # otherwise returns nil
    def get_hp()
      hp = @page.at_xpath('//li[@class="hp"]')
      hp.nil? ? nil : hp.text.to_i
    end
    # Returns a #Integer of the characters mp
    # otherwise returns nil
    def get_mp()
      mp = @page.at_xpath('//li[@class="mp"]')
      mp.nil? ? nil : mp.text.to_i
    end
     # Returns a #Integer of the characters tp
    # otherwise returns nil
    def get_tp()
      tp = @page.at_xpath('//li[@class="tp"]')
      tp.nil? ? nil : tp.text.to_i
    end
    # Returns a #String of the characters sex
    # example "Male" or "Female"
    # otherwise returns nil
    def get_sex()
      sex = @page.at_xpath('//div[@class="chara_profile_title"]')
      if sex.nil?
        nil
      else
        sex.text.split(/\//).last =~ /♂/i ? "Male" : "Female"
      end
    end
    # Returns a #String of the characters race
    # otherwise returns nil
    def get_race()
      race = @page.at_xpath('//div[@class="chara_profile_title"]')
      race.nil? ? nil : race.text.split(/\//).first.strip!
    end
    # Returns a #String of the characters clan
    # otherwise returns nil
    def get_clan()
      clan = @page.at_xpath('//div[@class="chara_profile_title"]')
      clan.nil? ? nil : clan.text.split(/\//)[1].strip!
    end
    # Returns a #String with the nameday
    # otherwise returns nil
    def get_nameday()
      nameday = @page.at_xpath('(//div[@class="chara_profile_table"]/dl/dd)[1]')
      nameday.nil? ? nil : nameday.text
    end
    # Returns a #String with the guardian name
    # otherwise returns nil
    def get_guardian()
      guardian = @page.at_xpath('(//div[@class="chara_profile_table"]/dl/dd)[2]')
      guardian.nil? ? nil : guardian.text
    end
    # Returns a #String the city name
    # otherwise returns nil
    def get_city()
      city = @page.at_xpath('(//dd[@class="txt_name"])[1]')
      city.nil? ? nil : city.text
    end
    # Returns a #String with the grandcompany
    # otherwise returns nil
    def get_grand_company()
      company = @page.at_xpath('(//dd[@class="txt_name"])[2]')
      company.nil? ? nil : company.text
    end
    # Returns a #Array with the freecompany name and url
    # otherwise returns nil
    def get_free_company()
      element = @page.at_xpath('//dd[@class="txt_name"]/a')
      element.nil? ? nil : [ element.text, "http://na.finalfantasyxiv.com#{element['href']}" ]
    end
    # Replaces spaces wtih underscores, and downcases
    # Returns a #String
    def replace_downcase(string)
      string.gsub(" ", "_").downcase
    end
    # Auto-increaments between 1 and 2
    def ring
      @num ||= 0
      @num = 0 if @num >= 2
      @num += 1
    end
    # Returns a string representing what item type it is
    def get_item_type(item_name)
      if item_name =~ /(Arm|Arms|Grimoire|Primary Tool)/i
        return "weapon"
      elsif item_name =~ /Shield/i
        return "shield"
      elsif item_name.eql?("Ring")
        return "ring#{ring}"
      else
        return item_name.downcase
      end
    end
    private :replace_downcase, :ring, :get_item_type
  end
end
