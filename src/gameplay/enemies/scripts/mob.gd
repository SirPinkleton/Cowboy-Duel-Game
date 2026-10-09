class_name GenericMob
extends EnemyCore

var is_falling : bool = false

var gravity : float = 1000.0

# mostly these guys are planted in a spot,
# to jump up and take pot shots/throw dynamite/etc.
# So, they need a place to stand, cover to take, ammo to track, aiming competency
# to factor in, weapon type, health, animations, sound fx.
# they maybe also need to aim just like the MC does, though by default they spend less time aiming

var _health = 1;

func _physics_process(delta: float) -> void:
	# --- movement ---
	#tbd: figure out how AI knows where to move to (favors cover, can take cover, can run from explosives, etc.)
	
	# --- gravity ---
	is_falling = velocity.y > 0 and not is_on_floor()
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# --- sliding ---
	move_and_slide()


func _ready() -> void:
	# in case this gets un-set, layer 2 is player (default layer is 1, world)
	# remember: it's a bitmask
	collision_layer = 4 # layer 3
	collision_mask = 3 # layers 1, 2
	pass

func _process(delta : float) -> void:
	if (_health <= 0):
		_killed()
	#stuff about timers for how often they spend hiding behind stuff
	#how long they spend aiming
	#if they should peek out and start aiming
	#if they' should fire

func _killed() -> void:
	queue_free_and_signal()
