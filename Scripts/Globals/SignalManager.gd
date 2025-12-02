extends Node

signal gun_fired(right_direction: Vector2)
signal reload_triggered
signal map_triggered
signal player_attacked
signal player_safe
signal update_bar(amount: float)
signal darken_screen(amount: float)
signal bullet_added
signal world_scene_loaded
signal stop_movement(can_move: bool)
signal collect_note
signal collect_keycard
signal update_interact_text(text:String)
signal clear_interact_text
signal update_interact_temp_text(text:String)
signal look_at_microscope
signal unlock_manager_door
signal toggle_door_lock
signal toggle_lab_door
signal extra_ammo
signal extra_time
signal game_restarting
