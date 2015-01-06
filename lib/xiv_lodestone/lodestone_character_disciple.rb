require 'nokogiri'
require 'oj'

module XIVLodestone
  # A object representation of disciples(classes)
  # The initialiser takes a hash of Disciple, that layout follows
  # { :rogue => ["Rogue", 1, 0, 300, "http://..."] }
  class DiscipleList
    def initialize(disciple_path)
      @disciple = Hash.new
      parse_disciple(disciple_path)
    end
    # Uses gem Oj to dump DiscipleList Object to JSON
    def to_json()
      Oj.dump(@disciple)
    end
    # Generates access methods for each disciple slot
    def method_missing(method)
      return @disciple[method] if @disciple.key?(method)
      super
    end
    #### Private Methods ####
    def parse_disciple(disciple_path)
      disciple_path.each_slice(3) do |table|
        next if table[0].text.empty? #skip empty cols
        @disciple[table[0].text.downcase.to_sym] = Disciple.new(
          table[0].text,
          table[1].text.to_i,
          table[2].text.split(/\//)[0].to_i,
          table[2].text.split(/\//)[1].to_i,
        table[0].at_css('img')['src'])
      end
    end

    private :parse_disciple

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
