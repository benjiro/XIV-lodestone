require 'xiv_lodestone/lodestone_helper'
require 'xiv_lodestone/lodestone_parser'

module XIVLodestone
  # This class is a representation of a FFXIV:ARR character,
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
      generate_character(parser)
    end

    def generate_character(parser)
      @classes = parser.get_classes
      @attributes = parser.get_attributes
      @gear = parser.get_gear
      @hp = parser.get_hp
      @mp = parser.get_mp
      @tp = parser.get_tp
      @sex = parser.get_sex
      @race = parser.get_race
      @clan = parser.get_clan
      @nameday = parser.get_nameday
      @guardian = parser.get_guardian
      @city = parser.get_city
      @grand = parser.get_grand_company
      @free = parser.get_free_company
      parser = nil
    end

    private :generate_character
  end
end
