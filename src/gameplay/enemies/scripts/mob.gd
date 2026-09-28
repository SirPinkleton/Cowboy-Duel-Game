class_name GenericMob
extends EnemyCore

# mostly these guys are planted in a spot,
# to jump up and take pot shots/throw dynamite/etc.
# So, they need a place to stand, cover to take, ammo to track, aiming competency
# to factor in, weapon type, health, animations, sound fx.
# they maybe also need to aim just like the MC does, though by default they spend less time aiming

var _health = 1;

func _ready() -> void:
	pass # Replace with function body.

func _process(delta : float) -> void:
	if (_health <= 0):
		_killed()
	#stuff about timers for how often they spend hiding behind stuff
	#how long they spend aiming
	#if they should peek out and start aiming
	#if they' should fire

func _killed() -> void:
	queue_free_and_signal()
