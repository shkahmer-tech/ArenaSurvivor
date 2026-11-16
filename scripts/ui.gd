extends CanvasLayer

@onready var score_label: Label = $ScoreLabel
@onready var health_bar: ProgressBar = $HealthBar
@onready var game_over_panel: Panel = $GameOverPanel
@onready var final_score: Label = $GameOverPanel/VBoxContainer/FinalScore
@onready var restart_button: Button = $GameOverPanel/VBoxContainer/RestartButton
@onready var pause_panel: Panel = $PausePanel
@onready var resume_button: Button = $PausePanel/VBoxContainer/ResumeButton
@onready var menu_button: Button = $PausePanel/VBoxContainer/MenuButton

var is_game_over := false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	game_over_panel.hide()
	pause_panel.hide()
	Game.score_changed.connect(_on_score_changed)
	restart_button.pressed.connect(_on_restart)
	resume_button.pressed.connect(toggle_pause)
	menu_button.pressed.connect(_on_menu)
	_on_score_changed(Game.score)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and not is_game_over:
		toggle_pause()

func toggle_pause() -> void:
	var paused := not get_tree().paused
	get_tree().paused = paused
	pause_panel.visible = paused

func _on_restart() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_score_changed(score: int) -> void:
	score_label.text = "Score: %d" % score

func update_health(current: int, maximum: int) -> void:
	health_bar.max_value = maximum
	health_bar.value = current

func show_game_over() -> void:
	is_game_over = true
	final_score.text = "Score: %d   Best: %d" % [Game.score, Game.high_score]
	game_over_panel.show()
