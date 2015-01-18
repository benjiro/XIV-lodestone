## Alpha: 0.0.1 (yanked)

Features:
  - Added for Character search via Character name, Server or Character ID
  - Character Profile
    - HP, MP, TP
    - Race, Sex, Clan, Nameday, Guardian, City, Grand Company, Free Company
    - Gear List - Shows item name, ilevel, slot, ffxiv db url, calculates total ilevel
    - Disciple List(Classes) - Shows class name, level, current exp, total exp, icon url, calculates experience to next level
    - All character attributes
  - Converts Character profile to json

## Alpha: 0.0.2 (2015-01-05)

Bugfixes:
  - Added required Ruby version to gemspec

## Alpha: 0.0.3 (2015-01-05)

Bugfixes:
  - Added nokogiri dependency to gemspec
  - Remove rake dependency from spec
  - Fixed ilevel calculation, forgot to double 2handed ilevel as offhand
  - Refactored Paser#get_classes()., Parser#get_gear

## Alpha: 0.0.4 (2015-01-07)

Features
  - Added new method to creating a Character class, Character.new("Benpi Kancho"), can pass name without server if you have an extremely rare name
  - Added server name method
  - Character, DiscipleList, GearList class have had a to_json method added to them
  - Added first_name and last_name methods
  - Added minion parser + mounts parser

Bugfixes
  - Rewriting more comprehensive tests
  - Change the way Character.new arguments work
  - Cleaned up code structure to be more modular

## Alpha: 0.0.5 (2015-01-08)
Features
  - Added server status
  - Added job detection

Bugfixes
  - Logic error in process_args
  - Removed MoreThanOneCharacter exception(now picks the first character from result search)
  - Now returns the first match if multiple characters