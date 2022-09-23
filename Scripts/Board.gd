class_name Board
extends Control

enum BOARD_PIECE {EMPTY=0, WHITE=1, BLACK=2}

export(Array, Resource) var pieces

export var board_size : int = 3

export(PackedScene) var board_piece : PackedScene

var game_board : Array
var button_board : Array
var current_player : int = 1
var game_has_ended : bool

onready var rng = RandomNumberGenerator.new()

func _ready() -> void:
	
	rng.randomize()
				
	_setup_board()
	
	print("Carregado") # Indica se o tabuleiro foi carregado
			
func _setup_board() -> void:
	
	var grid = $GridContainer
	
	print("Gerado") # Indica se o tabuleiro foi gerado
	
	grid.columns = board_size
	game_board = []
	button_board = []
	for i in range(board_size):
		
		game_board.append([])
		button_board.append([])
		
		for j in range(board_size):
			var new_bp := board_piece.instance()
			grid.add_child(new_bp)
			new_bp.connect("button_up",self,"_on_Button_pressed",[[i,j]])
			
			button_board[i].append(new_bp)
			game_board[i].append(BOARD_PIECE.EMPTY)
			
	grid.set_anchors_preset(Control.PRESET_CENTER)		
	

func reset() -> void:
	$EndgamePanel.hide()
	$PauseButton.show()	
	_define_starting_player()
	for i in range(board_size):
		for j in range(board_size):
			game_board[i][j] = BOARD_PIECE.EMPTY
			button_board[i][j].set_piece(pieces[BOARD_PIECE.EMPTY])
			button_board[i][j].update_hover_texture(pieces[current_player].hover)
			button_board[i][j].set_disabled(true)
	
	var	t = Timer.new()
	t.set_wait_time(0.1)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t,"timeout")
		
	if GameVariables.game_mode == GameVariables.GAME_MODE.AI and current_player == BOARD_PIECE.WHITE:
		make_move($AI.get_ai_play(game_board),pieces[BOARD_PIECE.WHITE])
		set_disabled_buttons(false)		
	else:
		set_disabled_buttons(false)
		
		
func _change_hover_state(hover_texture : StreamTexture) -> void:
	for i in range(board_size):
		for j in range(board_size):
			if game_board[i][j] != BOARD_PIECE.EMPTY:
				button_board[i][j].update_hover_texture(null)
			else:
				button_board[i][j].update_hover_texture(hover_texture)
				

func _define_starting_player() -> void:
	if GameVariables.initial_movement == GameVariables.FIRST.BLACK:
		current_player = BOARD_PIECE.BLACK
	elif GameVariables.initial_movement == GameVariables.FIRST.WHITE:
		current_player = BOARD_PIECE.WHITE
	else:
		if rng.randi() % 2 == 0:
			current_player = BOARD_PIECE.BLACK
		else:
			current_player = BOARD_PIECE.WHITE
			

func make_move(move : Array, piece : Piece) -> bool:
	
	if game_board[move[0]][move[1]] !=  BOARD_PIECE.EMPTY:
		return false
	
	game_board[move[0]][move[1]] = piece.value
	button_board[move[0]][move[1]].set_piece(piece)
	
	_change_hover_state(pieces[-piece.value].hover)
	
	var end : int
	
	if GameVariables.game_mode == GameVariables.GAME_MODE.AI:
		end = endgame(game_board, BOARD_PIECE.WHITE)
	else:
		end = endgame(game_board, current_player)
	
	if end == pieces[BOARD_PIECE.EMPTY].value:
		$EndgamePanel.tie()
	elif end == pieces[BOARD_PIECE.BLACK].value:
		$EndgamePanel.victory()
	elif end == pieces[BOARD_PIECE.WHITE].value:
		$EndgamePanel.defeat()
	else:
		return true
	
	return false


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

func pause_game() -> void:
	$PauseButton.hide()
	set_disabled_buttons(true)

func unpause_game() -> void:
	$PauseButton.show()	
	$EndgamePanel.hide()
	set_disabled_buttons(false)

func set_disabled_buttons(var aux : bool) -> void:
	for i in range(board_size):
		for j in range(board_size):
			button_board[i][j].set_button_disabled(aux)

func _on_Button_pressed(pos : Array) -> void:
	
	var row : int = pos[0]
	var col : int = pos[1]
	
	if GameVariables.game_mode == GameVariables.GAME_MODE.AI:
		
		if !make_move([row,col],pieces[BOARD_PIECE.BLACK]):
			return
		
		var ai_move = $AI.get_ai_play(game_board)
		make_move(ai_move,pieces[BOARD_PIECE.WHITE])
		
	else:
		
		if !make_move([row,col],pieces[current_player]):
			return
			
		current_player = -current_player

func _on_Btn_PlayAgain_pressed():
	$EndgamePanel.hide()
	reset()
