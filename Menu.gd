extends Node2D

var box_timer = 1.0

var crate = preload("res://Boxes/Crate.tscn")

var objects_respawned = 0

func _ready():
	pass

func _process(delta):
	box_timer -= delta
	if box_timer < 0:
		box_timer = 0.5 + randf()
		$MenuSlide/Spawn.add_child(crate.instance())
	pass

func _on_BLevels_pressed():
	var t = Tween.new()
	t.interpolate_property(self, "position", position, Vector2(0, -300), 2, Tween.TRANS_CUBIC)
	add_child(t)
	t.start()
	$MenuSlide/BLevels.disabled = true
	pass

func _on_BEasy_pressed():
	get_tree().change_scene("res://Levels/Easy1.tscn")
	pass

func _on_BMedium_pressed():
	get_tree().change_scene("res://Levels/Medium1.tscn")
	pass

func _on_BHard_pressed():
	get_tree().change_scene("res://Levels/Hard1.tscn")
	pass

func _on_BInsanity_pressed():
	get_tree().change_scene("res://Levels/Insane1.tscn")
	pass
