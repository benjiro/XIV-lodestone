require 'xiv_lodestone/lodestone_helper'
require 'xiv_lodestone/lodestone_character_gear'
require 'xiv_lodestone/lodestone_character_disciple'
require 'xiv_lodestone/lodestone_character_attribute'
require 'xiv_lodestone/lodestone_character_collectable'
require 'json'

module XIVLodestone
  # A Object that represents a FFXIV:ARR character,
  # all information is obtained from the lodestone website.
  class Character
    # default constructor, handles styles of arguments
    # 1. Character.new(:name => "CHARACTER_NAME", :server => "SERVER_NAME")
    # 2. Character.new(:name => "CHARACTER_NAME")
    # 3. Character.new(:id => ID_NUMBER)
    def initialize(args = {})
      @profile = Hash.new
      initialise_profile(Helper.process_args(args))
    end
    # Returns a #String with characters first name
    def first_name
      @profile[:name].split(/ /).first
    end
    # Returns a #String with characters last name
    def last_name
      @profile[:name].split(/ /).last
    end
    # Returns a #Array of characters mounts
    def mounts
      @mounts.list
    end
    # Returns a #Array of characters minions
    def minions
      @minions.list
    end
    # Returns the current character job
    def job
      @profile[:gear].soul_crystal.name.gsub("Soul of the ", "").delete!("\n\t")
    end
    # Generates missing methods from @profile hash keys
    def method_missing(method)
      return @profile[method] if @profile.key?(method)
      super
    end
    # Uses gem Oj to dump Character Object to JSON
    def to_json
      @profile.to_json
    end
    #### Private Methods ####
    # Initialises all characters information from lodestone
    def initialise_profile(page)
      @profile[:name] = Helper.get_name(page)
      @profile[:server] = Helper.get_server(page)
      @profile[:introduction] = Helper.get_introduction(page)
      @profile[:title] = Helper.get_title(page)
      @profile[:portrait] = Helper.get_portrait(page)
      @profile[:hp] = Helper.get_hp(page)
      @profile[:mp] = Helper.get_mp(page)
      @profile[:tp] = Helper.get_tp(page)
      @profile[:sex] = Helper.get_sex(page)
      @profile[:race] = Helper.get_race(page)
      @profile[:clan] = Helper.get_clan(page)
      @profile[:nameday] = Helper.get_nameday(page)
      @profile[:guardian] = Helper.get_guardian(page)
      @profile[:city] = Helper.get_city(page)
      @profile[:grand_company] = Helper.get_grand_company(page)
      @profile[:free_company] = Helper.get_free_company(page)
      @profile[:disciple] = DiscipleList.new(page.xpath("//table[@class='class_list']/tr/td"))
      @profile[:gear] = GearList.new(page.xpath("(//div[@class='item_detail_box'])[position() < 14]"))
      @profile[:attribute] = AttributeList.new(page.xpath('//div[starts-with(@class, "param_left_area_inner")]/ul/li'))
      @mounts = CollectableList.new(page.xpath('(//div[@class="minion_box clearfix"])[1]/a'))
      @minions = CollectableList.new(page.xpath('(//div[@class="minion_box clearfix"])[2]/a'))
    end

    private :initialise_profile
  end
end
