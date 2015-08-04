require 'nokogiri'
require 'json'

module XIVLodestone
  # A object representation of disciples(classes)
  # The initialiser takes a hash of Disciple, that layout follows
  # { :rogue => ["Rogue", 1, 0, 300, "http://..."] }
  class DiscipleList
    # This strct representents a disciple
    Disciple = Struct.new(:name, :level, :current_exp, :total_exp, :icon_url) do
      def next_level
        total_exp - current_exp
      end
    end

    def initialize(disciple_path)
      @disciple = {}
      parse_disciple(disciple_path)
    end
    # Returns a json repsentation of all disciples
    def to_json()
      @disciple.to_json
    end
    # Generates missing methods using @disciple hash keys
    def method_missing(method)
      return @disciple[method] if @disciple.key?(method)
      super
    end
    #### Private Methods ####
    def parse_disciple(disciple_path)
      disciple_path.each_slice(3) do |table|
        next if table[0].text.empty? #skip empty cols
        @disciple[table[0].text.downcase.gsub(" ", "_").to_sym] = Disciple.new(
          table[0].text,
          table[1].text.to_i,
          table[2].text.split(/\//)[0].to_i,
          table[2].text.split(/\//)[1].to_i,
          table[0].at_css('img')['src'])
      end
    end

    private :parse_disciple
  end
end
