extends Control
class_name TitleScreen

@onready var title_label: Label = %TitleLabel
@onready var subtitle_label: Label = %SubtitleLabel
@onready var start_button: Button = %StartButton

func _ready() -> void:
    var strings: Dictionary = Db.get_data("ui_strings")
    title_label.text = strings.get("title", "RPG")
    subtitle_label.text = strings.get("subtitle", "はじまりの村")
    start_button.text = strings.get("start_game", "はじめる")
    GameState.reset_to_start()
    Flow.start_title()

func _on_start_button_pressed() -> void:
    Flow.start_explore()
    print("Explore mode started.")
