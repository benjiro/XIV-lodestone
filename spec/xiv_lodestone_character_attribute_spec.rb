require 'spec_helper'
require 'xiv_lodestone/lodestone_character_attribute'

describe XIVLodestone::AttributeList do
  let (:valid) {
    XIVLodestone::AttributeList.new(Nokogiri::HTML(open(LOCAL_FILE)).xpath('//div[starts-with(@class, "param_left_area_inner")]/ul/li'))
  }
  let (:invalid) {
    XIVLodestone::AttributeList.new(Nokogiri::HTML(open(INVALID_FILE)).xpath('//div[starts-with(@class, "param_left_area_inner")]/ul/li'))
  }

  it 'to json dump check' do
    expect(valid.to_json).to eq("{\":str\":109,\":dex\":213,\":vit\":422,\":int\":211,\":mnd\":539,\":pie\":408,\":fire\":270,\":ice\":267,\":wind\":271,\":earth\":269,\":lightning\":269,\":water\":269,\":accuracy\":405,\":critical_hit_rate\":424,\":determination\":320,\":defense\":318,\":parry\":341,\":magic_defense\":545,\":attack_power\":109,\":skill_speed\":341,\":attack_magic_potency\":211,\":healing_magic_potency\":539,\":spell_speed\":415,\":slow_resistance\":0,\":silence_resistance\":0,\":blind_resistance\":0,\":poison_resistance\":0,\":stun_resistance\":0,\":sleep_resistance\":0,\":bind_resistance\":0,\":heavy_resistance\":0,\":slashing\":100,\":piercing\":100,\":blunt\":100}")
    expect(invalid.to_json).to eq("{}")
  end
end