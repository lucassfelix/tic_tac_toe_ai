extends Button

export(Texture) var hovered_texture
export(Texture) var normal_texture
export(Resource) var clickAudioEvent
export(Resource) var hoverAudioEvent


func _ready():
	icon = normal_texture
	connect("pressed",self,"_on_Button_pressed")
	connect("mouse_entered",self,"_on_Button_mouse_entered")
	connect("mouse_exited",self,"_on_Button_mouse_exited")
	
	
func _on_Button_mouse_entered():
	AudioManager.play(hoverAudioEvent)	
	icon = hovered_texture


func _on_Button_mouse_exited():
	icon = normal_texture


func _on_Button_pressed():
	AudioManager.play(clickAudioEvent)
	icon = normal_texture
