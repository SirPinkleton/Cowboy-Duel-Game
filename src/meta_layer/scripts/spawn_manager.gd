class_name SpawnManager
extends Node

#rnelson 9-25-2026 todo: get this to be defined (MainGame should interact with GameManager
#to give this a value?)
var _entity_layer : Node2D = null

func spawn_enemy(enemy_scene : PackedScene, global_transform : Transform2D) -> EnemyCore:
	if _entity_layer == null:
		return null
	
	var enemy : EnemyCore = enemy_scene.instantiate() as EnemyCore
	if !is_instance_valid(enemy):
		return null
	
	_entity_layer.add_child(enemy)
	enemy.global_transform = global_transform
	
	return enemy
