extends Control

var menu_transition_time := 0.5
var menu_size : Vector2

onready var title_menu = $TitleScreen
onready var settings_menu = $SettingsScreen
onready var tween = $Tween


func _ready():
	menu_size = get_viewport_rect().size


func move_to_options():
	tween.interpolate_property(	
			title_menu,
			"rect_global_position",
			title_menu.rect_global_position,
			Vector2(0,-menu_size.y),
			menu_transition_time,
			Tween.TRANS_CUBIC,
			Tween.EASE_OUT
		)
	tween.interpolate_property(	
			settings_menu,
			"rect_global_position",
			settings_menu.rect_global_position,
			Vector2.ZERO,
			menu_transition_time,
			Tween.TRANS_CUBIC,
			Tween.EASE_OUT
		)
	tween.start()
		

func move_to_title():
	tween.interpolate_property(	
			title_menu,
			"rect_global_position",
			title_menu.rect_global_position,
			Vector2.ZERO,
			menu_transition_time,
			Tween.TRANS_CUBIC,
			Tween.EASE_OUT
		)
	tween.interpolate_property(	
			settings_menu,
			"rect_global_position",
			settings_menu.rect_global_position,
			Vector2(0,menu_size.y),
			menu_transition_time,
			Tween.TRANS_CUBIC,
			Tween.EASE_OUT
		)
	tween.start()

func move_to_board():
	$SettingsScreen.hide()
	$TitleScreen.hide()
	$Board.show()
	$Board.reset()
	
func move_from_board():
	$Board.hide()
	$SettingsScreen.show()
	$TitleScreen.show()
