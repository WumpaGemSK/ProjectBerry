extends Node
## Class to hold global signals to emit/connect to

## Signal to listen for the pause notification
signal pause

## Signal to listen for the resume notification
signal resume

## Signal to send a picked up item to the inventory
signal pick_item(item: Item)

## Signal to send when an item should be used
signal use_item(item: Item)

## Signal to send when an item has been used
signal item_used(item: Item)

## Signal to show the inventory
signal show_inventory

## Emitted when the countdown starts ticking down
signal countdown_start

## Emmited when the pistol ammo is updated
signal pistol_ammo_update(new_amount : int)

## Emmited when the pistol ammo is upgraded
signal pistol_ammo_upgrade(new_max : int)

## Emit when the terminal should open
signal open_terminal

## Emit when the terminal should close
signal close_terminal

## Signal to send codes for trying
signal try_code(code: String)

## Signal when the code has been inputted incorrectly
signal code_incorrect

## Signal when the code has been inputted correctly
signal code_correct(score: GameScore)

## Signal emitted when a secret is picked up
signal secret_pickup
