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
    expect(valid.to_json).to eq("{\"weapon\":\"#<struct XIVLodestone::GearList::Gear name=\\\"Yagrush\\\", ilevel=110, slot=\\\"Two-handed Conjurer's Arm\\\", url=\\\"http://na.finalfantasyxiv.com/lodestone/playguide/db/item/774f3c096da/\\\">\",\"head\":\"#<struct XIVLodestone::GearList::Gear name=\\\"Weathered Daystar Circlet\\\", ilevel=100, slot=\\\"Head\\\", url=\\\"http://na.finalfantasyxiv.com/lodestone/playguide/db/item/0bb88cb2693/\\\">\",\"body\":\"#<struct XIVLodestone::GearList::Gear name=\\\"Scylla's Robe of Healing\\\", ilevel=100, slot=\\\"Body\\\", url=\\\"http://na.finalfantasyxiv.com/lodestone/playguide/db/item/0c45cdcda37/\\\">\",\"hands\":\"#<struct XIVLodestone::GearList::Gear name=\\\"Weathered Daystar Gloves\\\", ilevel=100, slot=\\\"Hands\\\", url=\\\"http://na.finalfantasyxiv.com/lodestone/playguide/db/item/ec2ddbdcd47/\\\">\",\"waist\":\"#<struct XIVLodestone::GearList::Gear name=\\\"Daystar Belt\\\", ilevel=110, slot=\\\"Waist\\\", url=\\\"http://na.finalfantasyxiv.com/lodestone/playguide/db/item/9804bb03aaf/\\\">\",\"legs\":\"#<struct XIVLodestone::GearList::Gear name=\\\"Daystar Breeches\\\", ilevel=110, slot=\\\"Legs\\\", url=\\\"http://na.finalfantasyxiv.com/lodestone/playguide/db/item/9280701e6ba/\\\">\",\"feet\":\"#<struct XIVLodestone::GearList::Gear name=\\\"High Allagan Thighboots of Healing\\\", ilevel=110, slot=\\\"Feet\\\", url=\\\"http://na.finalfantasyxiv.com/lodestone/playguide/db/item/77060a25e03/\\\">\",\"necklace\":\"#<struct XIVLodestone::GearList::Gear name=\\\"Daystar Necklace\\\", ilevel=110, slot=\\\"Necklace\\\", url=\\\"http://na.finalfantasyxiv.com/lodestone/playguide/db/item/534d3e2f0fd/\\\">\",\"earrings\":\"#<struct XIVLodestone::GearList::Gear name=\\\"High Allagan Earrings of Healing\\\", ilevel=110, slot=\\\"Earrings\\\", url=\\\"http://na.finalfantasyxiv.com/lodestone/playguide/db/item/ba581d18070/\\\">\",\"bracelets\":\"#<struct XIVLodestone::GearList::Gear name=\\\"Daystar Armillae\\\", ilevel=110, slot=\\\"Bracelets\\\", url=\\\"http://na.finalfantasyxiv.com/lodestone/playguide/db/item/d0f33b5c4bf/\\\">\",\"ring1\":\"#<struct XIVLodestone::GearList::Gear name=\\\"Ironworks Ring of Healing\\\", ilevel=120, slot=\\\"Ring\\\", url=\\\"http://na.finalfantasyxiv.com/lodestone/playguide/db/item/7beab721371/\\\">\",\"ring2\":\"#<struct XIVLodestone::GearList::Gear name=\\\"Daystar Ring\\\", ilevel=110, slot=\\\"Ring\\\", url=\\\"http://na.finalfantasyxiv.com/lodestone/playguide/db/item/5b78525af6f/\\\">\"}")
    expect(invalid.to_json).to eq("{}")
    expect(valid.to_json.is_a?(String)).to eq(true)
  end

  it 'calculate ilevel' do
    expect(valid.ilevel).to eq(108)
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