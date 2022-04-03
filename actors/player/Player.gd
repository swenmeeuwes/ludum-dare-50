extends KinematicBody2D

export (Material) var color_fade_mat

onready var collision_shape = $CollisionShape2D
onready var animated_sprite = $Sprite
onready var light = $Light2D
onready var animation_player = $AnimationPlayer
onready var jump_particles = $JumpParticles

var bullet_prefab = preload("res://actors/bullet/Bullet.tscn")

export (int) var movement_speed = 1200
export (int) var jump_speed = -1800
export (int) var gravity = 4000

var shoot_cooldown_millis = 150
var last_shot_time = 0

var last_light_source_pos

var max_light_size = 4
var health = 100.0
var initial_health = 100.0
var health_per_shot = 20.0#1
var health_per_hit = 10
var health_per_second = 3.0

var is_on_light_source = false
var dieing = false

var velocity = Vector2.ZERO
var horizontal_direction = 1

func _ready():
	health = initial_health
	light.texture_scale = max_light_size
	last_light_source_pos = position

func _get_horizontal_input():
	var horizontal_input = 0
	
	if Input.is_action_pressed("move_left"):
		horizontal_input -= movement_speed
		horizontal_direction = -1
		
	if Input.is_action_pressed("move_right"):
		horizontal_input += movement_speed
		horizontal_direction = 1
	
	return horizontal_input

func _process(delta):
	if dieing:
		return
	
	animated_sprite.flip_h = horizontal_direction != 1
	
	var time_now = OS.get_ticks_msec()
	if Input.is_action_pressed("shoot") and time_now - last_shot_time > shoot_cooldown_millis:
		_shoot()
	
	if !is_on_light_source:
		add_health(-health_per_second * delta)
	
	if position.y > 160:
		die();

func _physics_process(delta):
	if !dieing:
		var horizontal_input = _get_horizontal_input()
		velocity.x = horizontal_input
		
		if abs(horizontal_input) > 0:
			animation_player.play("walk")
		else:
			animation_player.play("idle")
		
	velocity.y += gravity * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)
	_clamp_position()

	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_speed
			jump_particles.emitting = false
			jump_particles.emitting = true
#			animated_sprite.play("jump")

func _clamp_position():
	if position.x < 8:
		position.x = 8

func _shoot():
	var time_now = OS.get_ticks_msec()
	last_shot_time = time_now
	
	var bullet = bullet_prefab.instance()
	get_parent().add_child(bullet)
	bullet.position = position + Vector2(horizontal_direction, 0) #* (sprite.texture.get_width() * .5 + 2)
	bullet.setup(horizontal_direction, 150)
	
	if !is_on_light_source:
		add_health(-1)

func on_enemy_hit(enemy):
#	add_health(-health_per_hit)
	die()

func add_health(value):
	set_health(health + value)

func set_health(value):
	health = value
	update_light()
	
	if health <= 0:
		die()
	
func update_light():
	light.texture_scale = lerp(1, max_light_size, (health + 0.001) / initial_health as float) # should be sine I think

func die():
	print("die")
	velocity = Vector2.ZERO
	animated_sprite.play("death")
	animation_player.play("fade_out")
	dieing = true

func on_lightsource(source):
	print("on_lightsource")
	set_health(initial_health)
	is_on_light_source = true
	last_light_source_pos = source.position

func off_lightsource(source):
	print("off_lightsource")
	set_health(initial_health)
	is_on_light_source = false

func respawn():
	print("respawn")
#	animation_player.play("idle")
	animated_sprite.play("default")
	animated_sprite.self_modulate = Color.white
	dieing = false
	position = last_light_source_pos
	set_health(initial_health)

func _on_Sprite_animation_finished():
	pass;

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_out":
		respawn()
