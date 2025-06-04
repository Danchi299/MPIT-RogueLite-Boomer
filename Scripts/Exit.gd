extends Node2D

@onready var area = $Area

func _ready():
	self.set_meta("Type", "Exit")

func _process(delta):
	var bodies = area.get_overlapping_bodies()
	for body in bodies:
		if body.get_meta("Type") == "Player":
			AL.main.NextLevel()
	
func _on_area_body_entered(body):
	pass


func _on_area_body_exited(body):
	pass


func _on_area_area_entered(area):
	pass
