extends Node

var in_dialogue_range: bool = false
var mouse_over_dialogue_option: bool = false

func is_action_given(asking: String, action: StringName):
	if asking == "player":
		if action in ["move_left", "move_right"] and Input.is_action_pressed(action): return true
		if action == "jump" and Input.is_action_just_pressed("jump") and not in_dialogue_range: return true
		if action == "attack" and Input.is_action_just_pressed("attack") and not mouse_over_dialogue_option: return true
		return false
	if asking == "npc":
		if Input.is_action_just_pressed(action): return true
