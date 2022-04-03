extends KinematicBody2D

export (Vector2) var end_position
export (float) var speed = 0.5

onready var body_sprite = $Body
onready var eyes_sprite = $Eyes

var start_position
var interpolator = 0.0

func _ready():	
	start_position = position
	
	# sync animated sprites
	body_sprite.frame = 0
	eyes_sprite.frame = 0

func _process(delta):
	interpolator += speed * delta
	position = lerp(start_position, end_position, sin(interpolator) * .5 + .5)


func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		body.on_enemy_hit(self)

func on_bullet_hit():
	queue_free()
