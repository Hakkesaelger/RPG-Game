extends Node2D

var stage_of_dialogue: String = ""
var option_1: String = ""
var option_2: String = ""
@export var dialogue_tree: Dictionary

func _on_body_entered(body: Node2D) -> void:
	if "activates_text" in body and not stage_of_dialogue:
		$DialogueQuery.show()
		InputHandler.in_dialogue_range = true


func _on_body_exited(_body: Node2D) -> void:
	var text_should_be_active: bool = false
	for i in get_parent().get_overlapping_bodies():
		if "activates_text" in i:
			text_should_be_active = true
	if not text_should_be_active:
		$DialogueQuery.hide()
		InputHandler.in_dialogue_range = false

func _process(_delta: float) -> void:
	if InputHandler.in_dialogue_range and InputHandler.is_action_given("npc","ui_accept") and not stage_of_dialogue:
		$DialogueBubble.show()
		$DialogueQuery.hide()
		stage_of_dialogue = "begin"
		do_dialogue(stage_of_dialogue)
	
	InputHandler.mouse_over_dialogue_option = $DialogueBubble/DialogueOption1.is_hovered() or $DialogueBubble/DialogueOption2.is_hovered()

func _on_dialogue_option_1_pressed() -> void:
	if not option_1:
		stage_of_dialogue = ""
		$DialogueBubble.hide()
	else:
		stage_of_dialogue = option_1
		do_dialogue(option_1)


func _on_dialogue_option_2_pressed() -> void:
	if not option_2:
		stage_of_dialogue = ""
		$DialogueBubble.hide()
	else:
		stage_of_dialogue = option_2
		do_dialogue(option_2)

func do_dialogue(stage):
	var dialogue: Array = dialogue_tree[stage]
	$DialogueBubble/Dialogue.text = dialogue[0]
	var answer_1: String = dialogue[1].keys()[0]
	$DialogueBubble/DialogueOption1.text = answer_1
	option_1 = dialogue[1][answer_1]
	if len(dialogue[1]) > 1:
		$DialogueBubble/DialogueOption2.show()
		var answer_2: String = dialogue[1].keys()[1]
		$DialogueBubble/DialogueOption2.text = answer_2
		option_2 = dialogue[1][answer_2]
	else:
		$DialogueBubble/DialogueOption2.hide()
		option_2 = ""
