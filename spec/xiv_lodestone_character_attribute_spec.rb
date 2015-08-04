require 'spec_helper'
require 'xiv_lodestone/lodestone_character_attribute'

describe XIVLodestone::AttributeList do
  let (:valid) {
    XIVLodestone::AttributeList.new(Nokogiri::HTML(open(LOCAL_FILE)).
      xpath('//div[starts-with(@class,"param_left_area_inner")]/ul/li'))
  }

  let (:invalid) {
    XIVLodestone::AttributeList.new(Nokogiri::HTML(open(INVALID_FILE)).
      xpath('//div[starts-with(@class, "param_left_area_inner")]/ul/li'))
  }

  it 'to json dump check' do
    expect(valid.to_json).to eq("{\"strength\":117,\"dexterity\":229,\"vitality\":620,\"intelligence\":227,\"mind\":943,\"piety\":494,\"fire\":283,\"ice\":280,\"wind\":284,\"earth\":282,\"lightning\":282,\"water\":282,\"accuracy\":354,\"critical_hit_rate\":484,\"determination\":545,\"defense\":726,\"parry\":354,\"magic_defense\":1267,\"attack_power\":117,\"skill_speed\":354,\"attack_magic_potency\":227,\"healing_magic_potency\":943,\"spell_speed\":622,\"slow_resistance\":0,\"silence_resistance\":0,\"blind_resistance\":0,\"poison_resistance\":0,\"stun_resistance\":0,\"sleep_resistance\":0,\"bind_resistance\":0,\"heavy_resistance\":0,\"slashing_resistance\":100,\"piercing_resistance\":100,\"blunt_resistance\":100}")
    expect(invalid.to_json).to eq("{}")
    expect(valid.to_json.is_a?(String)).to eq(true)
  end

  it 'method missing check' do
    expect(valid.method_missing(:strength)).to eql(117)
    expect(valid.method_missing(:dexterity)).to eql(229)
    expect(valid.method_missing(:fire)).to eql(283)
  end
end
