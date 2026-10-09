class_name SpawnManager
extends Node

var _entity_layer : Node2D = null

func spawn_enemy(enemy_scene : PackedScene, global_transform : Transform2D) -> EnemyCore:
	if _entity_layer == null:
		push_warning("no entity layer, cannot spawn enemy")
		return null
	
	var enemy : EnemyCore = enemy_scene.instantiate() as EnemyCore
	if true != is_instance_valid(enemy):
		push_warning("enemy failed to instantiate, cannot spawn")
		return null
	
	# record name so it's easier to differentiate live
	var randomint = randi()
	enemy.name = enemy_scene.resource_path + str(randomint)
	
	_entity_layer.add_child(enemy)
	enemy.global_transform = global_transform
	
	return enemy

func set_entity_layer(layerToSet : Node2D) -> void:
	_entity_layer = layerToSet
