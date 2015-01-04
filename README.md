# XIVLodestone - A simple FFXIV lodestone scraper [![Build Status](https://travis-ci.org/benjiro/XIV-lodestone.svg)](https://travis-ci.org/benjiro/XIV-lodestone) [![Code Climate](https://codeclimate.com/github/benjiro/XIV-lodestone/badges/gpa.svg)](https://codeclimate.com/github/benjiro/XIV-lodestone) [![Test Coverage](https://codeclimate.com/github/benjiro/XIV-lodestone/badges/coverage.svg)](https://codeclimate.com/github/benjiro/XIV-lodestone)

A simple API for scraping information from FFXIV lodestone community website.

## Features
- Character Search (via ID number or Name and Server)
- Character profile
  - HP, MP, TP
  - Race, Sex, Clan, Nameday, Guardian, City, Grand Company, Free Company
  - Gear List - Shows item name, ilevel, slot, ffxiv db url, calculates total ilevel
  - Disciple List(Classes) - Shows class name, level, current exp, total exp, icon url, calculates experience to next level
  - All character attributes

## TODO
- Profile picture
- Achievements, Blogs, Friends list
- Free Company Search/Gather Member information
- Clean up smelly code 24/7

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

TODO: Write a more indepth guide

Once the gem is installed include it in your project.

```ruby
require 'xiv_lodestone'
```  

To parse a character
```ruby
  $ character = XIVLodestone::Character("Benpi Kancho", "Tonberry")
  $ character = XIVLodestone::Character(1549391)
```  

Basic examples

```ruby
character.gear.weapon # => Hash of below data
character.gear.weapon.name # => weapon name #String
character.gear.weapon.ilevel # => item level Integer
character.gear.weapon.slot # => item slot #String
character.gear.weapon.url # => url to ffxivdb #String
character.gear.ilevel # => Character ilevel

character.disciple.rogue # => Hash of below data
character.disciple.rogue.name # => class name #String
character.disciple.rogue.level # => current level #Integer
character.disciple.rogue.current_exp # => current experience #Interger
character.disciple.rogue.total_exp # => total experience #Integer
character.disciple.rogue.icon_url # => class icon url #String
character.disciple.rogue.next_level # => experience to required to level #Integer

character.str # => Character strength value
# More to come
```  

## Contributing

1. Fork it ( https://github.com/[my-github-username]/xiv-lodestone/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
