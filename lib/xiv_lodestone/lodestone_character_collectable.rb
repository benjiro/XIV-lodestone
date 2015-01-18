require 'xiv_lodestone/lodestone_helper'
require 'json'

module XIVLodestone
  class CollectableList
    attr_reader :list

    Collectable = Struct.new(:name, :icon_url)

    def initialize(collectable_path)
      @list = []
      parse_collectable(collectable_path)
    end
    # Uses gem Oj to dump MountList to JSON
    def to_json()
      @list.map { |obj| Hash[obj.each_pair.to_a] }.to_json
    end
    #### Private Methods ####
    def parse_collectable(collectable_path)
      collectable_path.each do |collectable|
        @list.push(Collectable.new(
          collectable['title'].split.map(&:capitalize)*' ',
          collectable.at_xpath('img')['src']))
      end
    end

    private :parse_collectable
  end
end
