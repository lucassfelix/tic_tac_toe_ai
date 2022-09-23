extends Node

enum OPTIONS {VERSUS, DIFFICULTY, INITIAL}

export(OPTIONS) var buttonOption
export(VARIABLES.GAME_MODE) var game_mode
export(VARIABLES.DIFFICULTY) var difficulty
export(VARIABLES.FIRST) var first

func _ready() -> void:
	connect("pressed",self,"_on_choice_")
	
func _on_choice_() -> void:
	if buttonOption == OPTIONS.VERSUS:
		GameVariables.set_game_mode(game_mode)
	elif buttonOption == OPTIONS.DIFFICULTY:
		GameVariables.set_difficulty(difficulty)
	elif buttonOption == OPTIONS.INITIAL:
		GameVariables.set_initial_movement(first)
		
