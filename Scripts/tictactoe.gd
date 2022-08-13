extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var board: Array

enum BOARD_STATE {EMPTY= 0, X=-1, O=1}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(9):
		board.append(BOARD_STATE.EMPTY)
	print(board)
	pass # Replace with function body.

func getBestPlay(aux_board):
	pass

func endgame(c_board):

	
	if c_board[0] != BOARD_STATE.EMPTY and	c_board[1] != BOARD_STATE.EMPTY and c_board[2] != BOARD_STATE.EMPTY and c_board[0] == c_board[1] and c_board[1] == c_board[2]:
		return -1 if c_board[0] == BOARD_STATE.O else 1 
	if c_board[3] != BOARD_STATE.EMPTY and	c_board[4] != BOARD_STATE.EMPTY and c_board[5] != BOARD_STATE.EMPTY and c_board[3] == c_board[4] and c_board[4] == c_board[5]:
		return -1 if c_board[3] == BOARD_STATE.O else 1 
	if c_board[6] != BOARD_STATE.EMPTY and	c_board[7] != BOARD_STATE.EMPTY and c_board[8] != BOARD_STATE.EMPTY and c_board[6] == c_board[7] and c_board[7] == c_board[8]:
		return -1 if c_board[6] == BOARD_STATE.O else 1 
	if c_board[0] != BOARD_STATE.EMPTY and	c_board[3] != BOARD_STATE.EMPTY and c_board[6] != BOARD_STATE.EMPTY and c_board[0] == c_board[3] and c_board[3] == c_board[6]:
		return -1 if c_board[0] == BOARD_STATE.O else 1 
	if c_board[1] != BOARD_STATE.EMPTY and	c_board[4] != BOARD_STATE.EMPTY and c_board[7] != BOARD_STATE.EMPTY and c_board[1] == c_board[4] and c_board[4] == c_board[7]:
		return -1 if c_board[1] == BOARD_STATE.O else 1 
	if c_board[2] != BOARD_STATE.EMPTY and	c_board[5] != BOARD_STATE.EMPTY and c_board[8] != BOARD_STATE.EMPTY and c_board[2] == c_board[5] and c_board[5] == c_board[8]:
		return -1 if c_board[2] == BOARD_STATE.O else 1 
	if c_board[0] != BOARD_STATE.EMPTY and	c_board[4] != BOARD_STATE.EMPTY and c_board[8] != BOARD_STATE.EMPTY and c_board[0] == c_board[4] and c_board[4] == c_board[8]:
		return -1 if c_board[0] == BOARD_STATE.O else 1 
	if c_board[6] != BOARD_STATE.EMPTY and	c_board[4] != BOARD_STATE.EMPTY and c_board[2] != BOARD_STATE.EMPTY and c_board[6] == c_board[4] and c_board[4] == c_board[2]:
		return -1 if c_board[6] == BOARD_STATE.O else 1 
	
	if c_board.count(0) == 0:
		return 0

	return 2
	
func minimax(aux_board, win) -> Vector2:
	
	var end = endgame(aux_board)
	if end != 2:
		return end
	
	
	var index: int = -1
	var value: int
	for i in range(9):
		if aux_board[i] == BOARD_STATE.EMPTY:
			var new_board = aux_board
			if win:
				new_board[i] = BOARD_STATE.X				
				var result = minimax(new_board,!win)
				value = max(value,result)
			else:
				new_board[i] = BOARD_STATE.O				
				var result = minimax(new_board,!win)
				value = min(value,result)
	return Vector2(value,aux_board)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
