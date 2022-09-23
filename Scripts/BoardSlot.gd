class_name BoardSlot
extends TextureButton

export(Resource) var hover_event

var pos : Array
var piece : Piece

func _ready() -> void:
	pass

func set_piece(new_piece : Piece):
	piece = new_piece
	if piece.audio_event != null:
		AudioManager.play(piece.audio_event)
	update_normal_texture()
	disable_mouse()
	pass
	
func disable_mouse():
	mouse_default_cursor_shape = Control.CURSOR_ARROW
	
func set_button_disabled(var aux : bool) -> void:
	set_disabled(aux)
	
func update_normal_texture():
	set_normal_texture(piece.texture)
	pass

func update_hover_texture(hover : StreamTexture):
	texture_hover = hover	

func set_pos(new_pos : Array):
	pos = new_pos

func _on_BoardSlot_mouse_entered():
	if  !is_disabled():
		AudioManager.play(hover_event)	
