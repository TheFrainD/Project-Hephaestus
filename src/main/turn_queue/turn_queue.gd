extends Node

var _player = null
var _enemies = []
var _enemies_count = 0
var _player_active = true

onready var timer = $Timer

func _ready():
	_update_children()
	Events.connect("enemy_died", self, "_update_children")

func _process(delta):
	_make_turn()


func _make_turn():
	if _player_active and _player.make_turn():
		_player_active = false
		timer.start()


func _update_children():
	_enemies = []
	
	for child in get_children():
		if not _player:
			if child.is_in_group("Player"):
				_player = child
		
		if child.is_in_group("Enemy"):
			_enemies.append(child)
	
	_enemies_count = _enemies.size()


func _on_timeout():
	for enemy in _enemies:
		if enemy and weakref(enemy).get_ref():
			enemy.make_turn()
	
	_player_active = true
