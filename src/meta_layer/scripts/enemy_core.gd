class_name EnemyCore
extends CharacterBody2D

signal enemy_queued_free()

#rnelson 9-25-2026: figure out when this is relevant (ending a level?)
func queue_free_and_signal() -> void:
	enemy_queued_free.emit()
	queue_free()
