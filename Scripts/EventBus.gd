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
