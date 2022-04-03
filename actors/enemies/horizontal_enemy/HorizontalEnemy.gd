extends KinematicBody2D

onready var sprite = $Sprite

var direction = Vector2.RIGHT
var speed = 0

var initial_speed = 800
var speed_increase = 50

func _ready():
	speed = initial_speed

func _physics_process(delta):
	move_and_slide(direction * speed * delta)
	speed += speed_increase
	
	if is_on_wall():
		_flip()

func _flip():
	sprite.flip_h = direction.x == 1
	
	direction.x = -direction.x
	speed = initial_speed
