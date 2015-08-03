require 'spec_helper'
require 'xiv_lodestone'

describe XIVLodestone::Character do
  let(:character) { XIVLodestone::Character.new(name: "Benji Ro", server: "Tonberry") }

  it 'Character profile found' do
    expect(character.nil?).to eq(false)
    expect(character.first_name).to eq("Benji")
    expect(character.last_name).to eq("Ro")
    expect(character.mounts.is_a?(Array)).to be
    expect(character.minions.is_a?(Array)).to be
  end

  it 'Randomly opens a profile' do
    letter = (0...1).map { (65 + rand(26)).chr }.join
    random = XIVLodestone::Character.new(name: letter)
    expect(random.nil?).to eq(false)
    expect(random.name.nil?).to eq(false)
  end
end
