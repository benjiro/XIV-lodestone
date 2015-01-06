require 'xiv_lodestone/lodestone_helper'
require 'oj'

module XIVLodestone
  class MountList
    attr_reader :list

    def initialize(mount_path)
      @list = Array.new
      parse_mount(mount_path)
    end

    #### Private Methods ####
    def parse_mount(mount_path)
      mount_path.each do |mount|
        @list.push(Mount.new(mount['title'],
          mount.at_xpath('img')['src']))
      end
    end

    private :parse_mount

    class Mount
      attr_reader :name, :icon_url

      def initialize(name, icon_url)
        @name = name.split.map(&:capitalize)*' '
        @icon_url = icon_url
      end
    end
  end
end
