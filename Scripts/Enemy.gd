extends CharacterBody2D

var health = 3
var max_health = 3
var damage = 1
var speed  = 1

var ShotDown = 1
var ShotTime = 1.75

@onready var Nav = $Navigation
@onready var Player = AL.game.get_node("Player")
@onready var Sprite = $AnimatedSprite 
var shot_fab = preload("res://Prefabs/Enemy_Shot.tscn")

var type = "Bat"

func Die():
	AL.Destroy(self)

func Hurt(dmg):
	health -= 1
	AL.PlaySound("Hurt.wav", 10)
	$Animation.play("Hurt")
	if health <= 0: Die()

func Shoot(rot):
	AL.PlaySound("Laser.wav", -5)
	
	var Vector = Vector2(1, 0).rotated(rot)
	var shot = shot_fab.instantiate()
	shot.global_position = self.global_position + Vector*15
	shot.rotation = rot
	
	var dis = self.global_position.distance_to(Player.global_position)
	shot.linear_velocity += Vector * dis 
	
	AL.AddProj(shot)

func Move(Vector):
	
	velocity = Vector
	move_and_slide()

func _ready():
	Nav.connect("velocity_computed", Move)
	Sprite.play("Walk")
	self.set_meta("Type", "Enemy")
	
	if $Shooter: 
		type = "Eye"
		max_health = 5
		health = max_health

func _process(delta):
	
	var pos = self.global_position
	var plp = Player.global_position
	
	Nav.target_position = plp
	var end = Nav.get_next_path_position()
	
	var rot = pos.angle_to_point(end)
	var Vector = Vector2(1, 0).rotated(rot)
	
	Sprite.flip_h = (pos.x - end.x) > 0
	
	if type == "Eye": 
		
		var Shooter = $Shooter
		
		Shooter.look_at(plp)
		var col = $Shooter/Aim.get_collider()
		if col:
			if col.get_meta("Type") in ["Player", "Bomb"]: 
				
				if ShotDown > 0: 
					ShotDown -= delta
				else: 
					ShotDown = ShotTime
					Shoot(pos.angle_to_point(plp))
				
				return 0
	
	Nav.set_velocity( Vector * delta * AL.delta * speed )
	var col = move_and_collide( Vector * delta * AL.delta * speed )
	if type == "Eye": return 0
	if not col: return 0
	var touched = col.get_collider()
	if not (touched.get_meta("Type") == "Player"): return 0
	
	touched.Hurt(damage)
