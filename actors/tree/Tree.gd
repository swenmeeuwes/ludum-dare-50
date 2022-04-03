extends Node2D

export (int) var index = 0

onready var sprite = $Sprite
onready var completion_particles = $CompletionParticles
onready var alive_particles = $AliveParticles
onready var light = $Light2D
onready var animation_player = $AnimationPlayer

var color_amount = 0.0
var completed = false

var player_in_area

func _ready():
	var material = sprite.get_material()
	material.set_shader_param("color_amount", 0)
	sprite.set_material(material.duplicate())
	light.enabled = false

func add_color(value):	
	color_amount += value
	color_amount = clamp(color_amount, 0, 1)
	
	sprite.get_material().set_shader_param("color_amount", color_amount)
	
	if color_amount >= 1 and not completed:
		complete()

func complete():
	completed = true
	light.enabled = true
	
	get_node("/root/Level1/Gate").turn_on_rune(index)
	
	animation_player.play("complete")
	
	if player_in_area:
			player_in_area.on_lightsource(self)

func _on_Area2D_area_entered(area):
	if completed:
		return
	
	if area.is_in_group("bullet"):
		area.explode()
		add_color(0.4)

func _on_LightArea2D_body_entered(body):
	if body.is_in_group("player"):
		player_in_area = body
		if completed:
			body.on_lightsource(self)

func _on_LightArea2D_body_exited(body):
	if body.is_in_group("player"):
		player_in_area = null
		if completed:
			body.off_lightsource(self)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "complete":
		completion_particles.emitting = true
		alive_particles.emitting = true
