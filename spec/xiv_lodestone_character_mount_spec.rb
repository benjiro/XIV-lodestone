require 'spec_helper'
require 'xiv_lodestone/lodestone_character_mount'

describe XIVLodestone::MountList do
  let (:valid) {
    XIVLodestone::MountList.new(Nokogiri::HTML(open(LOCAL_FILE)).xpath('(//div[@class="minion_box clearfix"])[1]/a'))
  }
  let (:invalid) {
    XIVLodestone::MountList.new(Nokogiri::HTML(open(INVALID_FILE)).xpath('(//div[@class="minion_box clearfix"])[1]/a'))
  }

  it 'Get array of mounts' do
    expect(valid.list.size).to eq(9)
  end

  it 'Dump json of mounts' do
    expect(valid.to_json).to eq("[{\"^o\":\"XIVLodestone::MountList::Mount\",\"name\":\"Company Chocobo\",\"icon_url\":\"http://img.finalfantasyxiv.com/lds/pc/global/images/itemicon/49/4911a5bb2afb40de2a737cac98ecbe734698d26d.png?1376540423\"},{\"^o\":\"XIVLodestone::MountList::Mount\",\"name\":\"Fat Chocobo\",\"icon_url\":\"http://img.finalfantasyxiv.com/lds/pc/global/images/itemicon/f2/f20a405d9db772c0d429b19b11248d7e32785b87.png?1392180296\"},{\"^o\":\"XIVLodestone::MountList::Mount\",\"name\":\"Magitek Armor\",\"icon_url\":\"http://img.finalfantasyxiv.com/lds/pc/global/images/itemicon/1c/1ce3841890b1d22b689545ccba1c9572fe89c230.png?1376540423\"},{\"^o\":\"XIVLodestone::MountList::Mount\",\"name\":\"Laurel Goobbue\",\"icon_url\":\"http://img.finalfantasyxiv.com/lds/pc/global/images/itemicon/30/307a840fd965b95e2f81ba0ba68bf0ba8e3a8763.png?1382588534\"},{\"^o\":\"XIVLodestone::MountList::Mount\",\"name\":\"Coeurl\",\"icon_url\":\"http://img.finalfantasyxiv.com/lds/pc/global/images/itemicon/4c/4cad467d11b008e63567bdca93543f791baafa9c.png?1376540423\"},{\"^o\":\"XIVLodestone::MountList::Mount\",\"name\":\"Ahriman\",\"icon_url\":\"http://img.finalfantasyxiv.com/lds/pc/global/images/itemicon/fa/facbad5e6cf82ed4d43d243367dffbac270b1d6b.png?1376540423\"},{\"^o\":\"XIVLodestone::MountList::Mount\",\"name\":\"Behemoth\",\"icon_url\":\"http://img.finalfantasyxiv.com/lds/pc/global/images/itemicon/44/44911f30e4f853cf10ed00da286240dd6e649e7d.png?1382588533\"},{\"^o\":\"XIVLodestone::MountList::Mount\",\"name\":\"Bomb Palanquin\",\"icon_url\":\"http://img.finalfantasyxiv.com/lds/pc/global/images/itemicon/92/92fb151ac9596bc548ccbe0ffb13d7c587921697.png?1392208413\"},{\"^o\":\"XIVLodestone::MountList::Mount\",\"name\":\"Unicorn\",\"icon_url\":\"http://img.finalfantasyxiv.com/lds/pc/global/images/itemicon/eb/eb9cc5fd160b25f2dd9438937589628c6a7ae029.png?1376540423\"}]"
      )
    expect(invalid.to_json).to eq("[]")
  end

  it 'Build a mount' do
    mount = XIVLodestone::MountList::Mount.new("Bomb Palanquin", "http")
    expect(mount.name).to eq("Bomb Palanquin")
    expect(mount.icon_url).to eq("http")
  end

  it 'Word capitalisation' do
    mount = XIVLodestone::MountList::Mount.new("bomb palanquin", "http")
    expect(mount.name).to eq("Bomb Palanquin")
  end
end