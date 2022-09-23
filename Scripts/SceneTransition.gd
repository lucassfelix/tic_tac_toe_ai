extends Node


var current_scene = null


func _ready() -> void:
	var root := get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func goto_scene(path : String) -> void:
	#call_defered("_deffered_goto_scene", path)

func _deffered_goto_scene(path):
	
	current_scene().free()
	
	var s = ResourceLoader.load(path)
	
	current_scene = s.instance()
	
	get_tree
	

