require 'xiv_lodestone/lodestone_helper'
require 'xiv_lodestone/lodestone_parser'

module XIVLodestone
  # A Object that representation a FFXIV:ARR character,
  # all information is obtained from the lodestone website.
  class Character
    def initialize(*args)
      parser = nil
      if args.count == 1 && args.all? {|x| x.is_a? Fixnum}
        parser = Parser.new(Helper.open_id(args.first))
      elsif args.count == 2 && args.all? {|x| x.is_a? String}
        parser = Parser.new(Helper.open_url(args.at(0), args.at(1)))
      else
        fail ArgumentError, "Invalid Arguments: player_id(Fixnum) or player_name(String), server_name(String)]"
      end

      @profile = Hash.new
      @profile[:disciple] = DiscipleList.new(parser.get_classes)
      @profile[:gear] = GearList.new(parser.get_gear)
      @profile.merge!(parser.get_attributes)
      @profile.merge!(parser.get_profile)

      parser = nil #Close the reference so Nokogiri cleans up itself
    end
    # Returns a #String with characters first name
    def first_name()
      @profile[:name].split(/ /).first
    end
    # Returns a #String with characters last name
    def last_name()
      @profile[:name].split(/ /).last
    end

    def method_missing(method)
      return @profile[method] if @profile.key?(method)
      super
    end
  end
  # A Object that represents a list of Gear pieces
  # The initialiser takes a hash of items in the following layout
  # { :weapon => ["Fist", 110, "Weapon", "http://...."], ... }
  class GearList
    def initialize(gear_list)
      @list = Hash.new
      gear_list.each do |key, value|
        gear = Gear.new(value[0], value[1], value[2], value[3])
        @list[key] = gear
      end
    end
    # Calculates the total gear list ilevel
    # Rounds to the nearest whole number like FFXIV ingame calculation
    # returns a #Integer
    def ilevel()
      ilevel = 0
      ilevel = @list[:weapon].ilevel if Helper.is_2hand_weapon(@list[:weapon].slot)
      @list.each_value do |value|
        ilevel += value.ilevel
      end
      (ilevel/13).round
    end
    # Generates access methods for each item slot
    def method_missing(method)
      return @list[method] if @list.key?(method)
      super
    end
    # A object representation of a peacie of gear.
    # TODO Add more information
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
  # A object representation of disciples(classes)
  # The initialiser takes a hash of Disciple, that layout follows
  # { :rogue => ["Rogue", 1, 0, 300, "http://..."] }
  class DiscipleList
    def initialize(disciple_list)
      @list = Hash.new
      disciple_list.each do |key, value|
        disciple = Disciple.new(value[0], value[1], value[2], value[3], value[4])
        @list[key.to_sym] = disciple
      end
      # Generates access methods for each disciple slot
      def method_missing(method)
        return @list[method] if @list.key?(method)
        super
      end
    end
    # A object representation of a disciple
    class Disciple
      attr_reader :name, :level, :current_exp, :total_exp, :icon_url

      def initialize(name, level, curr, req, icon)
        @name = name
        @level = level
        @current_exp = curr
        @total_exp = req
        @icon_url = icon
      end
      # Returns the required experience to the next level
      def next_level()
        @total_exp - @current_exp
      end
    end
  end
end
