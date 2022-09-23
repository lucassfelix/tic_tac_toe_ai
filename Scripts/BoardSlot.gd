extends TextureButton

var pos : Array
var piece : Piece

func _ready() -> void:
	pass

func set_piece(new_piece : Piece):
	piece = new_piece
	update_sprite()
	pass
	
func update_sprite():
	set_normal_texture(piece.texture)
	pass
	
func set_pos(new_pos : Array):
	pos = new_pos
	
