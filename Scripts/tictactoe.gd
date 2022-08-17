extends Node2D

enum BOARD_STATE {EMPTY= 0, X=-1, O=1};
var board: Array;
var ai_symbol : int = BOARD_STATE.X;

func _ready() -> void:
	for _i in range(9):
		board.append(BOARD_STATE.EMPTY);
	drawDebugBoard(board);
	pass
	
func drawDebugBoard(aux_board):
	
	var key = {
		-1 : "X",
		1 : "O",
		0 : " "
	}

	print(key[aux_board[0]]+"|"+key[aux_board[1]]+"|"+key[aux_board[2]])	
	print(key[aux_board[3]]+"|"+key[aux_board[4]]+"|"+key[aux_board[5]])
	print(key[aux_board[6]]+"|"+key[aux_board[7]]+"|"+key[aux_board[8]])
	print()

func endgame(c_board):
	for row in range(0,7,3):
		if c_board[row] != BOARD_STATE.EMPTY and	c_board[row+1] != BOARD_STATE.EMPTY and c_board[row+2] != BOARD_STATE.EMPTY and c_board[row] == c_board[row+1] and c_board[row+1] == c_board[row+2]:
			return 1 if c_board[row] == ai_symbol else -1
	for col in range(3):
		if c_board[col] != BOARD_STATE.EMPTY and	c_board[col+3] != BOARD_STATE.EMPTY and c_board[col+6] != BOARD_STATE.EMPTY and c_board[col] == c_board[col+3] and c_board[col+3] == c_board[col+6]:
			return 1 if c_board[col] == ai_symbol else -1  
	if c_board[0] != BOARD_STATE.EMPTY and	c_board[4] != BOARD_STATE.EMPTY and c_board[8] != BOARD_STATE.EMPTY and c_board[0] == c_board[4] and c_board[4] == c_board[8]:
		return 1 if c_board[0] == ai_symbol else -1 
	if c_board[6] != BOARD_STATE.EMPTY and	c_board[4] != BOARD_STATE.EMPTY and c_board[2] != BOARD_STATE.EMPTY and c_board[6] == c_board[4] and c_board[4] == c_board[2]:
		return 1 if c_board[6] == ai_symbol else -1 
	
	if c_board.count(0) == 0:
		return 0

	return 2

func geraRamificacoes(aux_board : Array, ai_turn : bool) -> Array:
	var branches : Array = [];
	for index in range(9):
		if aux_board[index] == BOARD_STATE.EMPTY:
			var new_board = aux_board.duplicate(true);
			new_board[index] = ai_symbol if ai_turn else -ai_symbol;
			branches.append(new_board);
	return branches;

func minimax(aux_board : Array, ai_turn : bool) -> Array:
	
	#Avalia se o jogo acabou.
	var end : int = endgame(aux_board);
	if end != 2:
		#Se o jogo acabou, retorna o score do resultado final.
		return [end, [aux_board]];
		
	var valor : int;
	var bestBranches : Array = [];
	
	var branches = geraRamificacoes(aux_board,ai_turn);
	if ai_turn:
		#Se for o turno da IA
		valor = -9;
		for new_board in branches:
			var new_value : int = minimax(new_board,!ai_turn)[0];
			
			if new_value == valor:
				bestBranches.append(new_board)
			elif  new_value > valor:
				bestBranches.clear()
				bestBranches.append(new_board)
				valor = new_value
			
	else:
		#Se for o turno do jogador
		valor = 9;
		for new_board in branches:
			var new_value : int = minimax(new_board,!ai_turn)[0];
			if new_value == valor:
				bestBranches.append(new_board)
			elif  new_value < valor:
				bestBranches.clear()
				bestBranches.append(new_board)
				valor = new_value
	return [valor,bestBranches];

func _on_Button_pressed() -> void:
	var play = $TextEdit.text as int;
	board[play] = -ai_symbol;
	drawDebugBoard(board);
	var minmax = minimax(board, true);
	print(minmax)
	board = minmax[1][0]
	drawDebugBoard(board);
