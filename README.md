# XIVLodestone - A simple FFXIV lodestone scraper [![Build Status](https://travis-ci.org/benjiro/XIV-lodestone.svg)](https://travis-ci.org/benjiro/XIV-lodestone) [![Code Climate](https://codeclimate.com/github/benjiro/XIV-lodestone/badges/gpa.svg)](https://codeclimate.com/github/benjiro/XIV-lodestone) [![Test Coverage](https://codeclimate.com/github/benjiro/XIV-lodestone/badges/coverage.svg)](https://codeclimate.com/github/benjiro/XIV-lodestone) [![Dependency Status](https://gemnasium.com/benjiro/XIV-lodestone.svg)](https://gemnasium.com/benjiro/XIV-lodestone)

A simple API for scraping information from FFXIV lodestone community website.
The API uses a technique called metaprogramming, this means that additional
disciples added to the game will be detected and add automatically.

Please note this gem is currently in Alpha stage of development expect bugs,
submit a issue for bug or feature requests.

## Features
- Character Search (via ID number or Name and Server)
- To Json functionality
- Character profile
  - name, server, portrait image url
  - HP, MP, TP
  - Race, Sex, Clan, Nameday, Guardian, City, Grand Company, Free Company
  - Gear List - Shows item name, ilevel, slot, ffxiv db url, calculates total ilevel
  - Disciple List(Classes) - Shows class name, level, current exp, total exp, icon url, calculates experience to next level
  - All character attributes
  - Mounts & Minions
  - Server Status

## TODO
- Multi-Language support(JP,NA,DE,FR)
- Job detection, soul crystal
- Achievements, Blogs, Friends list
- Free Company Search/Gather Member information

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'xiv_lodestone'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install xiv_lodestone

## Usage

This usage of the gem is pretty straight forward most of the method names are
directly taken from the lodestone naming conversation.

```ruby
require 'xiv_lodestone'
```

To parse a character
```ruby
  character = XIVLodestone::Character("Benpi Kancho", "Tonberry")
  character = XIVLodestone::Character("Benpi Kancho")
  character = XIVLodestone::Character(1549391)
```

Basic examples

```ruby
character.name #=> character full name #String
character.first_name #=> character first name #String
character.last_name #=> character last name #String
character.server #=> server name #String
character.introduction #=> character profile introduction #String
character.title #=> character title #String
character.portrait #=> character portrait image url #String
character.hp #=> character hp #Integer
character.mp #=> character mp #Integer
character.tp #=> character tp #Integer
character.sex #=> character sex #String
character.race #=> character race #String
character.clan #=> character clan #String
character.nameday #=> character nameday #String
character.guardian #=> character guardian #String
character.city #=> character home city #String
character.grand_company #=> character grand company #String

# Character Attributes
str, dex, vit, int, mnd, pie, fire, ice, wind, earth, lighting, water, accuracy,
critical_hite_rate, determination, defense, parry, magical_defense, attack_power,
skill_speed, attack_magic_potency, healing_magic_potency, spell_speed, blunt,
piercing, slashing, heavy_resistance, bind_resistance, sleep_resistance,
stun_resistance, poison_resistance, blind_resistance, silence_resistance,
slow_resistance

character.attribute.str #=> character str #Integer

# Available Gear Slot
weapon, head, body, hands, belt, legs, feet, shield, necklace, earrings,
bracelets, ring1, ring2

character.gear.weapon # => Hash of below data
character.gear.weapon.name # => weapon name #String
character.gear.weapon.ilevel # => item level Integer
character.gear.weapon.slot # => item slot #String
character.gear.weapon.url # => url to ffxivdb #String
character.gear.ilevel # => Character ilevel

# Available Disciples
gladiator, marauder, archer, pugilist, lancer, rogue, conjurer, thaumaturge,
arcanist, carpenter, armorer, leatherworker, alchemist, blacksmith, goldsmith,
weaver, culinarian, miner, botanist, fisher

character.disciple.rogue # => Hash of below data
character.disciple.rogue.name # => class name #String
character.disciple.rogue.level # => current level #Integer
character.disciple.rogue.current_exp # => current experience #Interger
character.disciple.rogue.total_exp # => total experience #Integer
character.disciple.rogue.icon_url # => class icon url #String
character.disciple.rogue.next_level # => experience to required to level #Integer

# Mounts & Minions
character.mounts.each do |mount|
  puts mount.name
  puts mount.icon_url
end

character.minions.each do |minion|
  puts minion.name
  puts minion.icon_url
end

character.minions #=> Returns a array of Minion
character.mounts #=> Returns a array of mounts

# To Json
character.to_json
character.mounts.to_json
character.minions.to_json
character.disciple.to_json
character.gear.to_json
character.attribute.to_json
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/xiv-lodestone/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

If you would like to say hi, i live on Tonberry - JP you can find me on my main
Benpi Kancho most of the time.
