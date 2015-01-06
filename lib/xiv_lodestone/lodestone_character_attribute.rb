require 'xiv_lodestone/lodestone_helper'
require 'oj'

module XIVLodestone
  # A Object that represents a set of atrributes from
  # lodestone website. The class parsers a given xpath
  # for attributes and stores them in a Hash. All method
  # names are based of names of attributes from lodestone website
  class AttributeList
    def initialize(attribute_path)
      @attributes = Hash.new
      parse_attributes(attribute_path)
    end
    # Generate methods from each key in the @attribute hash
    def method_missing(method)
      return @attributes[method] if @attributes.key?(@attributes)
      super
    end
    # Uses OJ to dump @attribute to json
    def to_json()
      Oj.dump(@attributes)
    end
    #### Private Methods ####
    # Parsers attributes from a document into @attribute hash
    def parse_attributes(attribute_path)
      attribute_path.each_with_index do |li, index|
        # For some weird reason the first 6 elements don't use span tags like the rest.
        if index < 6
          @attributes[Helper.replace_downcase(li['class']).to_sym] = li.text.to_i
        else
          ele = li.text.split(/(?<=\D)(?=\d)/)
          @attributes[Helper.replace_downcase(ele[0]).to_sym] = ele[1].to_i
        end
      end
    end

    private :parse_attributes
  end
end
