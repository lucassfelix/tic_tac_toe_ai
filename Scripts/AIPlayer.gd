extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const ai_state = -1

func choose_ai_play() -> void:
	pass
	
	
static func minimax(board : Array, current_player : int) -> Array:
	
	var endgame : int =  Board.endgame(board,ai_state)
	
	if endgame != 2:
		return [endgame, []]
		
	var max_play = [-10, []]
	var min_play = [10, []]
	
	for row in range(len(board)):
		for col in range(len(board)):
			if board[row][col] == Board.BOARD_STATE.EMPTY:
				board[row][col] = current_player
				var result = minimax(board, -current_player)
				
				if current_player == ai_state:
					if result[0] > max_play[0]:
						max_play = [result[0],[row,col]]
				else:
					if result[0] < min_play[0]:
						min_play = [result[0],[row,col]]
			
				board[row][col] = Board.BOARD_STATE.EMPTY
			
	if current_player == ai_state:
		return max_play
	else:
		return min_play
	


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
