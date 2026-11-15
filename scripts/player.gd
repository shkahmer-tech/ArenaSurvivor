extends CharacterBody2D

signal health_changed(current: int, maximum: int)
signal died

@export var speed := 300.0
@export var max_health := 100
@export var fire_rate := 0.15
@export var bullet_scene: PackedScene
@export var shoot_sound: AudioStream
@export var hurt_sound: AudioStream

var health: int

@onready var muzzle: Marker2D = $Muzzle
@onready var shoot_timer: Timer = $ShootTimer

func _ready() -> void:
	health = max_health
	shoot_timer.wait_time = fire_rate
	add_to_group("player")

func _physics_process(_delta: float) -> void:
	var dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = dir * speed
	move_and_slide()
	look_at(get_global_mouse_position())

	if Input.is_action_pressed("shoot") and shoot_timer.is_stopped():
		shoot()

func shoot() -> void:
	shoot_timer.start()
	Game.play_sfx(shoot_sound, -10.0)
	var bullet := bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = muzzle.global_position
	bullet.rotation = rotation

func take_damage(amount: int) -> void:
	Game.play_sfx(hurt_sound)
	health = max(health - amount, 0)
	health_changed.emit(health, max_health)
	$Camera2D.shake(10.0)
	if health == 0:
		died.emit()
		queue_free()
