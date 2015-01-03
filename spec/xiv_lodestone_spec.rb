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
    expect(invalid.get_classes()).to eql(nil)
    expect(invalid.get_attributes()).to eql(nil)
    expect(invalid.get_gear()).to eql(nil)
    end

  it 'Sucessful parse methods' do
    expect(parser.get_item_type("Ring")).to eql("ring")
    expect(parser.get_item_type("Two-handed Conjurer's Arm")).to eql("weapon")
    expect(parser.get_item_type("Shield")).to eql("shield")
    expect(parser.get_classes()).to eql({:Gladiator=>1, :Pugilist=>6,
      :Marauder=>1, :Lancer=>1, :Archer=>1, :Rogue=>0, :Conjurer=>50,
      :Thaumaturge=>26, :Arcanist=>50, :Carpenter=>1, :Blacksmith=>1,
      :Armorer=>1, :Goldsmith=>22, :Leatherworker=>1, :Weaver=>16,
      :Alchemist=>20, :Culinarian=>1, :Miner=>1, :Botanist=>50, :Fisher=>5}
    )
    expect(parser.get_attributes()).to eql({:str=>109, :dex=>213, :vit=>422,
      :int=>211, :mnd=>539, :pie=>408, :Fire=>270, :Ice=>267, :Wind=>271,
      :Earth=>269, :Lightning=>269, :Water=>269, :Accuracy=>405,
      :"Critical Hit Rate"=>424, :Determination=>320, :Defense=>318,
      :Parry=>341, :"Magic Defense"=>545, :"Attack Power"=>109,
      :"Skill Speed"=>341, :"Attack Magic Potency"=>211,
      :"Healing Magic Potency"=>539, :"Spell Speed"=>415,
      :"Slow Resistance"=>0, :"Silence Resistance"=>0, :"Blind Resistance"=>0,
      :"Poison Resistance"=>0, :"Stun Resistance"=>0, :"Sleep Resistance"=>0,
      :"Bind Resistance"=>0, :"Heavy Resistance"=>0, :Slashing=>100,
      :Piercing=>100, :Blunt=>100})
    expect(parser.get_gear()).to eql (
    {:weapon=>["Yagrush", "http://na.finalfantasyxiv.com/lodestone/playguide/db/item/774f3c096da/"],
     :head=>["Weathered Daystar Circlet", "http://na.finalfantasyxiv.com/lodestone/playguide/db/item/0bb88cb2693/"],
     :body=>["Scylla's Robe of Healing", "http://na.finalfantasyxiv.com/lodestone/playguide/db/item/0c45cdcda37/"],
     :hands=>["Weathered Daystar Gloves", "http://na.finalfantasyxiv.com/lodestone/playguide/db/item/ec2ddbdcd47/"],
     :waist=>["Daystar Belt", "http://na.finalfantasyxiv.com/lodestone/playguide/db/item/9804bb03aaf/"],
     :legs=>["Daystar Breeches", "http://na.finalfantasyxiv.com/lodestone/playguide/db/item/9280701e6ba/"],
     :feet=>["High Allagan Thighboots of Healing", "http://na.finalfantasyxiv.com/lodestone/playguide/db/item/77060a25e03/"],
     :necklace=>["Daystar Necklace", "http://na.finalfantasyxiv.com/lodestone/playguide/db/item/534d3e2f0fd/"],
     :earrings=>["High Allagan Earrings of Healing", "http://na.finalfantasyxiv.com/lodestone/playguide/db/item/ba581d18070/"],
     :bracelets=>["Daystar Armillae", "http://na.finalfantasyxiv.com/lodestone/playguide/db/item/d0f33b5c4bf/"],
     :ring1=>["Ironworks Ring of Healing", "http://na.finalfantasyxiv.com/lodestone/playguide/db/item/7beab721371/"],
     :ring2=>["Daystar Ring", "http://na.finalfantasyxiv.com/lodestone/playguide/db/item/5b78525af6f/"],
     :"soul crystal"=>["Soul of the White Mage", "http://na.finalfantasyxiv.com/lodestone/playguide/db/item/9cca5eb0fd2/"]})
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
