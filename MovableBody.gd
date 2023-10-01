extends RigidBody2D
class_name MovableBody

var P = 20
var D = 20000

var is_mouse_inside : bool = false
var is_grabbed : bool = false
var grabbed_pos : Vector2 = Vector2(0, 0)
var last_global_error : Vector2 = Vector2(0, 0)

func on_mouse_entered():
	is_mouse_inside = true
	pass

func on_mouse_exited():
	is_mouse_inside = false
	#is_grabbed = false
	pass

func is_in_bounds():
	var xMin = $"../../PtA".position.x
	var xMax = $"../../PtB".position.x
	if $Collision is CollisionShape2D:
		var coll : CollisionShape2D = $Collision
		if coll.shape is RectangleShape2D:
			var shp : RectangleShape2D = coll.shape
			var perms = [Vector2(1,1), Vector2(-1,1), Vector2(-1,-1), Vector2(1,-1)]
			for perm in perms:
				var x = to_global(shp.extents * perm * scale).x
				if x < xMin or x > xMax: return false
			return true
		if coll.shape is CircleShape2D:
			var shp : CircleShape2D = coll.shape
			var x = position.x
			return (x - shp.radius) > xMin and (x + shp.radius) < xMax
	
	if $Collision is CollisionPolygon2D:
		var coll : CollisionPolygon2D = $Collision
		for point in coll.polygon:
			if to_global(point * scale).x < xMin or to_global(point * scale).x > xMax:
				return false
		return true
	
	return false

func get_min_y():
	if $Collision is CollisionShape2D:
		var coll : CollisionShape2D = $Collision
		if coll.shape is RectangleShape2D:
			var yMin = to_global(Vector2(0, 0)).y
			var shp : RectangleShape2D = coll.shape
			var perms = [Vector2(1,1), Vector2(-1,1), Vector2(-1,-1), Vector2(1,-1)]
			for perm in perms:
				var y = to_global(shp.extents * perm).y
				if y < yMin: yMin = y
			return yMin
		if coll.shape is CircleShape2D:
			var shp : CircleShape2D = coll.shape
			return to_global(Vector2(0, 0)).y - shp.radius
	
	if $Collision is CollisionPolygon2D:
		var coll : CollisionPolygon2D = $Collision
		var yMin = to_global(Vector2(0, 0)).y
		for point in coll.polygon:
			var y = to_global(point * coll.scale).y
			if y < yMin: yMin = y
		return yMin
	
	# Should never happen
	return to_global(Vector2(0, 0)).y

func _ready():
	input_pickable = true
	connect("mouse_entered", self, "on_mouse_entered")
	connect("mouse_exited", self, "on_mouse_exited")
	pass

func _process(delta):
	applied_force = Vector2(0, 0)
	applied_torque = 0
	
	if position.y > $"../../RespawnFloor".position.y:
		position = $"../../Spawn".position
		linear_velocity = Vector2(0, 0)
		angular_velocity = 0
		if $"../..".has_method("inc_objects_respawned"):
			$"../..".inc_objects_respawned()
		return
	
	if is_grabbed:
		var global_error = get_global_mouse_position() - to_global(grabbed_pos)
		var pid_out = global_error * P + (global_error - last_global_error) * delta * D
		add_force(to_global(grabbed_pos) - to_global(Vector2(0, 0)), mass * pid_out)
		last_global_error = global_error
	pass

func _input(event : InputEvent):
	if event is InputEventMouseButton:
		if event.is_pressed() and is_mouse_inside:
			#print("Grabbed at ", get_local_mouse_position(), " global mouse pos: ", get_global_mouse_position())
			grabbed_pos = get_local_mouse_position()
			is_grabbed = true
		else:
			is_grabbed = false
	pass
