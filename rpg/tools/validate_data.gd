extends SceneTree

var file_count := 0
var errors: Array[String] = []

func _initialize() -> void:
    _scan_directory("res://rpg/data")
    if errors.is_empty():
        print("Data validation passed: %d files checked." % file_count)
        quit()
    else:
        for error_text in errors:
            print("ERROR: %s" % error_text)
        quit(1)

func _scan_directory(path: String) -> void:
    var dir := DirAccess.open(path)
    if dir == null:
        errors.append("Directory not found: %s" % path)
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
        else:
            if entry.ends_with(".json"):
                file_count += 1
                _validate_json(full_path)
        entry = dir.get_next()
    dir.list_dir_end()

func _validate_json(path: String) -> void:
    var text := FileAccess.get_file_as_string(path)
    if text == "":
        errors.append("Empty JSON file: %s" % path)
        return

    var parsed = JSON.parse_string(text)
    if parsed == null:
        errors.append("Invalid JSON: %s" % path)
        return

    if not parsed is Dictionary:
        errors.append("Top-level JSON must be object: %s" % path)
        return

    var dict: Dictionary = parsed
    if not dict.has("id"):
        errors.append("Missing id in %s" % path)
    else:
        var id_value: String = String(dict["id"])
        if id_value.strip_edges() == "":
            errors.append("Blank id in %s" % path)

    if path.contains("/config/") and path.ends_with("game.json"):
        if not dict.has("start_map"):
            errors.append("Missing start_map in %s" % path)

    if path.contains("/characters/") and path.ends_with("hero.json"):
        if not dict.has("start"):
            errors.append("Missing hero start data in %s" % path)
