extends Node

#consider: loading and uploading levels and stuff... maybe level_1 shouldn't
# directly inherit from main, but should have an empty level_loader node,
# which will load other levels/screens?

# visibleonscreenenabler2d, add to enemies, so they only activate when player is nearby
# visibleonscreennotifier2d, to do other stuff than enabling when onscreen
# consider also: a spawner with this thing on it, which controls if they spawn, when they spawn, and respawn logic

#blurry pixel font = MSDF (project settings>GUI>Theme>Font>Multichannel Signed Distance Field)

# show mouse on screen (accessibility)
func set_mouse_cursor_visible(is_visible: bool):
	if false == is_visible:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

# change game speed (accessibility/debug option)
static func change_game_timescale(timescale_value: float = 1):
	if timescale_value <= 0.0:
		return #or throw an error?
	
	Engine.time_scale = timescale_value
	
	#todo: replace 60 with the constant, when I can ref it correctly
	Engine.physics_ticks_per_second = floori(60 * timescale_value)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
