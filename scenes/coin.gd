extends Node2D

func _ready():
	 $Area2D.connect("area_entered", self, "on_area_entered")

func on_area_entered(area2d):
	$AnimationPlayer.play("pickUp")
	call_deferred("destroy_pickup")
	
func destroy_pickup():
	$Area2D/CollisionShape2D.disabled = true
