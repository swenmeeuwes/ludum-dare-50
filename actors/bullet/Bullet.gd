extends Area2D

onready var animation_player = $AnimationPlayer
onready var sprite = $Sprite

var horizontal_direction = 0
var speed = 0

func _ready():
	animation_player.play("idle")

func _process(delta):
	var direction = Vector2(horizontal_direction, 0)
	position += direction * speed * delta

func setup(initial_horizontal_direction, initial_speed):
	horizontal_direction = initial_horizontal_direction
	speed = initial_speed

func explode():
	speed = 0
	animation_player.play("explode")

func _on_Bullet_body_entered(body):
	explode()
	
	if body.is_in_group("enemy"):
		body.on_bullet_hit()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "explode":
		queue_free()
