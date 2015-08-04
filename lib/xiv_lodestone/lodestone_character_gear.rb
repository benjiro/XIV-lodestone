require 'nokogiri'
require 'json'
require 'xiv_lodestone/lodestone_helper'

module XIVLodestone
  # A Object that represents a list of Gear pieces
  # The initialiser takes a hash of items in the following layout
  # { :weapon => ["Fist", 110, "Weapon", "http://...."], ... }
  class GearList
    # This struct representation a piece of gear.
    Gear = Struct.new(:name, :ilevel, :slot, :url)

    def initialize(gear_path)
      @items = {}
      parse_gear(gear_path)
    end
    # Calculates the total gear list ilevel
    # Rounds to the nearest whole number like FFXIV ingame calculation
    # returns a #Integer
    def ilevel()
      ilevel = 0
      ilevel = @items[:weapon].ilevel if @items[:shield].nil?
      @items.each_value do |value|
        ilevel += value.ilevel unless value.name =~ /Soul of the/i
      end
      (ilevel/13).round
    end
    # Returns a JSON string of all items
    def to_json()
      @items.to_json
    end
    # Generates access methods for each item slot
    def method_missing(method)
      return @items[method] if @items.key?(method)
      super
    end
    #### Private Methods ####
    # Parses each piece of gear and stores it in @items hash
    def parse_gear(gear_path)
      gear_path.each do |item|
        @items[type(item.at_css('h3.category_name').text).to_sym] = Gear.new(
          item.css('h2').text.delete!("\n\t"),
          item.at_css('div.pt3.pb3').text.split(/ /).last.to_i,
          item.at_css('h3').text,
        "http://na.finalfantasyxiv.com#{item.at_css('a')['href']}")
      end
    end
    # Returns a string representation of item slot
    def type(name)
      if name =~ /(Arm|Arms|Grimoire|Primary Tool)/i
        return "weapon"
      elsif name =~ /Shield/i
        return "shield"
      elsif name.eql?("Ring")
        return "ring#{ring_inc}"
      else
        return Helper.replace_downcase(name)
      end
    end
    # Initialise @num and count upwards, if @num >= 2 reset to 1
    # @num += 1 reset if @num >= 2
    def ring_inc()
      @num ||= 0
      @num = 0 if @num >= 2
      @num += 1
    end

    private :parse_gear, :type, :ring_inc
  end
end
