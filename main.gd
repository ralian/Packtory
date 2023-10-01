extends Node2D

var cloud_timer = 2.0

var level_started = false
var level_timer = 0.0
var level_time_max = -1

var can_pick_objects = false

var objects_respawned = 0
func inc_objects_respawned():
	objects_respawned += 1
	pass

func _ready():
	$StartScreen.visible = true
	$StartScreen.pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().paused = true
	pass

# Level start
func _on_Button_pressed():
	can_pick_objects = true
	level_started = true
	$StartScreen.visible = false
	for child in get_children():
		if child.get_name() == "LevelTimeMax":
			level_time_max = float(child.text)
	get_tree().paused = false
	pass

func _process(delta):
	if level_started:
		level_timer += delta
		$LevelTime.text = str(int(level_timer))
		if level_time_max > 0 and level_timer > level_time_max:
			_on_EndLevel_pressed()
	
	cloud_timer -= delta
	if cloud_timer < 0:
		cloud_timer = 5.0 + randf() * 10
		var cloud = load("res://Cloud.tscn").instance()
		$CloudSpawn.add_child(cloud)
	
	for cloud in $CloudSpawn.get_children():
		if cloud.position.x > $CloudDespawn.position.x:
			cloud.queue_free()
	
	var all_in_box = true
	for box in $Boxes.get_children():
		if not box.is_in_bounds():
			box.modulate = Color(1, 1, 1, 1)
			all_in_box = false
		else:
			box.modulate = Color(0.65, 1, 0.65, 1)
	$EndLevel.disabled = not all_in_box or not level_started
	pass

func _on_EndLevel_pressed():
	level_started = false
	$EndLevel.disabled = true
	can_pick_objects = false
	var t = Tween.new()
	t.interpolate_property($MasterCrate, "position", $MasterCrate.to_global(Vector2.ZERO), $MasterCrate.to_global(Vector2.ZERO) + Vector2(0, $Score.position.y - $PtA.position.y - 20), 2, Tween.TRANS_CUBIC)
	$MasterCrate.add_child(t)
	t.start()
	
	var fScore = 100 * (($Score.position.y - $ScoreY0.position.y) / ($ScoreY100.position.y - $ScoreY0.position.y))
	fScore = int(clamp(fScore, 0, 100))
	$EndScreen/ColorRect/LevelText.text += str(fScore)
	
	for box in $Boxes.get_children():
		if not box.is_in_bounds():
			$EndScreen/ColorRect/LevelText.text += "\n   -20: Item not in crate"
			fScore -= 20
	
	$EndScreen/ColorRect/LevelText.text += "\n\nItems dropped: -5 * " + str(objects_respawned)
	
	fScore -= objects_respawned * 5
	
	$EndScreen/ColorRect/LevelText.text += "\n\nFinal Score = " + str(fScore)
	
	yield(get_tree().create_timer(3), "timeout")
	$EndScreen.visible = true
	pass

func _on_NextLevel_pressed():
	if $EndScreen/NextLevel.get_child_count() < 1:
		get_tree().change_scene("res://Menu.tscn")
	else:
		get_tree().change_scene("res://Levels/" + $EndScreen/NextLevel.get_child(0).get_name() + ".tscn")
	pass
