extends Control

const VERSION_SETTING : String = "application/config/version"

#rnelson 9-28-2026 todo: %FpsLabel should work but doesn't, would be good to find out why
@onready var fps_label : Label = $MarginContainer/VBoxContainer/FpsLabel
@onready var version_info : Label = $MarginContainer/VBoxContainer/VersionInfo

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_add_version_to_info_label()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	fps_label.set_text("FPS: " + str(Engine.get_frames_per_second()))
	# tbd: whatever other stuff that should go into DebugInfo

func _add_version_to_info_label():
	var version_str : String = ProjectSettings.get_setting(VERSION_SETTING)
	version_info.text += "Ver: " + version_str
	return null
