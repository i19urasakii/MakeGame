extends Control
class_name RPGTitleScreen

@onready var title_label: Label = %TitleLabel
@onready var subtitle_label: Label = %SubtitleLabel
@onready var start_button: Button = %StartButton

func _ready() -> void:
    var db_instance = get_node_or_null("/root/Db")
    var game_state_instance = get_node_or_null("/root/GameState")
    var flow_instance = get_node_or_null("/root/Flow")

    if db_instance != null and game_state_instance != null and flow_instance != null:
        var strings: Dictionary = db_instance.get_data("ui_strings")
        title_label.text = strings.get("title", "RPG")
        subtitle_label.text = strings.get("subtitle", "はじまりの村")
        start_button.text = strings.get("start_game", "はじめる")
        game_state_instance.reset_to_start()
        flow_instance.start_title()
        return

    title_label.text = "RPG"
    subtitle_label.text = "はじまりの村"
    start_button.text = "はじめる"

func _on_start_button_pressed() -> void:
    get_tree().change_scene_to_file("res://rpg/scenes/main.tscn")
