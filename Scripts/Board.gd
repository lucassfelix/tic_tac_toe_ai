extends Control

class_name Board

enum BOARD_PIECE {EMPTY=0, O=1, X=2}

export(Array, Resource) var pieces

export(NodePath) var ai_node_path
var ai_node : AIPlayer

export(Resource) var board_size_resource
var board_size : IntegerVar

export(PackedScene) var board_piece : PackedScene

var game_board : Array
var current_player : int
var game_has_ended : bool


func _ready():
	
	ai_node = get_node(ai_node_path)
	var rows = $Rows
	board_size = board_size_resource
	
	game_board = []
	for i in range(board_size.value):
		game_board.append([])
		var new_hbox := HBoxContainer.new()
		rows.add_child(new_hbox)
		new_hbox.size_flags_horizontal = SIZE_FILL
		new_hbox.size_flags_vertical = SIZE_EXPAND_FILL
		for j in range(board_size.value):
			var new_bp := board_piece.instance()
			new_hbox.add_child(new_bp)
			new_bp.size_flags_horizontal = SIZE_EXPAND
			new_bp.set_pos([i,j])
			new_bp.set_piece(pieces[BOARD_PIECE.X])
			game_board[i].append(new_bp)
	
	draw_debug_board(game_board)


static func draw_debug_board(board: Array):
	for i in len(board):
		var line = ""
		for j in len(board):
			line += board[i][j].piece.piece_name + "|" 
		print(line)
	print("\n")

func make_move(move : Array, piece : Piece) -> bool:
	game_board[move[0]][move[1]].set_piece(piece)
	if endgame(game_board, BOARD_PIECE.X):
		return false
	return true

func check_row(row : Array) -> bool:
	for col in range(board_size.value-1):
		if (
			row[col] != row[col+1]
			or row[col] == BOARD_PIECE.EMPTY
		):
			return false
	return true

func check_col(board : Array, col : int) -> bool:
	for row in range(board_size.value-1):
		if (
			board[row][col] != board[row+1][col]
			or board[row][col] == BOARD_PIECE.EMPTY
		):
			return false
	return true
	
func check_primary_diagonal(board : Array) -> bool:
	for index in range(board_size.value - 1):
		if(
			board[index][index] != board[index+1][index+1]
			or board[index][index] == BOARD_PIECE.EMPTY
		):
			return false
	return true

func check_secondary_diagonal(board : Array) -> bool:
	for index in range(board_size.value - 1):
		if(
			board[index][board_size.value - 1 - index] != board[index+1][board_size.value - 2 -index]
			or board[index][board_size.value - 1 - index] == BOARD_PIECE.EMPTY
		):
			return false
	return true
	
func endgame(board : Array, ai_piece : int) -> int:
	
	for row in range(board_size.value):
		if check_row(board[row]):
			return 1 if board[row][0] == ai_piece else -1
	
	for col in range(board_size.value):
		if check_col(board, col):
			return 1 if board[0][col] == ai_piece else -1
			
	if check_primary_diagonal(board):
		return 1 if board[0][0] == ai_piece else -1
	
	if check_secondary_diagonal(board):
		return 1 if board[0][board_size.value-1] == ai_piece else -1

	for row in range(board_size.value):
		for col in range(board_size.value):
			if board[row][col] == BOARD_PIECE.EMPTY:
				return 2
	return 0		


func _on_Button_pressed():
	var move = $TextEdit.text
	var row = int(move[0])
	var col = int(move[1])
	var _finished = make_move([row,col],pieces[BOARD_PIECE.X])
	draw_debug_board(game_board)
	var new_move = ai_node.minimax(game_board,true)[1]
	_finished = make_move(new_move,pieces[BOARD_PIECE.O])
	draw_debug_board(game_board)	
	
	
