require 'spec_helper'
require 'xiv_lodestone/lodestone_character_collectable'

describe XIVLodestone::CollectableList do
  let (:valid) {
    XIVLodestone::CollectableList.new(Nokogiri::HTML(open(LOCAL_FILE)).xpath('(//div[@class="minion_box clearfix"])[1]/a'))
  }
  let (:invalid) {
    XIVLodestone::CollectableList.new(Nokogiri::HTML(open(INVALID_FILE)).xpath('(//div[@class="minion_box clearfix"])[1]/a'))
  }

  it 'Get array of collectables' do
    expect(valid.list.is_a?(Array)).to eq(true)
    expect(valid.list.size).to eq(9)
  end

  it 'Dump json of collectables' do
    expect(valid.to_json).to eq("[{\"name\":\"Company Chocobo\",\"icon_url\":\"http://img.finalfantasyxiv.com/lds/pc/global/images/itemicon/49/4911a5bb2afb40de2a737cac98ecbe734698d26d.png?1376540423\"},{\"name\":\"Fat Chocobo\",\"icon_url\":\"http://img.finalfantasyxiv.com/lds/pc/global/images/itemicon/f2/f20a405d9db772c0d429b19b11248d7e32785b87.png?1392180296\"},{\"name\":\"Magitek Armor\",\"icon_url\":\"http://img.finalfantasyxiv.com/lds/pc/global/images/itemicon/1c/1ce3841890b1d22b689545ccba1c9572fe89c230.png?1376540423\"},{\"name\":\"Laurel Goobbue\",\"icon_url\":\"http://img.finalfantasyxiv.com/lds/pc/global/images/itemicon/30/307a840fd965b95e2f81ba0ba68bf0ba8e3a8763.png?1382588534\"},{\"name\":\"Coeurl\",\"icon_url\":\"http://img.finalfantasyxiv.com/lds/pc/global/images/itemicon/4c/4cad467d11b008e63567bdca93543f791baafa9c.png?1376540423\"},{\"name\":\"Ahriman\",\"icon_url\":\"http://img.finalfantasyxiv.com/lds/pc/global/images/itemicon/fa/facbad5e6cf82ed4d43d243367dffbac270b1d6b.png?1376540423\"},{\"name\":\"Behemoth\",\"icon_url\":\"http://img.finalfantasyxiv.com/lds/pc/global/images/itemicon/44/44911f30e4f853cf10ed00da286240dd6e649e7d.png?1382588533\"},{\"name\":\"Bomb Palanquin\",\"icon_url\":\"http://img.finalfantasyxiv.com/lds/pc/global/images/itemicon/92/92fb151ac9596bc548ccbe0ffb13d7c587921697.png?1392208413\"},{\"name\":\"Unicorn\",\"icon_url\":\"http://img.finalfantasyxiv.com/lds/pc/global/images/itemicon/eb/eb9cc5fd160b25f2dd9438937589628c6a7ae029.png?1376540423\"}]")
    expect(invalid.to_json).to eq("[]")
    expect(valid.to_json.is_a?(String)).to eq(true)
  end

  it 'Build a collectable' do
    mount = XIVLodestone::CollectableList::Collectable.new("Bomb Palanquin", "http")
    expect(mount.name).to eq("Bomb Palanquin")
    expect(mount.icon_url).to eq("http")
  end
end