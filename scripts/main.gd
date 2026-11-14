extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_distance := 700.0
@export var min_spawn_time := 0.3

@onready var player: CharacterBody2D = $Player
@onready var spawn_timer: Timer = $SpawnTimer
@onready var ui = $UI

func _ready() -> void:
	Game.reset()
	spawn_timer.timeout.connect(_spawn_enemy)
	player.died.connect(_on_player_died)
	player.health_changed.connect(ui.update_health)

func _spawn_enemy() -> void:
	if not is_instance_valid(player):
		return
	var angle := randf() * TAU
	var enemy := enemy_scene.instantiate()
	enemy.position = player.global_position + Vector2.RIGHT.rotated(angle) * spawn_distance
	add_child(enemy)
	spawn_timer.wait_time = max(min_spawn_time, spawn_timer.wait_time * 0.98)

func _on_player_died() -> void:
	spawn_timer.stop()
	Game.save_data()
	ui.show_game_over()
