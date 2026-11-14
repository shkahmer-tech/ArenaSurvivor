extends CanvasLayer

@onready var score_label: Label = $ScoreLabel
@onready var health_bar: ProgressBar = $HealthBar
@onready var game_over_panel: Panel = $GameOverPanel
@onready var final_score: Label = $GameOverPanel/VBoxContainer/FinalScore
@onready var restart_button: Button = $GameOverPanel/VBoxContainer/RestartButton

func _ready() -> void:
	game_over_panel.hide()
	Game.score_changed.connect(_on_score_changed)
	restart_button.pressed.connect(func(): get_tree().reload_current_scene())
	_on_score_changed(Game.score)

func _on_score_changed(score: int) -> void:
	score_label.text = "Score: %d" % score

func update_health(current: int, maximum: int) -> void:
	health_bar.max_value = maximum
	health_bar.value = current

func show_game_over() -> void:
	final_score.text = "Score: %d   Best: %d" % [Game.score, Game.high_score]
	game_over_panel.show()
