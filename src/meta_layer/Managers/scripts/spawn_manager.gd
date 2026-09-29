class_name SpawnManager
extends Node

#rnelson 9-25-2026 todo: get this to be defined (MainGame should interact with GameManager
#to give this a value?)
var _entity_layer : Node2D = null

func spawn_enemy(enemy_scene : PackedScene, global_transform : Transform2D) -> EnemyCore:
	if _entity_layer == null:
		push_warning("no entity layer, cannot spawn enemy")
		return null
	
	var enemy : EnemyCore = enemy_scene.instantiate() as EnemyCore
	if true != is_instance_valid(enemy):
		push_warning("enemy failed to instantiate, cannot spawn")
		return null
	
	_entity_layer.add_child(enemy)
	enemy.global_transform = global_transform
	
	return enemy

func set_entity_layer(layerToSet : Node2D) -> void:
	_entity_layer = layerToSet
