#!/bin/bash
# 2025-08-04 MON 06:13

## Create folders
mkdir -p assets/sprites/monsters assets/fonts assets/sounds assets/ui scripts gui data docs/uml_diagrams tmp

## Assets
# Monster sprites
for i in {1..9} 
    do touch assets/sprites/monsters/monster_0$i.png
done
for i in {11..27} 
    do touch assets/sprites/monsters/monster_$i.png
done

cd assets
touch sprites/monster_locked.png sprites/lock_icon.png
cd ..

## Assets/ui
touch assets/ui/btn_upgrade.png assets/ui/collection.png assets/ui/shop_zone.png

## Scripts
cd scripts 
touch game_controller.lua monster_manager.lua monster.lua currency_manager.lua upgrade_manager.lua ui_controller.lua utils.lua
cd ..

## GUI
cd gui
touch game_screen.gui game_screen.gui_script collection_screen.gui collection_screen.gui_script components/monster_item.gui
cd ..

## Data
cd data
touch monsters.json upgrades.json
cd ..

## Docs
cd docs
# What is it ( sequence_diagram, state_diagram )
touch README.md uml_diagrams/class_diagram.png uml_diagrams/sequence_diagram.png uml_diagrams/activity_diagram.png uml_diagrams/state_diagram.png uml_diagrams/use_case_diagram.png
cd ..

echo "📚 Basic structure created!"
echo "Done!"
echo ""