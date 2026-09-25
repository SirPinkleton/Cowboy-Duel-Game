extends Node

#rnelson 9-24-2026 todo: move this stuff out of main and into World
const PLAYER : String	= "res://src/gameplay/player/player.tscn"
const LEVEL_1 : String	= "res://src/levels/level_1.tscn"
#uid:// versus res:// ???

#figure out what these are suppose to represent, these Types don't actually exist...
var _player 			: Player = null
var _current_level 	: LEVEL1 = null

#references to root nodes as on-ready variables
#World
@onready var level_root		: Node2D = $World/LevelRoot
@onready var entity_root	: Node2D = $World/EntityRoot
@onready var effect_root	: Node2D = $World/EffectRoot

#UI
@onready var hud_root			: Control = $HudLayer/HudRoot
@onready var pause_root			: Control = $PauseLayer/PauseRoot
@onready var transition_root	: Control = $TransitionLayer/TransitionRoot
@onready var debug_root			: Control = $DebugLayer/DebugRoot


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init_player()
	load_level(LEVEL_1)
	
func _init_player() -> void:
	#get reference to player scene
	var player_scene : PackedScene = ResourceLoader.load(PLAYER) as PackedScene
	if player_scene == null:
		push_error("Could not load player scene: {player_name}".format(PLAYER))
		return
	
	_player = player_scene.instantiate() as Player
	if _player == null:
		push_error("Loaded player failed to instantiate (does it exist?): {player_name}".format(PLAYER))
		return
	
	entity_root.add_child(_player)
	

func load_level(level_ID : String) -> void:
	_deferred_load_level.call_deferred(level_ID)

func _deferred_load_level(level_ID : String) -> void:
	# already loaded level needs to be unloaded
	# consider: phase out old level with a screenwipe? maybe both scenes exist at the same time
	# temporarily? etc.
	if _current_level != null:
		_current_level.queue_free()
		# finish freeing old level before continuing
		await get_tree().process_frame
		_current_level = null
		# verify that that was enough time to free the level.
		# this assumes only 1 level is loaded at a time
		if level_root.get_child_count() > 0:
			push_error("tried to free current scene, but failed.")
	
	var level_scene : PackedScene =\
	 ResourceLoader.load(level_ID) as PackedScene
	if level_scene == null:
		push_error("Could not load level scene: {level_name}".format(level_ID))
		return

	_current_level = level_scene.instantiate() as LEVEL1
	if _current_level == null:
		push_error("Loaded level failed to instantiate (does it exist?): {level_name}".format(level_ID))
		return
	
	level_root.add_child(_current_level)
	
	# we should have loaded the player earlier, and we've just loaded a new level.
	# allow some time for the stuff to load
	await get_tree().process_frame
	# place the player at the right spot
	_place_player_at_level_spawn()
	# adjust the camera to show player in the latest position
	_setup_level_camera()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
