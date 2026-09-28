class_name LEVEL1
extends BaseLevel

var player_spawn_location : Vector2

@onready var player_spawn_marker : Marker2D = $PlayerSpawn

func get_default_player_spawn() -> Vector2:
	return player_spawn_location

func get_player_camera() -> Camera2D:
#rnelson 9-25-2026 todo: define
	return null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_spawn_location = player_spawn_marker.position
