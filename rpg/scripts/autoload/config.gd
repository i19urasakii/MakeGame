extends Node
class_name Config

const CONFIG_DIR := "res://rpg/data/config"

var _config: Dictionary = {}

func _ready() -> void:
    reload()

func reload() -> void:
    _config.clear()
    var dir := DirAccess.open(CONFIG_DIR)
    if dir == null:
        push_warning("Config directory not found: %s" % CONFIG_DIR)
        return

    dir.list_dir_begin()
    var entry := dir.get_next()
    while entry != "":
        if not entry.begins_with(".") and entry.ends_with(".json"):
            var path := CONFIG_DIR.path_join(entry)
            var loaded := _load_json(path)
            if loaded is Dictionary:
                var key := entry.get_basename()
                _config[key] = loaded
        entry = dir.get_next()
    dir.list_dir_end()

func _load_json(path: String) -> Variant:
    var file := FileAccess.open(path, FileAccess.READ)
    if file == null:
        push_warning("Unable to read config file: %s" % path)
        return {}
    var text := file.get_as_text()
    var parsed = JSON.parse_string(text)
    if parsed == null:
        push_warning("Invalid JSON: %s" % path)
        return {}
    return parsed

func get_section(section_name: String) -> Dictionary:
    if _config.has(section_name):
        return _config[section_name]
    return {}

func get_value(section_name: String, key: String, default_value: Variant = null) -> Variant:
    var section: Dictionary = get_section(section_name)
    if section.has(key):
        return section[key]
    return default_value

func get_game() -> Dictionary:
    return get_section("game")

func get_battle() -> Dictionary:
    return get_section("battle")
