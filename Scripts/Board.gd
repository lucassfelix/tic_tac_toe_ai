extends Control

class_name Board

enum BOARD_PIECE {EMPTY=0, O=1, X=2}

export(Array, Resource) var pieces

export(NodePath) var ai_node_path
var ai_node : AIPlayer

export var board_size : int = 3

export(PackedScene) var board_piece : PackedScene

var game_board : Array
var texture_board : Array
var current_player : int
var game_has_ended : bool


func _ready() -> void:
	ai_node = get_node(ai_node_path)
	
	setup_board()
	
	if GameVariables.initial_movement == GameVariables.FIRST.BLACK:
		current_player = 1
	elif GameVariables.initial_movement == GameVariables.FIRST.WHITE:
		current_player = -1		
	elif GameVariables.initial_movement == GameVariables.FIRST.RANDOM:
		pass
		

func setup_board() -> void:
	
	var grid = $GridContainer
	
	grid.columns = board_size
	game_board = []
	texture_board = []
	for i in range(board_size):
		
		game_board.append([])
		texture_board.append([])
		
		for j in range(board_size):
			var new_bp := board_piece.instance()
			grid.add_child(new_bp)
			new_bp.connect("button_up",self,"_on_Button_pressed",[[i,j]], CONNECT_ONESHOT)
			new_bp.set_pos([i,j])
			new_bp.set_piece(pieces[BOARD_PIECE.EMPTY])
			texture_board[i].append(new_bp)
			
			game_board[i].append(BOARD_PIECE.EMPTY)
			
	grid.set_anchors_preset(Control.PRESET_CENTER)	

func draw_debug_board():
	var s : String
	for i in range(board_size):
		s = ""
		for j in range(board_size):
			s += str(game_board[i][j]) + "|"
		print(s)

func make_move(move : Array, piece : Piece) -> bool:
	game_board[move[0]][move[1]] = piece.value
	draw_debug_board()	
	if endgame(game_board, BOARD_PIECE.X):
		return false
	return true

func check_row(row : Array) -> bool:
	for col in range(board_size-1):
		if (
			row[col] != row[col+1]
			or row[col] == BOARD_PIECE.EMPTY
		):
			return false
	return true

func check_col(board : Array, col : int) -> bool:
	for row in range(board_size-1):
		if (
			board[row][col] != board[row+1][col]
			or board[row][col] == BOARD_PIECE.EMPTY
		):
			return false
	return true
	
func check_primary_diagonal(board : Array) -> bool:
	for index in range(board_size - 1):
		if(
			board[index][index] != board[index+1][index+1]
			or board[index][index] == BOARD_PIECE.EMPTY
		):
			return false
	return true

func check_secondary_diagonal(board : Array) -> bool:
	for index in range(board_size - 1):
		if(
			board[index][board_size - 1 - index] != board[index+1][board_size - 2 -index]
			or board[index][board_size - 1 - index] == BOARD_PIECE.EMPTY
		):
			return false
	return true
	
func endgame(board : Array, ai_piece : int) -> int:
	
	for row in range(board_size):
		if check_row(board[row]):
			return 1 if board[row][0] == ai_piece else -1
	
	for col in range(board_size):
		if check_col(board, col):
			return 1 if board[0][col] == ai_piece else -1
			
	if check_primary_diagonal(board):
		return 1 if board[0][0] == ai_piece else -1
	
	if check_secondary_diagonal(board):
		return 1 if board[0][board_size-1] == ai_piece else -1

	for row in range(board_size):
		for col in range(board_size):
			if board[row][col] == BOARD_PIECE.EMPTY:
				return 2
	return 0		


func _on_Button_pressed(pos : Array):
	var row : int = pos[0]
	var col : int = pos[1]
	
	
	var _finished = make_move([row,col],pieces[BOARD_PIECE.X])
	
	var new_move = ai_node.minimax(game_board,true)[1]
	
	_finished = make_move(new_move,pieces[BOARD_PIECE.O])
	
	
