extends Node

signal score_changed(score: int)

const SAVE_PATH := "user://save.json"

var score := 0
var high_score := 0

func _ready() -> void:
	load_data()

func reset() -> void:
	score = 0
	score_changed.emit(score)

func add_score(amount: int) -> void:
	score += amount
	score_changed.emit(score)

func save_data() -> void:
	if score > high_score:
		high_score = score
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify({"high_score": high_score}))

func load_data() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	if data is Dictionary:
		high_score = int(data.get("high_score", 0))
