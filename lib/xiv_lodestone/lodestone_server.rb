require 'xiv_lodestone/lodestone_helper'
require 'json'

module XIVLodestone
  # This is a basic class fetchs the server status from
  # lodestone.
  class ServerStatus
    Server = Struct.new(:name, :status, :registration)

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
      page.xpath('//td').each_slice(2) do |elem|
        @list[elem[0].text.strip.downcase.to_sym] = Server.new(
          elem[0].text.strip,
          elem[1].text.strip,
          rego.css('div.area_inner_cont').text[/○ #{elem[0].text.strip}/] ? "Open" : "Closed")
      end
    end
    # Returns a JSON string of server list
    def to_json
      @list.to_json
    end
  end
end