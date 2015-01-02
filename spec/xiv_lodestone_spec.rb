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
  it 'Retrvies characters hp' do
    page = Nokogiri::HTML(File.open(LOCAL_FILE))
    expect(XIVLodestone::Parser::get_hp(page)).to eql(4975)
  end

  it 'Retrvies characters mp' do
    page = Nokogiri::HTML(File.open(LOCAL_FILE)) 
    expect(XIVLodestone::Parser.get_mp(page)).to eql(4819)
  end

  it 'Retrvies characters tp' do
    page = Nokogiri::HTML(File.open(LOCAL_FILE)) 
    expect(XIVLodestone::Parser.get_tp(page)).to eql(1000)
  end

  it 'Retrvies characters sex' do
    page = Nokogiri::HTML(File.open(LOCAL_FILE)) 
    expect(XIVLodestone::Parser.get_sex(page)).to eql("Male")
  end

  it 'Retrvies characters race' do
    page = Nokogiri::HTML(File.open(LOCAL_FILE)) 
    expect(XIVLodestone::Parser.get_race(page)).to eql("Miqo'te")
  end

  it 'Retrvies characters clan' do
    page = Nokogiri::HTML(File.open(LOCAL_FILE)) 
    expect(XIVLodestone::Parser.get_clan(page)).to eql("Keeper of the Moon")
  end

  it 'Retrvies characters nameday' do
    page = Nokogiri::HTML(File.open(LOCAL_FILE)) 
    expect(XIVLodestone::Parser.get_nameday(page)).to eql("27th Sun of the 1st Astral Moon")
  end

 it 'Retrvies characters guardian' do
    page = Nokogiri::HTML(File.open(LOCAL_FILE)) 
    expect(XIVLodestone::Parser.get_guardian(page)).to eql("Oschon, the Wanderer")
  end

 it 'Retrvies characters city' do
    page = Nokogiri::HTML(File.open(LOCAL_FILE)) 
    expect(XIVLodestone::Parser.get_city(page)).to eql("Gridania")
  end

 it 'Retrvies characters grand company' do
    page = Nokogiri::HTML(File.open(LOCAL_FILE)) 
    expect(XIVLodestone::Parser.get_grand_company(page)).to eql("Immortal Flames/Second Flame Lieutenant")
  end

 it 'Retrvies characters free company' do
    free = XIVLodestone::Parser.get_free_company(Nokogiri::HTML(File.open(LOCAL_FILE))) 
    expect(free[0]).to eql("Nomad Moogles")
    expect(free[1]).to eql("http://na.finalfantasyxiv.com/lodestone/freecompany/9233505136016403440/")
  end

end
