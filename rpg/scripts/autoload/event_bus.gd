extends Node
class_name EventBus

signal map_changed(old_map, new_map)
signal flag_changed(key, value)
signal mode_changed(mode)
signal battle_ended(result)
signal level_up(old_level, new_level)

func emit_map_changed(old_map: String, new_map: String) -> void:
    emit_signal("map_changed", old_map, new_map)

func emit_flag_changed(key: String, value: Variant) -> void:
    emit_signal("flag_changed", key, value)
