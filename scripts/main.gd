extends Node2D

@export var enemy_scenes: Array[PackedScene]
@export var spawn_distance := 700.0
@export var min_spawn_time := 0.3

@onready var player: CharacterBody2D = $Player
@onready var spawn_timer: Timer = $SpawnTimer
@onready var ui = $UI

var elapsed := 0.0

func _ready() -> void:
	Game.reset()
	spawn_timer.timeout.connect(_spawn_enemy)
	player.died.connect(_on_player_died)
	player.health_changed.connect(ui.update_health)

func _process(delta: float) -> void:
	elapsed += delta

func _pick_enemy() -> PackedScene:
	var pool: Array[PackedScene] = [enemy_scenes[0]]
	if elapsed > 20.0 and enemy_scenes.size() > 1:
		pool.append(enemy_scenes[1])
	if elapsed > 45.0 and enemy_scenes.size() > 2:
		pool.append(enemy_scenes[2])
	return pool.pick_random()

func _spawn_enemy() -> void:
	if not is_instance_valid(player):
		return
	var angle := randf() * TAU
	var enemy := _pick_enemy().instantiate()
	enemy.position = player.global_position + Vector2.RIGHT.rotated(angle) * spawn_distance
	add_child(enemy)
	spawn_timer.wait_time = max(min_spawn_time, spawn_timer.wait_time * 0.98)

func _on_player_died() -> void:
	spawn_timer.stop()
	Game.save_data()
	var music := get_node_or_null("Music")
	if music:
		music.stop()
	ui.show_game_over()
