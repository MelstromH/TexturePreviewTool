extends FileDialog

func _process(delta):
	if Input.is_action_just_pressed("Menu") && !visible :
		visible = true
