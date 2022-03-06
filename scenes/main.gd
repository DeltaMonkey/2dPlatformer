extends Node

func _ready():
	pass 
	
func _process(delta):
	$fps.text = str(Engine.get_frames_per_second())
