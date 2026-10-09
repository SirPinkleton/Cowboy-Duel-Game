class_name Player
extends CharacterBody2D

# --- movement ---
# gravity/floatyness
var gravity : float = 1000.0
# movement speed
var move_speed:int = 400

# What is the player currently doing, used for momentum handling.
# 0 = standing still
# 1 = starting moving (building momentum)
# 2 = full sprint (momentum achieved)
# 3 = in air (momentum isn't a factor, rising/falling)
# 4 = turning (momentum is switching directions)
# 5 = debug (flying around, god mode)
var movement_status: int

# which way the player is facing, for determining sprites to use when turning.
# 0 = left
# 1 = turning right from left
# 2 = right
# 3 = turning left from right
# consider: more than physics, might need to change physics. Can store physics for
# left/right/turning and then change physics between them, like in example:
# edge_collision_shape.position.x = EDGE_DETECTOR_X_OFFSET_RIGHT if facing_right else EDGE_DETECTOR_X_OFFSET_LEFT
var direction_facing: int

# notes: get different weapons? different ammo counts? track ammo separately
# for each weapon... 
# enforce a max? debug infinite ammo?
var ammo: int

# determines if left clicking will fire a shot, interacts with aiming timer
var is_aiming: bool

# determines if left clicking will fire a shot
var is_reloading: bool

var is_falling : bool = false

# current player health
# tracked between fights (ie: not healed between boss fights)? changes over loop?
# how represented in the HUD? Or maybe something floating around the player, when 
# they're injured and then fades away (unless low)?
var health: int

func _physics_process(delta: float) -> void:
	# --- movement ---
	#rnelson 9-25-2026 todo: check for user input control (handle momentum, pairing this with movement_status)
	# also: research how people handle momentum movement (move_and_slide is sufficient??)
	#handle jumping, handle crouching
	var inputAxis = 0.0
	inputAxis = Input.get_axis("move_left", "move_right")
	velocity.x = inputAxis * move_speed
	
	is_falling = velocity.y > 0 and not is_on_floor()
	
	if Input.is_action_just_pressed("jump") and not is_falling:
		velocity.y -= 500
	
	# --- gravity ---
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move_and_slide()

func _ready():
	# in case this gets un-set, layer 2 is player (default layer is 1, world)
	# remember: it's a bitmask
	collision_layer = 2 # layer 2
	collision_mask = 13 # 1 and 3
	
func _process(delta: float):
	# have a raycaster to know the player is facing/near something, for interactables?
	#that would look at an interactables layer (only collision mask, not on a layer
	
	# check if way out of bounds?
	
	# --- gun/ammo ---
	# handle if ammo counter is 0
	if (0 == ammo):
		# consider: a cooldown counter between last shot and starting to reload?
		is_reloading = true
		is_aiming = false
		# start a reloading animation
		# start a reloading timer
		ammo = 6
	# elif reloading timer hasn't finished yet
	# 	nothing else to do but wait
	# if reloading timer has expired
	# 	is_reloading = false
	# 	stop reloading animation?
	
	if (false == is_reloading):
		# handle starting and stopping aiming
		if Input.is_action_just_pressed("aiming"):
			is_aiming = true
			$AimingTimer.start()
		elif Input.is_action_just_released("aiming"):
			is_aiming = false
			$AimingTimer.stop()
		
		# handle attacking, with aiming in context
		# in same context as the is_aiming logic, can fire immediately?
		if Input.is_action_just_pressed("fire") and is_aiming:
			# calculate how accurate the shot should be
			# spawn the projectile at the angle + innaccuracy
			# decrement ammo counter
			pass
		if Input.is_action_just_pressed("fire") and false == is_aiming:
			# punch?
			pass
	
	
