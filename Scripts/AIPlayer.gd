extends Node

class_name AIPlayer

const ai_state = -1

export var board_path : NodePath
var board_node;

export(Resource) var empty_piece_resource
var EMPTY_PIECE : Piece

export(Resource) var player_ai_resource
var AI_PIECE : Piece


func _ready():
	assert(empty_piece_resource != null, "ERROR: Null resource.")
	assert(player_ai_resource != null, "ERROR: Null resource.")	
	EMPTY_PIECE = empty_piece_resource
	AI_PIECE = player_ai_resource
	
	board_node = get_node(board_path)
	
	
	pass


func choose_ai_play() -> void:
	pass
	
	
func minimax(board : Array, ai_turn : bool) -> Array:
	
	var board_size : int = len(board)
	
	var endgame : int =  board_node.endgame(board,ai_state)
	
	if endgame != 2:
		return [endgame, []]
		
	var max_play = [-10, []]
	var min_play = [10, []]
	
	for row in range(board_size):
		for col in range(board_size):
			if board[row][col] == EMPTY_PIECE.value:
				
				if ai_turn:
					board[row][col] = AI_PIECE.value
				else:
					board[row][col] = -AI_PIECE.value
					
				var result = minimax(board, !ai_turn)
				
				if ai_turn:
					if result[0] > max_play[0]:
						max_play = [result[0],[row,col]]
				else:
					if result[0] < min_play[0]:
						min_play = [result[0],[row,col]]
			
				board[row][col] = EMPTY_PIECE.value
			
	if ai_turn:
		return max_play
	else:
		return min_play
