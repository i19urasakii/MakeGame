extends Control

var dialogue_data: Dictionary = {}
var node_id: String = ""
var node_order: Array = []

@onready var speaker_label: Label = %SpeakerLabel
@onready var text_label: Label = %TextLabel
@onready var next_hint: Label = %NextHint

func _ready() -> void:
    visible = false

func show_dialogue(dialogue_id: String) -> void:
    var dialogue := Db.get_data(dialogue_id)
    if dialogue.is_empty():
        show_text("システム", "会話データが見つかりません。")
        return

    dialogue_data = dialogue
    node_id = String(dialogue.get("start", ""))
    node_order.clear()
    visible = true
    _render_current_node()

func show_text(speaker: String, text: String) -> void:
    dialogue_data = {}
    node_id = ""
    visible = true
    speaker_label.text = speaker
    text_label.text = text
    next_hint.text = "▼"

func _render_current_node() -> void:
    if dialogue_data.is_empty() or not dialogue_data.has("nodes"):
        visible = false
        return

    var nodes: Dictionary = dialogue_data.get("nodes", {})
    if not nodes.has(node_id):
        visible = false
        return

    var current: Dictionary = nodes.get(node_id, {})
    speaker_label.text = String(current.get("speaker", "村人"))
    text_label.text = String(current.get("text", ""))
    next_hint.text = "▼"

func _input(event: InputEvent) -> void:
    if not visible:
        return
    if event.is_action_pressed("confirm"):
        _advance_dialogue()

func _advance_dialogue() -> void:
    if dialogue_data.is_empty() or not dialogue_data.has("nodes"):
        visible = false
        return

    var nodes: Dictionary = dialogue_data.get("nodes", {})
    if not nodes.has(node_id):
        visible = false
        return

    var current: Dictionary = nodes.get(node_id, {})
    var next_id = current.get("next")
    if next_id == null or String(next_id) == "":
        visible = false
        return

    node_id = String(next_id)
    _render_current_node()
