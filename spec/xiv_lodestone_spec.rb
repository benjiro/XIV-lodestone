require 'spec_helper'
require 'xiv_lodestone'

LOCAL_FILE = File.join(File.dirname(__FILE__), "resources/character.html")
INVALID_FILE = File.join(File.dirname(__FILE__), "resources/invalid.html")

describe XIVLodestone::Character do
  let(:character) { XIVLodestone::Character.new(:name => "Benpi Kancho", :server => "Tonberry") }

  it 'Character profile found' do
    expect(character.nil?).to eql(false)
  end
end

describe XIVLodestone::Helper do
  let(:helper) { XIVLodestone::Helper }

  it 'Find character from name and server' do
    page = helper.open_url("Benpi Kancho", "Tonberry")
    expect(page.xpath('//h2/a')[0].text).to eq("Benpi Kancho")
  end

  it 'Invalid character name' do
    expect { helper.open_url("#$%#FG", "Tonberry") }.to raise_error(URI::InvalidURIError)
  end

  it 'Find multiple characters exception' do
    expect { helper.open_url("Benpi", "") }.to raise_error(XIVLodestone::MoreThanOneCharacter)
  end

  it 'No character found exception' do
    expect { helper.open_url("Yoloswaggings", "Tonberry") }.to raise_error(XIVLodestone::CharacterNotFound)
  end

  it 'Find character from id' do
    page = helper.open_id("1549391")
    expect(page.xpath('//h2/a')[0].text).to eql("Benpi Kancho")
  end

  it 'invalid character id' do
    expect { helper.open_id("154") }.to raise_error(OpenURI::HTTPError)
  end

  it 'invalid arguments' do
    expect { helper.process_args(:server => "Tonberry")}. to raise_error(ArgumentError)
  end

  it 'Should/Shouldnt be a 2hand weapon' do
    expect(helper.is_2hand_weapon("Two-handed Conjurer's Arm")).to be
    expect(helper.is_2hand_weapon("Dogs Brekkie")).not_to be
  end

  it 'replace_downcase case test' do
    expect(helper.replace_downcase("HELLO WORLD")).to eq("hello_world")
    expect(helper.replace_downcase("well_yea")).to eq("well_yea")
  end

  it 'sucessful call of get methods' do
    valid = Nokogiri::HTML(open(LOCAL_FILE))
    expect(helper.get_hp(valid)).to eq(4975)
    expect(helper.get_mp(valid)).to eq(4819)
    expect(helper.get_tp(valid)).to eq(1000)
    expect(helper.get_sex(valid)).to eq("Male")
    expect(helper.get_race(valid)).to eq("Miqo'te")
    expect(helper.get_clan(valid)).to eq("Keeper of the Moon")
    expect(helper.get_nameday(valid)).to eq("27th Sun of the 1st Astral Moon")
    expect(helper.get_guardian(valid)).to eq("Oschon, the Wanderer")
    expect(helper.get_city(valid)).to eq("Gridania")
    expect(helper.get_grand_company(valid)).to eq("Immortal Flames/Second Flame Lieutenant")
    expect(helper.get_free_company(valid)).to eq(["Nomad Moogles", "http://na.finalfantasyxiv.com/lodestone/freecompany/9233505136016403440/"])
  end
end

describe XIVLodestone::Character do
  let(:character) { XIVLodestone::Character.new(:name => "Pocket Rocket", :server =>"Tonberry") }

  it 'Character methods check' do
    # TODO Add full test of API
  end
end
