module XIVLodestone
  ITEM_SLOT = {
    0 => :weapon,
    1 => :head,
    2 => :body,
    3 => :hands,
    4 => :waist,
    5 => :legs,
    6 => :feet,
    7 => :shield,
    8 => :necklace,
    9 => :earrings,
    10 => :bracelet,
    11 => :ring1,
    12 => :ring2,
    13 => :soul_crystal
  }

  class Parser
    def self.get_classes(page)
      page.xpath('//td').each_slice(3).inject({}) do |class_list, tr|
        class_list[tr[0].text.to_sym] = tr[1].text.to_i unless tr[0].text.empty?; class_list
      end
      class_list
    end

    def self.get_attributes(page)
      page.xpath('//ul[@class="param_list_attributes"]/li').inject({}) do |attrib, li|
        attrib[li['class'].to_sym] = li.text.to_i; attrib
      end
      attrib
    end

    def self.get_elements(page)
      page.xpath('//ul[@class="param_list_elemental"]/li').inject({}) do |elem, li|
        ele = li.text.split(/(?<=\D)(?=\d)/)
        elem[ele[0].to_sym] = ele[1].to_i; elem
      end
      elem
    end

    def self.get_properties(page)
      page.xpath('//ul[@class="param_list"]/li[@class="clearfix"]').inject({}) do |props, li|
        prop = li.text.split(/(?<=\D)(?=\d)/)
        props[prop[0].to_sym] = prop[1].to_i
        props
      end
      props
    end

    def self.get_gear(page)
      # TODO: Fix so that classes without a shield aren't assigned to the wrong positions
      page.text =~ /shield/i ? num = 15 : num = 14
      page.xpath("(//div[@class='item_detail_box'])[position() < #{num}]").each_with_index.inject({}) do |items, (item, index)|
        items[ITEM_SLOT[index]] = [item.css('h2').text , "http://na.finalfantasyxiv.com#{item.css('a')[0]['href']}"]
      end
      items
    end

    def self.get_hp(page)
      page.xpath('//li[@class="hp"]').text.to_i
    end

    def self.get_mp(page)
      page.xpath('//li[@class="mp"]').text.to_i
    end

    def self.get_tp(page)
      page.xpath('//li[@class="tp"]').text.to_i
    end

    def self.get_sex(page)
      page.xpath('//div[@class="chara_profile_title"]').text.split(/\//).last =~ /♂/i ? "Male" : "Female"
    end

    def self.get_race(page)
      page.xpath('//div[@class="chara_profile_title"]').text.split(/\//).first.strip!
    end

    def self.get_clan(page)
      page.xpath('//div[@class="chara_profile_title"]').text.split(/\//)[1].strip!
    end

    def self.get_nameday(page)
      page.xpath('//div[@class="chara_profile_table"]/dl/dd')[0].text
    end

    def self.get_guardian(page)
      page.xpath('//div[@class="chara_profile_table"]/dl/dd')[1].text
    end

    def self.get_city(page)
      page.xpath('//dd[@class="txt_name"]')[0].text
    end

    def self.get_grand_company(page)
      page.xpath('//dd[@class="txt_name"]')[1].text
    end

    def self.get_free_company(page)
      element = page.xpath('//dd[@class="txt_name"]/a')[0]
      [ element.text, "http://na.finalfantasyxiv.com#{element['href']}" ]
    end
  end
end
