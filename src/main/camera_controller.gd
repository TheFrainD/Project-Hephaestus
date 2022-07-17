extends Camera

export (NodePath) var player_path
export var smoothing = 2.0
export var offset = Vector3.ZERO

onready var player = get_node(player_path)
onready var tween = $Tween

func _ready():
	Events.connect("player_moved", self, "_on_player_moved")
	global_transform.origin.x = player.global_transform.origin.x


func _on_player_moved(direction):
	if not player:
		return
	
	tween.interpolate_property(self, "translation:x",
			global_transform.origin.x, global_transform.origin.x + direction * 2.0, 
			1 / smoothing, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
