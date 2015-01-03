require 'spec_helper'
require 'xiv_lodestone'

LOCAL_FILE = File.join(File.dirname(__FILE__), "resources/character.html") 

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

  it 'Nil initializer to parser' do
    expect { XIVLodestone::Parser.new(nil) }.to raise_error(XIVLodestone::Parser::InvalidDocument)
  end

  it 'Sucessful parse methods' do
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
