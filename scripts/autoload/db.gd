extends Node
class_name Db

var _db: Dictionary = {}

func _ready() -> void:
    reload_all()

func reload_all() -> void:
    _db.clear()
    _scan_directory("res://data")

func _scan_directory(path: String) -> void:
    var dir := DirAccess.open(path)
    if dir == null:
        push_warning("Unable to open data directory: %s" % path)
        return

    dir.list_dir_begin()
    var entry := dir.get_next()
    while entry != "":
        if entry == "." or entry == "..":
            entry = dir.get_next()
            continue

        var full_path := path.path_join(entry)
        if dir.current_is_dir():
            _scan_directory(full_path)
        elif entry.ends_with(".json"):
            var parsed := _parse_json(full_path)
            if parsed is Dictionary:
                var id_value := parsed.get("id", entry.get_basename())
                _db[id_value] = parsed
        entry = dir.get_next()
    dir.list_dir_end()

func _parse_json(path: String) -> Variant:
    var file := FileAccess.open(path, FileAccess.READ)
    if file == null:
        push_warning("Unable to read data file: %s" % path)
        return {}

    var text := file.get_as_text()
    var parsed = JSON.parse_string(text)
    if parsed == null:
        push_warning("Invalid JSON file: %s" % path)
        return {}
    return parsed

func has_data(id_value: String) -> bool:
    return _db.has(id_value)

func get_data(id_value: String) -> Dictionary:
    if _db.has(id_value):
        return _db[id_value]
    push_warning("Missing data id: %s" % id_value)
    return {}

func get_by_path(path: String) -> Dictionary:
    var file_name := path.get_file().get_basename()
    return get_data(file_name)
