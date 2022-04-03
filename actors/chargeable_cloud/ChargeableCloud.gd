extends KinematicBody2D

onready var collider = $CollisionShape2D
onready var sprite = $Sprite
onready var charge_collider = $HitArea2D

var charge = 0.0
var charge_decay_per_second = 1.0 / 4.0 # avialable for 4 seconds on full charge

var mat

func _ready():
	var material = sprite.get_material()
	material.set_shader_param("color_amount", 0)
	mat = material.duplicate()
	sprite.set_material(mat)

func _process(delta):
	collider.disabled = charge <= 0
	
	mat.set_shader_param("color_amount", charge)
	
	var light_value = .3 + .7 * charge
	sprite.self_modulate = Color(light_value, light_value, light_value, 1)
	
	add_charge(-charge_decay_per_second * delta)

func add_charge(value):
	charge += value
	
	charge = clamp(charge, 0, 1)


func _on_HitArea2D_area_entered(area):
	if area.is_in_group("bullet") and charge < .1:
		area.explode()
		add_charge(1)
