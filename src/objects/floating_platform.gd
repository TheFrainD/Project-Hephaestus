extends Spatial

onready var animation_player = $AnimationPlayer

func _on_body_entered(body):
	animation_player.play("move_up")


func _on_body_exited(body):
	animation_player.play("move_down")
