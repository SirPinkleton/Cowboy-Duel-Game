# Defines packed scene resource, preview texture, and spawn configuration for enemeies
class_name EnemyDefinition
extends Resource

@export var scene : PackedScene # scene containing the enemy to be spawned
@export var preview_texture : Texture2D # the texture displaying the enemy, for the editor view

@export_category("Spawn Behavior")
# base cooldown when using ON_TIMER_EXPIRE mode (used after enemy is removed from scene)
@export_range(0.0, 60.0, 0.1) var cooldown_time : float = 0.0
# adds a random value between 0.0 and this amount to the cooldown_time
@export_range(0.0, 60.0, 0.1) var randomize_cooldown_time : float = 0.0
# Whether this enemy will only spawn on the global alert being true
@export var spawnOnlyOnAlert : bool = false

#process: made an enemy resource, drag this script to its Script field,
#define details for that resource, to a scene's script that needs enemy info add:
#@export var enemy_definition : EnemyDefinition
#drag and drop the resource into that scene's Enemy Defintion field,
#make that script consume this data, ie: 
#var enemy_scene : PackedScene = enemy_definition.scene
