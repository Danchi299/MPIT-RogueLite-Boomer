extends Node2D

var current_level = "Menu"
var Levels = [
	"Menu",
	"Level 1",
	"Level 2",
	"Level 3",
	"Level 4",
	"Level 5",
	"End"
	]
var Levels_ID = {}

func _ready():
	
	AL.tree = get_tree()
	AL.root = AL.tree.get_root()
	AL.main = AL.root.get_node("Main")
	AL.game = AL.main.get_node("Game")
	
	var i = 0
	for level in Levels:
		Levels_ID[level] = i
		i += 1
	
	ChangeLevel("Menu")

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"): NextLevel()
	if Input.is_action_just_pressed("ui_cancel"): AL.tree.reload_current_scene()

func NextLevel():
	ChangeLevel( Levels[ 1 + Levels_ID[current_level] ] )

func ChangeLevel(id):
	
	for node in self.get_children():
		AL.Destroy(node)
	
	var level = load("res://Scenes/%s.tscn" % id).instantiate()
	AL.game = level
	current_level = id
	
	var main = AL.main
	main.add_child( level )
	
	for name in ["Sounds", "Effects"]:
		var node = Node2D.new()
		node.name = name
		main.add_child( node )
	
