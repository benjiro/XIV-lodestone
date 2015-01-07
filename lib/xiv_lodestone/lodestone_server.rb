require 'xiv_lodestone/lodestone_helper'

module XIVLodestone
  # This is a basic class fetchs the server status from
  # lodestone.
  # TODO add data centres, add registration status
  class ServerStatus
    def initialize()
      @server = Hash.new
      fetch_server_status(Helper.open_server_status)
    end
    # Updates server status
    def update_status()
      fetch_server_status(Helper.open_server_status)
    end
    # Generates methods from @server hash keys
    def method_missing(method)
      return @server[method] if @server.key?(method)
      super
    end
    # Fills the @server hash with each servers status
    def fetch_server_status(page)
      page.xpath('//td').each_slice(2) do |elem|
        @server[elem[0].text.strip.downcase.to_sym] = elem[1].text.strip
      end
    end
  end
end