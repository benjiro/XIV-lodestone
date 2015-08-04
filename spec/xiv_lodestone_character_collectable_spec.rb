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
    expect(valid.list.size).to eq(18)
  end

  it 'Dump json of collectables' do
    expect(valid.to_json).to eq("[{\"name\":\"Company Chocobo\",\"icon_url\":\"http://img.finalfantasyxiv.com/lds/pc/global/images/itemicon/49/4911a5bb2afb40de2a737cac98ecbe734698d26d.png?1418207968\"},{\"name\":\"Black Chocobo\",\"icon_url\":\"http://img.finalfantasyxiv.com/lds/pc/global/images/itemicon/51/51920328db4361a6e01ea27ea472ee422259c6a8.png?1430448016\"},{\"name\":\"Twintania\",\"icon_url\":\"http://img.finalfantasyxiv.com/lds/pc/global/images/itemicon/87/8724ba22d2464ecf550f84d0949f91ec9506a613.png?1430448021\"},{\"name\":\"Fat Chocobo\",\"icon_url\":\"http://img.finalfantasyxiv.com/lds/pc/global/images/itemicon/f2/f20a405d9db772c0d429b19b11248d7e32785b87.png?1418207976\"},{\"name\":\"Magitek Armor\",\"icon_url\":\"http://img.finalfantasyxiv.com/lds/pc/global/images/itemicon/1c/1ce3841890b1d22b689545ccba1c9572fe89c230.png?1418207971\"},{\"name\":\"Laurel Goobbue\",\"icon_url\":\"http://img.finalfantasyxiv.com/lds/pc/global/images/itemicon/30/307a840fd965b95e2f81ba0ba68bf0ba8e3a8763.png?1418207974\"},{\"name\":\"Coeurl\",\"icon_url\":\"http://img.finalfantasyxiv.com/lds/pc/global/images/itemicon/4c/4cad467d11b008e63567bdca93543f791baafa9c.png?1418207971\"},{\"name\":\"Ahriman\",\"icon_url\":\"http://img.finalfantasyxiv.com/lds/pc/global/images/itemicon/fa/facbad5e6cf82ed4d43d243367dffbac270b1d6b.png?1418207970\"},{\"name\":\"Behemoth\",\"icon_url\":\"http://img.finalfantasyxiv.com/lds/pc/global/images/itemicon/44/44911f30e4f853cf10ed00da286240dd6e649e7d.png?1418207973\"},{\"name\":\"Cavalry Drake\",\"icon_url\":\"http://img.finalfantasyxiv.com/lds/pc/global/images/itemicon/26/2608067295c0be514a632a4054260f65300a1991.png?1418207973\"},{\"name\":\"Cavalry Elbst\",\"icon_url\":\"http://img.finalfantasyxiv.com/lds/pc/global/images/itemicon/01/0199c22a96c92b069eed99907a58dae60444b096.png?1418207977\"},{\"name\":\"Bomb Palanquin\",\"icon_url\":\"http://img.finalfantasyxiv.com/lds/pc/global/images/itemicon/92/92fb151ac9596bc548ccbe0ffb13d7c587921697.png?1418207978\"},{\"name\":\"Direwolf\",\"icon_url\":\"http://img.finalfantasyxiv.com/lds/pc/global/images/itemicon/58/58040c44a7ce316d254a3e7fec3930265a173f6c.png?1418207983\"},{\"name\":\"Griffin\",\"icon_url\":\"http://img.finalfantasyxiv.com/lds/pc/global/images/itemicon/99/99db2a5956bf5b95d59a9e4363e63c6c6241ba6c.png?1430448018\"},{\"name\":\"Manacutter\",\"icon_url\":\"http://img.finalfantasyxiv.com/lds/pc/global/images/itemicon/98/9851d80779006c99599dc0ba368a2f8fb573f8d7.png?1430448019\"},{\"name\":\"Unicorn\",\"icon_url\":\"http://img.finalfantasyxiv.com/lds/pc/global/images/itemicon/eb/eb9cc5fd160b25f2dd9438937589628c6a7ae029.png?1418207972\"},{\"name\":\"Aithon\",\"icon_url\":\"http://img.finalfantasyxiv.com/lds/pc/global/images/itemicon/14/148c9f36e50c2a56b6be72e319312dc39421ed76.png?1418207978\"},{\"name\":\"Midgardsormr\",\"icon_url\":\"http://img.finalfantasyxiv.com/lds/pc/global/images/itemicon/cf/cf8196cb9ebf4aab95a6033b4317159d61bd4f4a.png?1432533195\"}]")
    expect(invalid.to_json).to eq("[]")
    expect(valid.to_json.is_a?(String)).to eq(true)
  end

  it 'Build a collectable' do
    mount = XIVLodestone::CollectableList::Collectable.new("Bomb Palanquin", "http")
    expect(mount.name).to eq("Bomb Palanquin")
    expect(mount.icon_url).to eq("http")
  end
end
