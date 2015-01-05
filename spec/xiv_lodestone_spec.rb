require 'spec_helper'
require 'xiv_lodestone'

LOCAL_FILE = File.join(File.dirname(__FILE__), "resources/character.html")
INVALID_FILE = File.join(File.dirname(__FILE__), "resources/invalid.html")

describe XIVLodestone::Character do
  let(:character) { XIVLodestone::Character.new("Benpi Kancho", "Tonberry") }

  it 'Character profile found' do
    expect(character.nil?).to eql(false)
  end
end

describe XIVLodestone::Helper do
  it 'Find character from name and server' do
    page = XIVLodestone::Helper.open_url("Benpi Kancho", "Tonberry")
    expect(page.xpath('//h2/a')[0].text).to eql("Benpi Kancho")
  end

  it 'Invalid character name' do
    expect { XIVLodestone::Helper.open_url("#$%#FG", "Tonberry") }.to raise_error(URI::InvalidURIError)
  end

  it 'Find multiple characters exception' do
    expect { XIVLodestone::Helper.open_url("Benpi", "") }.to raise_error(XIVLodestone::MoreThanOneCharacter)
  end

  it 'No character found exception' do
    expect { XIVLodestone::Helper.open_url("Yoloswaggings", "Tonberry") }.to raise_error(XIVLodestone::CharacterNotFound)
  end

  it 'Find character from id' do
    page = XIVLodestone::Helper.open_id("1549391")
    expect(page.xpath('//h2/a')[0].text).to eql("Benpi Kancho")
  end
end

describe XIVLodestone::Character do
  let(:character) { XIVLodestone::Character.new("Pocket Rocket", "Tonberry") }

  it 'Character methods check' do
    expect(character.city).to eql("Ul'dah")
    # TODO Add full test of API
  end

  it 'GearList class check' do
    list = XIVLodestone::GearList.new({:weapon => ["Fist", 110, "Weapon", "http://..."]})
    expect(list.weapon.name).to eql("Fist")
    expect(list.weapon.ilevel).to eql(110)
    expect(list.weapon.slot).to eql("Weapon")
    expect(list.weapon.url).to eql("http://...")
  end

  it 'DiscipleList class check' do
    list = XIVLodestone::DiscipleList.new({:rogue => ["Rogue", 1, 0, 300, "http://..."]})
    expect(list.rogue.name).to eql("Rogue")
    expect(list.rogue.level).to eql(1)
    expect(list.rogue.current_exp).to eql(0)
    expect(list.rogue.total_exp).to eql(300)
    expect(list.rogue.icon_url).to eql("http://...")
    expect(list.rogue.next_level).to eql(300)
  end
end

describe XIVLodestone::Parser do
  let(:parser) { XIVLodestone::Parser.new(Nokogiri::HTML(File.open(LOCAL_FILE))) }
  let(:invalid) { XIVLodestone::Parser.new(Nokogiri::HTML(File.open(INVALID_FILE))) }

  it 'Nil initializer to parser' do
    expect { XIVLodestone::Parser.new(nil) }.to raise_error(XIVLodestone::Parser::InvalidDocument)
  end

  it 'Invalid parse methods' do
    expect(invalid.get_hp()).to eql(nil)
    expect(invalid.get_mp()).to eql(nil)
    expect(invalid.get_tp()).to eql(nil)
    expect(invalid.get_sex()).to eql(nil)
    expect(invalid.get_race()).to eql(nil)
    expect(invalid.get_clan()).to eql(nil)
    expect(invalid.get_nameday()).to eql(nil)
    expect(invalid.get_guardian()).to eql(nil)
    expect(invalid.get_city()).to eql(nil)
    expect(invalid.get_grand_company()).to eql(nil)
    expect(invalid.get_classes()).to eql({})
    expect(invalid.get_attributes()).to eql({})
    expect(invalid.get_gear()).to eql({})
    end

  it 'Sucessful parse methods' do
    expect(parser.get_classes().count).to eql(20)
    expect(parser.get_attributes().count).to eql(34)
    expect(parser.get_gear().count).to eql (12)
    expect(parser.get_hp()).to eql(4975)
    expect(parser.get_mp()).to eql(4819)
    expect(parser.get_tp()).to eql(1000)
    expect(parser.get_sex()).to eql("Male")
    expect(parser.get_race()).to eql("Miqo'te")
    expect(parser.get_clan()).to eql("Keeper of the Moon")
    expect(parser.get_nameday()).to eql("27th Sun of the 1st Astral Moon")
    expect(parser.get_guardian()).to eql("Oschon, the Wanderer")
    expect(parser.get_city()).to eql("Gridania")
    expect(parser.get_grand_company()).to eql("Immortal Flames/Second Flame Lieutenant")
    expect(parser.get_free_company()).to eql(["Nomad Moogles",
                                              "http://na.finalfantasyxiv.com/lodestone/freecompany/9233505136016403440/"])
  end
end
