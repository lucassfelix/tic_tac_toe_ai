extends Button

export(Texture) var hovered_texture
export(Texture) var normal_texture

# Called when the node enters the scene tree for the first time.
func _ready():
	icon = normal_texture
	pass

func _on_Button_mouse_entered():
	icon = hovered_texture
	pass

func _on_Button_mouse_exited():
	icon = normal_texture
	pass



