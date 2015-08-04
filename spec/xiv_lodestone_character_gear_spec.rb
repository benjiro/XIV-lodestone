require 'spec_helper'
require 'xiv_lodestone/lodestone_character_gear'

describe XIVLodestone::GearList do
  let (:valid) {
    XIVLodestone::GearList.new(Nokogiri::HTML(open(LOCAL_FILE)).
      xpath("(//div[@class='item_detail_box'])[position() < 13]"))
  }
  let (:invalid) {
    XIVLodestone::GearList.new(Nokogiri::HTML(open(INVALID_FILE)).
      xpath("(//div[@class='item_detail_box'])[position() < 13]"))
  }

  it 'Dump json of items' do
    expect(valid.to_json).to eq("{\"weapon\":\"#<struct XIVLodestone::GearList::Gear name=\\\"Hive Cane\\\", ilevel=190, slot=\\\"Two-handed Conjurer's Arm\\\", url=\\\"http://na.finalfantasyxiv.com/lodestone/playguide/db/item/ae2adefe648/\\\">\",\"head\":\"#<struct XIVLodestone::GearList::Gear name=\\\"Prototype Gordian Crown of Healing\\\", ilevel=190, slot=\\\"Head\\\", url=\\\"http://na.finalfantasyxiv.com/lodestone/playguide/db/item/fb382760fc7/\\\">\",\"body\":\"#<struct XIVLodestone::GearList::Gear name=\\\"Asuran Dogi of Healing\\\", ilevel=180, slot=\\\"Body\\\", url=\\\"http://na.finalfantasyxiv.com/lodestone/playguide/db/item/640fb89bc54/\\\">\",\"hands\":\"#<struct XIVLodestone::GearList::Gear name=\\\"Prototype Gordian Gloves of Healing\\\", ilevel=190, slot=\\\"Hands\\\", url=\\\"http://na.finalfantasyxiv.com/lodestone/playguide/db/item/0e4a2312183/\\\">\",\"waist\":\"#<struct XIVLodestone::GearList::Gear name=\\\"Prototype Gordian Belt of Healing\\\", ilevel=190, slot=\\\"Waist\\\", url=\\\"http://na.finalfantasyxiv.com/lodestone/playguide/db/item/3e34da93e7a/\\\">\",\"legs\":\"#<struct XIVLodestone::GearList::Gear name=\\\"Asuran Hakama of Healing\\\", ilevel=180, slot=\\\"Legs\\\", url=\\\"http://na.finalfantasyxiv.com/lodestone/playguide/db/item/77aa0f2c25a/\\\">\",\"feet\":\"#<struct XIVLodestone::GearList::Gear name=\\\"Prototype Gordian Gambieras of Healing\\\", ilevel=190, slot=\\\"Feet\\\", url=\\\"http://na.finalfantasyxiv.com/lodestone/playguide/db/item/c4c4a74f87f/\\\">\",\"necklace\":\"#<struct XIVLodestone::GearList::Gear name=\\\"Prototype Gordian Neckband of Healing\\\", ilevel=190, slot=\\\"Necklace\\\", url=\\\"http://na.finalfantasyxiv.com/lodestone/playguide/db/item/be05b30cd9c/\\\">\",\"earrings\":\"#<struct XIVLodestone::GearList::Gear name=\\\"Prototype Gordian Earrings of Healing\\\", ilevel=190, slot=\\\"Earrings\\\", url=\\\"http://na.finalfantasyxiv.com/lodestone/playguide/db/item/a4219a01db7/\\\">\",\"bracelets\":\"#<struct XIVLodestone::GearList::Gear name=\\\"Prototype Gordian Wristband of Healing\\\", ilevel=190, slot=\\\"Bracelets\\\", url=\\\"http://na.finalfantasyxiv.com/lodestone/playguide/db/item/9042ef4ee11/\\\">\",\"ring1\":\"#<struct XIVLodestone::GearList::Gear name=\\\"Asuran Ring of Healing\\\", ilevel=180, slot=\\\"Ring\\\", url=\\\"http://na.finalfantasyxiv.com/lodestone/playguide/db/item/475abf45d63/\\\">\",\"ring2\":\"#<struct XIVLodestone::GearList::Gear name=\\\"Prototype Gordian Ring of Healing\\\", ilevel=190, slot=\\\"Ring\\\", url=\\\"http://na.finalfantasyxiv.com/lodestone/playguide/db/item/ae1e3d72c8e/\\\">\"}")
    expect(invalid.to_json).to eq("{}")
    expect(valid.to_json.is_a?(String)).to eq(true)
  end

  it 'calculate ilevel' do
    expect(valid.ilevel).to eq(187)
  end

  it 'method missing check' do
    expect(valid.method_missing(:head).is_a?(XIVLodestone::GearList::Gear)).to eql(true)
    expect(valid.method_missing(:weapon).is_a?(XIVLodestone::GearList::Gear)).to eql(true)
    expect(valid.method_missing(:ring1).is_a?(XIVLodestone::GearList::Gear)).to eql(true)
  end

  it 'Build a Gear' do
    d = XIVLodestone::GearList::Gear.new("Sword", 100, "Two Hand", "http")
    expect(d.name).to eq("Sword")
    expect(d.ilevel).to eq(100)
    expect(d.slot).to eq("Two Hand")
    expect(d.url).to eq("http")
  end
end
