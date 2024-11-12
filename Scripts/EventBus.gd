extends Node
## Class to hold global signals to emit/connect to

## Signal to listen for the pause notification
signal pause

## Signal to listen for the resume notification
signal resume

## Signal to send a picked up item to the inventory
signal pick_item(item: Item)

## Signal to show the inventory
signal show_inventory
