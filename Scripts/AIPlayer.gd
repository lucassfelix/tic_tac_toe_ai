class_name AIPlayer
extends Node

export var board_path : NodePath
export(Resource) var empty_piece_resource
export(Resource) var ai_piece_resource
export(Resource) var player_piece_resource


var EMPTY_PIECE : Piece
var AI_PIECE : Piece
var PLAYER_PIECE : Piece
var board_node : Board;

onready var rng := RandomNumberGenerator.new()

func _ready():
	assert(empty_piece_resource != null, "ERROR: Null resource.")
	assert(ai_piece_resource != null, "ERROR: Null resource.")	
	assert(player_piece_resource != null, "ERROR: Null resource.")	
	
	EMPTY_PIECE = empty_piece_resource
	AI_PIECE = ai_piece_resource
	PLAYER_PIECE = player_piece_resource
	
	board_node = get_node(board_path)
	
	rng.randomize()

func get_ai_play(board : Array) -> Array:
	
	if GameVariables.difficulty == GameVariables.DIFFICULTY.TRIVIAL:
		return _random_play(board)
		
	#MODO FÁCIL == 50% de chance de usar o _minimax
	elif GameVariables.difficulty == GameVariables.DIFFICULTY.EASY:
		
		if rng.randi() % 2 == 0:
			var possible_plays : Array = _minimax(board, true)[1]
			return possible_plays[rng.randi_range(0,possible_plays.size()-1)]
		else:
			return _random_play(board)
	
	#MODO Médio == 75% de chance de usar o _minimax
	elif GameVariables.difficulty == GameVariables.DIFFICULTY.MEDIUM:
			
		var aux := [1,2,3,4]
		var result : int = aux[rng.randi_range(0,aux.size()-1)]
		if result != 4:
			var possible_plays : Array = _minimax(board, true)[1]
			return possible_plays[rng.randi_range(0,possible_plays.size()-1)]
		else:
			return _random_play(board)
		
	#MODO Difícil == 100% de chance de usar o _minimax
	else:
		var possible_plays : Array = _minimax(board, true)[1]
		return possible_plays[rng.randi_range(0,possible_plays.size()-1)]

func _random_play(board : Array) -> Array:
	var open_tiles :Array = []
	var board_size := board.size()
	for i in range(board_size):
		for j in range(board_size):
			if board[i][j] == EMPTY_PIECE.value:
				open_tiles.append([i,j])
	return open_tiles[rng.randi_range(0,open_tiles.size()-1)]

func _minimax(board : Array, ai_turn : bool) -> Array:
	
	#Captura o size do board
	var board_size :int = board_node.board_size
	
	#Avalia se o jogo acabou.
	var endgame : int =  board_node.endgame(board,AI_PIECE.value)
	if endgame != 2:
		#Se acabou, retorna o score do resultado final.
		return [endgame, []]
		
	var max_play = [-10, []]
	var min_play = [10, []]
	
	
	for row in range(board_size):
		for col in range(board_size):
			if board[row][col] == EMPTY_PIECE.value:
				
				if ai_turn:
					board[row][col] = AI_PIECE.value
				else:
					board[row][col] = PLAYER_PIECE.value
					
				var result = _minimax(board, !ai_turn)
				
				if ai_turn:
					if result[0] == max_play[0]:
						max_play[1].append([row,col])
					elif result[0] > max_play[0]:
						max_play = [result[0],[[row,col]]]
				else:
					if result[0] == max_play[0]:
						min_play[1].append([row,col])
					elif result[0] < min_play[0]:
						min_play = [result[0],[[row,col]]]
			
				board[row][col] = EMPTY_PIECE.value
			
	if ai_turn:
		return max_play
	else:
		return min_play
