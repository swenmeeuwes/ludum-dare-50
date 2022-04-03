extends Sprite

onready var light = $Light2D
onready var animation_player = $AnimationPlayer

var is_on = false

func _ready():
	self_modulate.a = 0
	light.set_enabled(false)
	animation_player.play("off")

func turn_on():
	light.set_enabled(true)
	self_modulate.a = 1
	animation_player.play("on")
	is_on = true

func hide():
	self_modulate.a = 0
