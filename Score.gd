extends Position2D

func _process(delta):
	var yMin = 10000
	for item in $"../Boxes".get_children():
		var itemMinY = item.get_min_y()
		if itemMinY < yMin: yMin = itemMinY
	
	position.y = yMin
	pass
