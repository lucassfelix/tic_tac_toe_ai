class_name VARIABLES
extends Node


enum GAME_MODE {PVP, AI}
enum DIFFICULTY {TRIVIAL, EASY, MEDIUM, HARD}
enum FIRST {BLACK, WHITE, RANDOM}

var game_mode : int = GAME_MODE.AI
var difficulty : int = DIFFICULTY.MEDIUM
var initial_movement : int = FIRST.BLACK

func set_game_mode(mode : int):
	game_mode = mode
	
func set_difficulty(dif : int):
	difficulty = dif

func set_initial_movement(first : int):
	initial_movement = first

