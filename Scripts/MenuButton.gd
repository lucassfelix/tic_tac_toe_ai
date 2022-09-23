extends Button

export(Texture) var hovered_texture
export(Texture) var normal_texture
export(Resource) var clickAudioEvent
export(Resource) var hoverAudioEvent


# Called when the node enters the scene tree for the first time.
func _ready():
	icon = normal_texture
	connect("pressed",self,"_on_Button_pressed")
	connect("mouse_entered",self,"_on_Button_mouse_entered")
	connect("mouse_exited",self,"_on_Button_mouse_exited")
	
	pass

func _on_Button_mouse_entered():
	AudioManager.playSound(hoverAudioEvent)	
	icon = hovered_texture
	pass

func _on_Button_mouse_exited():
	icon = normal_texture
	pass

func _on_Button_pressed():
	AudioManager.playSound(clickAudioEvent)

