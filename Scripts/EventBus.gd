extends Node
## Class to hold global signals to emit/connect to

@warning_ignore("unused_signal")
## Signal to listen for the pause notification
signal pause

@warning_ignore("unused_signal")
## Signal to listen for the resume notification
signal resume

@warning_ignore("unused_signal")
## Signal to send a picked up item to the inventory
signal pick_item(item: Item)

@warning_ignore("unused_signal")
## Signal to send when an item should be used
signal use_item(item: Item)

@warning_ignore("unused_signal")
## Signal to send when an item has been used
signal item_used(item: Item)

@warning_ignore("unused_signal")
## Signal to show the inventory
signal show_inventory

@warning_ignore("unused_signal")
## Emitted when the countdown starts ticking down
signal countdown_start

@warning_ignore("unused_signal")
## Emmited when the pistol ammo is updated
signal pistol_ammo_update(new_amount : int)

@warning_ignore("unused_signal")
## Emmited when the pistol ammo is upgraded
signal pistol_ammo_upgrade(new_max : int)

@warning_ignore("unused_signal")
## Emit when the terminal should open
signal open_terminal

@warning_ignore("unused_signal")
## Emit when the terminal should close
signal close_terminal

@warning_ignore("unused_signal")
## Signal to send codes for trying
signal try_code(code: String)

@warning_ignore("unused_signal")
## Signal when the code has been inputted incorrectly
signal code_incorrect

@warning_ignore("unused_signal")
## Signal when the code has been inputted correctly
signal code_correct(score: GameScore)

@warning_ignore("unused_signal")
## Signal emitted when a secret is picked up
signal secret_pickup

@warning_ignore("unused_signal")
## Signal to append a score to the list of scores.
signal new_score(score: GameScore)

@warning_ignore("unused_signal")
## Signal emitted when the player dies
signal player_death

@warning_ignore("unused_signal")
## Signal emmited when the user has pressed a key in the continue screen
signal retry_continue

signal continue_screen

@warning_ignore("unused_signal")
## Signal to emit when a scene should reload. The nodes that need to reset should connect to this and restore original data when the event is emitted
signal reload_scene

## Signal sent to reset the state
signal reset
