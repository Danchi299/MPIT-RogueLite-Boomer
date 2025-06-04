extends RigidBody2D


@onready var sprite = $Sprite

const explosion_effect   = preload("res://Prefabs/explosion.tscn")

var timer = 0
var EXPLODE_TIME = 4
const SPEED = 5
const radius = 15

func _ready():
	self.set_meta("Type", "Enemy_Bomb")

func _process(delta):
	
	timer += delta
	if not timer >= EXPLODE_TIME:  return 0
	AL.PlaySound("Explosion.wav", -5)
	
	var pos = self.global_position
	for obj in $Area.get_overlapping_bodies():
		
		var obs = obj.global_position
		
		var rot = pos.angle_to_point(obs)
		var dis = pos.distance_to(obs)
		var Vector = Vector2(1, 0).rotated(rot)
		
		var nor = AL.normalize(dis, 0, radius*2)
		var inter = AL.interpolation(nor, 200, 400)
		if obj.get_class() == "RigidBody2D":
			obj.linear_velocity += Vector * inter
		
		match obj.get_meta("Type"):
			"Bomb":
				if obj.timer > 1 : obj.timer -= 0.5
				#obj.timer -= rng.randf_range(1.0/8, 1.0/4)
			"Enemy":
				obj.Hurt(1)
			"Player":
				obj.Hurt(1)
	
	var explosion = explosion_effect.instantiate()
	explosion.global_position = pos
	explosion.global_rotation = self.rotation
	explosion.scale *= float(radius)/15
	AL.AddEffect(explosion)
	AL.Destroy(self)
