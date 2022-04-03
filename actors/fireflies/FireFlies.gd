extends Area2D

onready var animated_sprite = $AnimatedSprite
onready var timer = $Timer

func _ready():
	_tick_animation()

func _tick_animation():
	animated_sprite.play("default")
	timer.start(rand_range(1, 3))

func _on_Timer_timeout():
	_tick_animation()


func _on_AnimatedSprite_animation_finished():
	animated_sprite.frame = 0
	animated_sprite.stop()


func _on_FireFlies_body_entered(body):
	if body.is_in_group("player"):
		body.on_lightsource(self)


func _on_FireFlies_body_exited(body):
	if body.is_in_group("player"):
		body.off_lightsource(self)
