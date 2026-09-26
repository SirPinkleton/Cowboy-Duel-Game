@tool
extends Sprite2D
# Sprite Preview Tool for updating spawner preview in editor

const NULL_SPRITE : Texture2D = preload("res://assets/art/characters/enemies/null.png")

var _previous_texture : Texture2D = null

@onready var preview_refresh_timer : Timer = $PreviewRefreshTimer

func _ready() -> void:
	if not Engine.is_editor_hint():
		queue_free()
		return
	
	preview_refresh_timer.timeout.connect(_on_refresh_timeout)
	preview_refresh_timer.start(.25)
	_on_refresh_timeout()

func _on_refresh_timeout() -> void:
	var spawner : Spawner = get_parent() as Spawner
	if !is_instance_valid(spawner):
		push_warning("spawner couldn't be acquired for refresh timeout")
		return
	
	var definition : EnemyDefinition = spawner.enemy_definition
	
	var new_texture : Texture2D =\
		definition.preview_texture if (definition && definition.preview_texture) else NULL_SPRITE
	
	if new_texture == _previous_texture:
		return
	
	_previous_texture = new_texture
	texture = new_texture
