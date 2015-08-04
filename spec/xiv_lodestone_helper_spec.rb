require 'spec_helper'
require 'xiv_lodestone/lodestone_helper'

describe XIVLodestone::Helper do
  let(:helper) { XIVLodestone::Helper }

  it 'Find character from name and server' do
    page = helper.open_url("Benji Ro", "Tonberry")
    expect(page.xpath('//h2/a')[0].text).to eq("Benji Ro")
  end

  it 'Invalid character name' do
    expect { helper.open_url("#$%#FG", "Tonberry") }.to raise_error(URI::InvalidURIError)
  end

  it 'No character found exception' do
    expect { helper.open_url("Yoloswaggings", "Tonberry") }.to raise_error(XIVLodestone::CharacterNotFound)
  end

  it 'Find character from id' do
    page = helper.open_id("1549391")
    expect(page.xpath('//h2/a')[0].text).to eql("Benji Ro")
  end

  it 'invalid character id' do
    expect { helper.open_id("154") }.to raise_error(OpenURI::HTTPError)
  end

  it 'invalid arguments' do
    expect { helper.process_args(:server => "Tonberry")}. to raise_error(ArgumentError)
  end

  it 'replace_downcase case test' do
    expect(helper.replace_downcase("HELLO WORLD")).to eq("hello_world")
    expect(helper.replace_downcase("well_yea")).to eq("well_yea")
  end

  it 'sucessful call of get methods' do
    valid = Nokogiri::HTML(open(LOCAL_FILE))
    expect(helper.get_hp(valid)).to eq(10971)
    expect(helper.get_mp(valid)).to eq(12393)
    expect(helper.get_tp(valid)).to eq(1000)
    expect(helper.get_sex(valid)).to eq("Male")
    expect(helper.get_race(valid)).to eq("Miqo'te")
    expect(helper.get_clan(valid)).to eq("Keeper of the Moon")
    expect(helper.get_nameday(valid)).to eq("27th Sun of the 1st Astral Moon")
    expect(helper.get_guardian(valid)).to eq("Oschon, the Wanderer")
    expect(helper.get_city(valid)).to eq("Gridania")
    expect(helper.get_grand_company(valid)).to eq("Order of the Twin Adder/Second Serpent Lieutenant")
    expect(helper.get_free_company(valid)).to eq(["Air Skip One", "http://na.finalfantasyxiv.com/lodestone/freecompany/9233505136016405449/"])
  end
end
