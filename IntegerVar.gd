extends Resource
class_name IntegerVar

export(int) var value

func get_value() -> int:
	return value

func set_value(new_value : int) -> void:
	value = new_value
	var err := ResourceSaver.save(resource_path, self)
	if err:
		print("Falha ao salvar!")
