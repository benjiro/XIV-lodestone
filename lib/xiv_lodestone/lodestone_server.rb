require 'xiv_lodestone/lodestone_helper'
require 'json'

module XIVLodestone
  # This is a basic class fetchs the server status from
  # lodestone.
  class ServerStatus
    attr_reader :list
    def initialize()
      @list = {}
      fetch_server_status(Helper.open_server_status)
    end
    # Generates methods from @server hash keys
    def method_missing(method)
      return @list[method] if @list.key?(method)
      super
    end
    # Fills the @server hash with each servers status
    def fetch_server_status(page)
      rego = Helper.open_registration_status
      page.xpath('//div[@class="text-headline"]').each do |data|
        @list[data.text.split.last.downcase.to_sym] = ServerList.new(page, rego)
      end
    end
    # Returns a JSON string of server list
    def to_json
      @list.to_json
    end
    # This class represents a "Data Centre" which is the
    # way FFXIV group their servers.
    class ServerList
      attr_reader :list
      # A structure for holding information about servers
      Server = Struct.new(:name, :status, :registration)

      def initialize(page, rego)
        @list = {}
        parse_server_status(page, rego)
      end
      # Generates methods from hash of servers
      def method_missing(method)
        return @list[method] if @list.key?(method)
        super
      end
      # Inserts server information into a hash
      def parse_server_status(page, rego)
        page.xpath('//td').each_slice(2) do |elem|
          @list[elem[0].text.strip.downcase.to_sym] = Server.new(
            elem[0].text.strip,
            elem[1].text.strip,
            rego.css('div.area_inner_cont').text[/○ #{elem[0].text.strip}/].nil? ? "Closed" : "Open")
        end
      end

      private  :parse_server_status
    end
  end
end