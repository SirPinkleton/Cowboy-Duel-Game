class_name Spawner
extends Marker2D

#rnelson 9-24-2026 todo: probably I should have a zone that extends the bounds
#of the spawner, such that the enemy spawns right _before_ the player shows up
#otherwise if the player moves fast enough they can see the enemy spawn in? need to test

enum WhenToSpawn {
	WHEN_BECOME_VISIBLE, 	# when spawner comes on screen, spawn
	WHEN_TIMER_END, 	# start a timer, spawn when it finishes
	ENEMY_ALERTED, # when enemy has been alerted
	NEVER 			# debug: turn off spawner
}

enum SpawnEvent {
	CAMERA_ENTERED,
	CAMERA_EXITED,
	COOLDOWN_FINISHED,
	ENEMY_ALERTED
}

var _spawn_manager : SpawnManager = null

@export var enemy_definition : EnemyDefinition #rnelson 9-24-2026 todo: use this in the below
# Enemy can spawn in multiple scenarios. NOTE: will still only spawn once.
# NOTE: if only spawn_mode is alert, then it will only spawn if the spawner is on
# screen at the time of the alert. if this isn't the case, then will never spawn
# (unless enemy alerts can happen multiple times)
@export var spawn_modes : Array[Spawner.WhenToSpawn]

 # retrieved from definition
var _enemy_scene 				: PackedScene = null
var _default_cooldown_time 		: float = 0.0
var _cooldown_to_use 			: float = 0.0
var _wait_for_alert				: bool = false

# spawner booleans to track
var _spawner_is_visible 	: bool = false # true if spawner is on screen (screen_entered callback)
var _has_spawned 			: bool = false # true when spawn happens

# Local node references
@onready var spawn_delay_timer 		: Timer = $SpawnDelayTimer
@onready var visibility_notifier 	: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

func _ready() -> void:
	_spawn_manager = Global_GameManager.spawn_manager
	
	if !is_instance_valid(enemy_definition):
		push_error("spawner has no definition to use: " + name)
		return
	
	# save off values from definition
	_enemy_scene = enemy_definition.scene
	_default_cooldown_time = enemy_definition.cooldown_time
	var randomized_cooldown_time = randf_range(0.0, enemy_definition.randomize_cooldown_time)
	_cooldown_to_use = _default_cooldown_time + randomized_cooldown_time
	_wait_for_alert = enemy_definition.spawnOnlyOnAlert
	
	# connect signals
	visibility_notifier.screen_entered.connect(self._on_camera_entered)
	visibility_notifier.screen_exited.connect(self._on_camera_exited)
	spawn_delay_timer.timeout.connect(self._on_respawn_timer_timeout)
	#rnelson 9-25-2026 todo: figure this out
	#Global.Game_Manager.alert_manager.alert_raised.connect(self._on_enemy_alerted)

# any number of triggers could have caused the prompt to spawn, and numerous considerations
	# could mean that spawning is the wrong thing to do.
	# ex: enemies are alerted, but spawner isn't on screen
	# ex: spawner has entered screen, but has already spawned enemy
	# ex: spawner has entered screen, but this spawner is set to spawn after a delay
	# this method works through these considerations and either passes, or spawns the enemy
func _handle_spawn_event(spawn_event : SpawnEvent) -> void:
	push_warning("event: " + SpawnEvent.keys()[spawn_event])
	# This spawner has already done it's duty, ignore the event
	if (_has_spawned):
		push_warning("already spawned")
		return
	
	# this event is not for this spawner, ignore
	if (!spawn_modes.has(spawn_event)):
		push_warning("wrong event for " + name)
		return
	
	if (spawn_event == SpawnEvent.ENEMY_ALERTED && !_spawner_is_visible):
		push_warning("care about alert but spawner isn't visible")
		#either enemy only spawns on alert, so only for the current screen
		#or enemy spawns on alert or on screen, but spawner not on screen
		return

	#rnelson 9-25-2026 todo: define a global handler for alert state
	#if (_wait_for_alert && !Global.Game_Manager.alert_manager.enemies_alerted)
	#	return
	
	# if we've reached this point, we haven't been filtered. We're good to spawn.
	_instantiate_and_add_to_level()

func _instantiate_and_add_to_level() -> bool:
	#rnelson 9-24-2026 todo: define spawn_enemy. replaces all of the below (position, add_child)
	#also, define EnemyCore
	var enemy_instance : EnemyCore = _spawn_manager.spawn_enemy(_enemy_scene, global_transform)
	
	if !is_instance_valid(enemy_instance):
		push_error("Spawner cannot instantiate enemy instance: " + name)
		return false
	
	_has_spawned = true
	return true


#region Signal Handlers

func _on_camera_entered() -> void:
	_spawner_is_visible = true
	# only start timer if global "enemy is alerted" thing is on?
	spawn_delay_timer.start(_cooldown_to_use)
	_handle_spawn_event(SpawnEvent.CAMERA_ENTERED)
	
func _on_camera_exited() -> void:
	_spawner_is_visible = false
	_handle_spawn_event(SpawnEvent.CAMERA_EXITED)

func _on_respawn_timer_timeout() -> void:
	_handle_spawn_event(SpawnEvent.COOLDOWN_FINISHED)

func _on_enemy_alerted() -> void:
	_handle_spawn_event(SpawnEvent.ENEMY_ALERTED)

#endregion
