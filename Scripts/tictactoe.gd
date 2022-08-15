extends Node2D

enum BOARD_STATE {EMPTY= 0, X=-1, O=1};
var board: Array;
var ai_symbol : int = BOARD_STATE.X;
var debug_mode : bool = false;

func _ready() -> void:
	for i in range(9):
		board.append(BOARD_STATE.EMPTY);
	var new_board : Array;
	
	new_board = board.duplicate(true);
	new_board[0] = ai_symbol
	drawDebugBoard(new_board);
	print(minimax2(new_board,false))
	
	new_board = board.duplicate(true);
	new_board[1] = ai_symbol
	drawDebugBoard(new_board);
	print(minimax2(new_board,false))
	
	new_board = board.duplicate(true);
	new_board[2] = ai_symbol
	drawDebugBoard(new_board);
	print(minimax2(new_board,false))
	
	new_board = board.duplicate(true);
	new_board[3] = ai_symbol
	drawDebugBoard(new_board);
	print(minimax2(new_board,false))
	
	new_board = board.duplicate(true);
	new_board[4] = ai_symbol
	drawDebugBoard(new_board);
	print(minimax2(new_board,false))

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
	if c_board[0] != BOARD_STATE.EMPTY and	c_board[1] != BOARD_STATE.EMPTY and c_board[2] != BOARD_STATE.EMPTY and c_board[0] == c_board[1] and c_board[1] == c_board[2]:
		return 1 if c_board[0] == ai_symbol else -1 
	if c_board[3] != BOARD_STATE.EMPTY and	c_board[4] != BOARD_STATE.EMPTY and c_board[5] != BOARD_STATE.EMPTY and c_board[3] == c_board[4] and c_board[4] == c_board[5]:
		return 1 if c_board[3] == ai_symbol else -1 
	if c_board[6] != BOARD_STATE.EMPTY and	c_board[7] != BOARD_STATE.EMPTY and c_board[8] != BOARD_STATE.EMPTY and c_board[6] == c_board[7] and c_board[7] == c_board[8]:
		return 1 if c_board[6] == ai_symbol else -1 
	if c_board[0] != BOARD_STATE.EMPTY and	c_board[3] != BOARD_STATE.EMPTY and c_board[6] != BOARD_STATE.EMPTY and c_board[0] == c_board[3] and c_board[3] == c_board[6]:
		return 1 if c_board[0] == ai_symbol else -1 
	if c_board[1] != BOARD_STATE.EMPTY and	c_board[4] != BOARD_STATE.EMPTY and c_board[7] != BOARD_STATE.EMPTY and c_board[1] == c_board[4] and c_board[4] == c_board[7]:
		return 1 if c_board[1] == ai_symbol else -1 
	if c_board[2] != BOARD_STATE.EMPTY and	c_board[5] != BOARD_STATE.EMPTY and c_board[8] != BOARD_STATE.EMPTY and c_board[2] == c_board[5] and c_board[5] == c_board[8]:
		return 1 if c_board[2] == ai_symbol else -1 
	if c_board[0] != BOARD_STATE.EMPTY and	c_board[4] != BOARD_STATE.EMPTY and c_board[8] != BOARD_STATE.EMPTY and c_board[0] == c_board[4] and c_board[4] == c_board[8]:
		return 1 if c_board[0] == ai_symbol else -1 
	if c_board[6] != BOARD_STATE.EMPTY and	c_board[4] != BOARD_STATE.EMPTY and c_board[2] != BOARD_STATE.EMPTY and c_board[6] == c_board[4] and c_board[4] == c_board[2]:
		return 1 if c_board[6] == ai_symbol else -1 
	
	if c_board.count(0) == 0:
		return 0

	return 2

func geraRamificacoes(aux_board : Array, ai_turn : bool) -> Array:
	var branches : Array;
	for index in range(9):
		if aux_board[index] == BOARD_STATE.EMPTY:
			var new_board = aux_board.duplicate(true);
			new_board[index] = ai_symbol if ai_turn else -ai_symbol;
			branches.append(new_board);
	return branches;

func minimax2(aux_board : Array, ai_turn : bool) -> int:
	
	#Avalia se o jogo acabou.
	var end : int = endgame(aux_board);
	if end != 2:
		#Se o jogo acabou, retorna o score do resultado final.
		if debug_mode:
			print("ENDGAME Value: " + str(end));
		return end;
		
	var valor : int;
	var branches = geraRamificacoes(aux_board,ai_turn);
	if debug_mode:
		print("\nBranches\n")
		for b in branches:
			drawDebugBoard(b)
			
	var valores : Array;
	if ai_turn:
		#Se for o turno da IA
		valor = -9;
		for new_board in branches:
			var new_value : int = minimax2(new_board,!ai_turn);
			valores.append(new_value)
			valor = max(valor,new_value);
	else:
		#Se for o turno do jogador
		valor = 9;
		for new_board in branches:
			var new_value : int = minimax2(new_board,!ai_turn);
			valores.append(new_value)
			valor = min(valor,new_value);
			
	if debug_mode:
		print("\nMinimax Result\n");
		drawDebugBoard(aux_board);
		print("Turno da IA? " + str(ai_turn))
		print(valores)
		print(valor)
	return valor;

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
