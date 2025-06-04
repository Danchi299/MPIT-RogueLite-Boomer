extends RigidBody2D

var IN = Input

@onready var Sprite = $AnimatedSprite
@onready var bombs = AL.game.get_node("Projectiles/Bombs")
const bomb_fab = preload("res://Prefabs/bomb.tscn")

func _ready():
	self.set_meta("Type", "Player")
	Dead = false
	$Camera.make_current()

var Health  = 5
var Dead    = false
var iframes = 0 

func _physics_process(delta):
	move_and_collide( 3*Vector2( (int(IN.is_action_pressed("ui_right")) - int(IN.is_action_pressed("ui_left"))), (int(IN.is_action_pressed("ui_down")) - int(IN.is_action_pressed("ui_up"))) ) )
	
	self.apply_central_force(-self.linear_velocity*2)
	if iframes > 0: iframes -= delta
	else: iframes = 0

const LEFT_MOUSE_BUTTON = 1
func _input(event):
	
	if     (Dead): return 0
	if not (event is InputEventMouseButton): return 0
	if not (event.button_mask == LEFT_MOUSE_BUTTON): return 0
	
	if bombs.get_child_count() >= AL.BOMB_LIMIT: return 0
	
	var pos   = self.global_position
	var click = get_global_mouse_position()
	
	var rot    = pos.angle_to_point(click)
	var dis    = pos.distance_to(click)
	var Vector = Vector2(1, 0).rotated(rot)
	
	AL.PlaySound("Throw.wav")
	Sprite.stop()
	Sprite.play("Throw")
	
	var bomb = bomb_fab.instantiate()
	bomb.global_position = self.global_position + Vector*15
	bombs.add_child(bomb)
	bomb.linear_velocity = Vector*dis

func Hurt(dmg):
	if Dead: return 0
	if iframes: return 0
	
	Health -= dmg
	iframes = 1.5
	AL.PlaySound("Hurt.wav")
	
	if not(Health <= 0): 
		$Flash.play("Flash")
		return 0	
	Dead = true
	Sprite.play("Death")
	$Collision.disabled = true
