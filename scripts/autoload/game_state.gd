extends Node
class_name GameState

signal state_changed

var player_name: String = "ゆうしゃ"
var current_map: String = "village"
var current_position: Vector2i = Vector2i(14, 18)
var facing: String = "down"
var gold: int = 50
var level: int = 1
var exp: int = 0
var max_hp: int = 30
var hp: int = 30
var max_mp: int = 5
var mp: int = 5
var weapon_id: String = "wood_stick"
var armor_id: String = "cloth_clothes"
var items: Dictionary = {"herb": 2}
var owned_weapons: Array = ["wood_stick"]
var owned_armors: Array = ["cloth_clothes"]
var flags: Dictionary = {}
var opened_chests: Array = []
var playtime_sec: int = 0

func reset_to_start() -> void:
    var hero_data: Dictionary = Db.get_data("hero")
    var start_data: Dictionary = hero_data.get("start", {})
    var config: Dictionary = Config.get_game()

    current_map = start_data.get("map", config.get("start_map", "village"))
    gold = int(start_data.get("gold", config.get("start_gold", 50)))
    weapon_id = String(start_data.get("weapon", "wood_stick"))
    armor_id = String(start_data.get("armor", "cloth_clothes"))
    items = {}
    for entry in start_data.get("items", []):
        if entry is Dictionary:
            var item_id := String(entry.get("id", ""))
            var amount := int(entry.get("amount", 0))
            if item_id != "" and amount > 0:
                items[item_id] = amount
    owned_weapons = [weapon_id]
    owned_armors = [armor_id]
    flags.clear()
    opened_chests.clear()

    var position_data: Dictionary = config.get("start_position", {"x": 14, "y": 18})
    current_position = Vector2i(int(position_data.get("x", 14)), int(position_data.get("y", 18)))
    facing = String(config.get("start_facing", "down"))
    level = 1
    exp = 0
    max_hp = 30
    hp = 30
    max_mp = 5
    mp = 5
    emit_signal("state_changed")

func set_flag(key: String, value: Variant) -> void:
    flags[key] = value
    EventBus.flag_changed.emit(key, value)
    emit_signal("state_changed")

func get_flag(key: String, default_value: Variant = null) -> Variant:
    return flags.get(key, default_value)
