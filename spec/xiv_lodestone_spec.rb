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
    # TODO Add full test of API
  end
end
