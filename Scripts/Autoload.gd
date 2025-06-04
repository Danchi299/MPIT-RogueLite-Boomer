extends Node

var BOMB_LIMIT  = 99
var BOMB_RADIUS = 50

@onready var tree = get_tree()
@onready var root = tree.get_root()
@onready var main = root.get_node("Main")
@onready var game = main.get_node("Game")

const delta = 20

func _ready():
	pass

func normalize (x, xmin, xmax): 
	if x >= xmax: return 1
	if x <= xmin: return 0
	return ((x - xmin) / (xmax - xmin))
	
func interpolation (x, xmin, xmax): return ((x*xmin) + ((1-x) * xmax))

func Destroy(object): object.get_parent().remove_child(object)

func PlaySound(name, volume=0):
	var audio: AudioStream = load("res://Sounds/%s" % name)
	var player = AudioStreamPlayer.new()
	
	player.volume_db = volume
	player.set_script(preload("res://Scripts/Audio.gd"))
	player.set_stream(audio)
	root.add_child(player)
	player.play()
	
func AddEffect(Effect): main.get_node("Effects").add_child(Effect)
func AddProj(Proj): game.get_node("Projectiles").add_child(Proj)
	

