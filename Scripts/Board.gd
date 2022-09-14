extends Node

class_name Board

enum BOARD_PIECE {EMPTY= 0, X=-1, O=1}

export(Resource) var board_size_resource
var board_size : IntegerVar

var game_board : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	
	board_size = board_size_resource
	
	print(board_size.get_value())
	board_size.set_value(5)
	print(board_size.get_value())
	
	
#	game_board = []
#	for i in range(board_size.value):
#		game_board.append([])
#		for _j in range(board_size):
#			game_board[i].append(BOARD_PIECE.EMPTY)

func make_move(move : Array, piece : int) -> bool:
	game_board[move[0]][move[1]] = piece
	if endgame(game_board, BOARD_PIECE.X):
		return false
	return true

static func check_row(row : Array, col_count : int) -> bool:
	for col in range(col_count-1):
		if (
			row[col] != row[col+1]
			or row[col] == BOARD_PIECE.EMPTY
		):
			return false
	return true

static func check_col(board : Array, row_count: int, col : int) -> bool:
	for row in range(row_count-1):
		if (
			board[row][col] != board[row+1][col]
			or board[row][col] == BOARD_PIECE.EMPTY
		):
			return false
	return true
	
static func check_primary_diagonal(board : Array, board_size : int) -> bool:
	for index in range(board_size-1):
		if(
			board[index][index] != board[index+1][index+1]
			or board[index][index] == BOARD_PIECE.EMPTY
		):
			return false
	return true

static func check_secondary_diagonal(board : Array, board_size : int) -> bool:
	for index in range(board_size-1):
		if(
			board[index][board_size - 1 - index] != board[index+1][board_size - 2 -index]
			or board[index][board_size - 1 - index] == BOARD_PIECE.EMPTY
		):
			return false
	return true
	
static func endgame(board : Array, ai_piece : int) -> int:
	
	var board_size = len(board)
		
	for row in range(board_size):
		if check_row(board[row],board_size):
			return 1 if board[row][0] == ai_piece else -1
	
	for col in range(board_size):
		if check_col(board, board_size, col):
			return 1 if board[0][col] == ai_piece else -1
			
	if check_primary_diagonal(board, board_size):
		return 1 if board[0][0] == ai_piece else -1
	
	if check_secondary_diagonal(board,board_size):
		return 1 if board[0][board_size-1] == ai_piece else -1

	for row in range(board_size):
		for col in range(board_size):
			if board[row][col] == BOARD_PIECE.EMPTY:
				return 2
	return 0		


			
