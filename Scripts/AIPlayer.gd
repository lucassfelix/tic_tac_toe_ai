extends Node

const ai_state = -1

export(Resource) var board_size_resource
var board_size : IntegerVar

export(Resource) var empty_piece_resource
var EMPTY_PIECE : Piece

export(Resource) var player_ai_resource
var AI_PIECE : Piece


func _ready():
	print(board_size.get_class())
	print(board_size_resource.get_class())
	assert(typeof(board_size) == typeof(board_size_resource), "ERROR: Wrong type of resource. (" + board_size.get_class() + board_size_resource.get_class() + ")")		
	board_size = board_size_resource
	EMPTY_PIECE = empty_piece_resource
	AI_PIECE = player_ai_resource
	pass


func choose_ai_play() -> void:
	pass
	
	
func minimax(board : Array, ai_turn : bool) -> Array:
	
	var endgame : int =  Board.endgame(board,ai_state)
	
	if endgame != 2:
		return [endgame, []]
		
	var max_play = [-10, []]
	var min_play = [10, []]
	
	for row in range(len(board)):
		for col in range(len(board)):
			if board[row][col] == EMPTY_PIECE.value:
				
				board[row][col]
				
				var result = minimax(board, !ai_turn)
				
				if ai_turn:
					if result[0] > max_play[0]:
						max_play = [result[0],[row,col]]
				else:
					if result[0] < min_play[0]:
						min_play = [result[0],[row,col]]
			
				board[row][col] = Board.BOARD_PIECE.EMPTY
			
	if ai_turn:
		return max_play
	else:
		return min_play
	


# Called when the node enters the scene tree for the first time.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
