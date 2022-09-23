class_name EndgamePanels
extends TextureRect


export(StreamTexture) var victory_panel
export(StreamTexture) var defeat_panel
export(StreamTexture) var tie_panel
export(StreamTexture) var pause_panel

export(Resource) var victory_audio
export(Resource) var defeat_audio
export(Resource) var tie_audio


func _ready():
	hide()
	
func victory():
	$Endgame.show()		
	$Pause.hide()	
	AudioManager.play(victory_audio)
	texture = victory_panel
	show()

func defeat():
	$Endgame.show()	
	$Pause.hide()
	AudioManager.play(defeat_audio)
	texture = defeat_panel
	show()
	
func tie():
	$Endgame.show()	
	$Pause.hide()
	AudioManager.play(tie_audio)
	texture = tie_panel
	show()

func pause():
	$Pause.show()	
	$Endgame.hide()
	texture = pause_panel
	show()
