extends Node2D
class_name NPC

@export var npc_id: String = ""
@export var display_name: String = "村人"
@export var dialogue_id: String = ""
@export var facing: String = "down"

func _ready() -> void:
    var body := ColorRect.new()
    body.color = Color(0.95, 0.8, 0.55)
    body.position = Vector2(0, 0)
    body.size = Vector2(24, 24)
    add_child(body)
