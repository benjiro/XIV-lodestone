require 'nokogiri'
require 'oj'

module XIVLodestone
  # A Object that represents a list of Gear pieces
  # The initialiser takes a hash of items in the following layout
  # { :weapon => ["Fist", 110, "Weapon", "http://...."], ... }
  class GearList
    def initialize(gear_path)
      @items = Hash.new
      parse_gear(gear_path)
    end
    # Calculates the total gear list ilevel
    # Rounds to the nearest whole number like FFXIV ingame calculation
    # returns a #Integer
    def ilevel()
      ilevel = 0
      ilevel = @items[:weapon].ilevel if Helper.is_2hand_weapon(@items[:weapon].slot)
      @items.each_value do |value|
        ilevel += value.ilevel
      end
      (ilevel/13).round
    end
    # Uses gem Oj to dump GearList Object to JSON
    def to_json()
      Oj.dump(@items)
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
          item.css('h2').text,
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
        return name.downcase
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

    # A object representation of a peacie of gear.
    class Gear
      attr_reader :name, :ilevel, :slot, :url

      def initialize(name, ilevel, slot, url)
        @name = name
        @ilevel = ilevel
        @slot = slot
        @url = url
      end
    end
  end
end
