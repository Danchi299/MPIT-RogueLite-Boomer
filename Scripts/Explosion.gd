extends AnimatedSprite2D

func _ready():
	self.play("Default")

func _on_animation_finished():
	AL.Destroy(self)
