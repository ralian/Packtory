extends Node2D

var speed = (randi() % 30) + 35
var messages = [
	"help im trapped in a cloud factory",
	"i am good at art",
	"im a cloud doot doot",
	"none that I immediately think of",
	"some garbage is ok",
	"try pressing alt+f4",
	"sponsored by cloudcorp",
	"horsey",
	"jame gam",
	"https://youtu.be/dQw4w9WgXcQ",
	"error 404: not found",
	"error 418: I'm a teapot",
	"kilroy was here",
	"send help",
	"*cloud noises*",
	"nothing to see here",
	"hey, you're finally awake",
	"hi, ludum dare"
]

func _ready():
	$CloudSprite.texture = load(str("res://Cloud", randi() % 7, ".png"))
	var scalar = (0.4 * randf()) + 0.6
	scale = Vector2(scalar, scalar)
	if randf() < 0.1:
		messages.shuffle()
		$CloudText.text = messages[0]
	position.y = -(randi() % 30)
	pass

func _process(delta):
	position += Vector2(speed * delta, 0)
	pass
