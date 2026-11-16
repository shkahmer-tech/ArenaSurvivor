extends CharacterBody2D

@export var speed := 120.0
@export var max_health := 30
@export var contact_damage := 10
@export var points := 10
@export var explosion_scene: PackedScene
@export var hit_sound: AudioStream
@export var death_sound: AudioStream

var health: int
var player: Node2D
var damage_cooldown := 0.0

func _ready() -> void:
	health = max_health
	add_to_group("enemies")
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if not is_instance_valid(player):
		return

	velocity = global_position.direction_to(player.global_position) * speed
	move_and_slide()
	look_at(player.global_position)

	damage_cooldown -= delta
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider()
		if collider and collider.is_in_group("player") and damage_cooldown <= 0.0:
			collider.take_damage(contact_damage)
			damage_cooldown = 0.8

func take_damage(amount: int) -> void:
	health -= amount
	modulate = Color(3, 3, 3)
	create_tween().tween_property(self, "modulate", Color.WHITE, 0.1)
	if health <= 0:
		die()
	else:
		Game.play_sfx(hit_sound, -8.0)

func die() -> void:
	Game.add_score(points)
	Game.play_sfx(death_sound)
	if explosion_scene:
		var fx := explosion_scene.instantiate()
		fx.position = global_position
		get_parent().add_child(fx)
	queue_free()
