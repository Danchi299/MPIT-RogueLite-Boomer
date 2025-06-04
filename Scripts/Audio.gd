extends AudioStreamPlayer

func _process(delta):
	if self.playing == false: 
		AL.Destroy(self)
