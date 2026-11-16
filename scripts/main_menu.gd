extends Control

@onready var best_label: Label = $CenterContainer/VBoxContainer/BestLabel
@onready var play_button: Button = $CenterContainer/VBoxContainer/PlayButton
@onready var quit_button: Button = $CenterContainer/VBoxContainer/QuitButton

func _ready() -> void:
	best_label.text = "Best: %d" % Game.high_score
	play_button.pressed.connect(_on_play)
	quit_button.pressed.connect(func(): get_tree().quit())

func _on_play() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
