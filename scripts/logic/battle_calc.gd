extends RefCounted
class_name BattleCalc

var rng: RandomNumberGenerator

func _init(random_rng: RandomNumberGenerator = null) -> void:
    if random_rng == null:
        rng = RandomNumberGenerator.new()
    else:
        rng = random_rng

func calculate_physical_damage(attacker_atk: int, defender_def: int, config: Dictionary = {}) -> int:
    var battle_cfg: Dictionary = config if not config.is_empty() else Config.get_battle()
    var variance: float = float(battle_cfg.get("damage_variance", 0.1))
    var min_damage: int = int(battle_cfg.get("min_damage", 1))
    var raw_variance := 1.0 + rng.randf_range(-variance, variance)
    var base_damage := max(attacker_atk - defender_def, 0)
    var damage := int(floor(float(base_damage) * raw_variance))
    return max(damage, min_damage)

func calculate_crit_damage(attacker_atk: int, config: Dictionary = {}) -> int:
    var battle_cfg: Dictionary = config if not config.is_empty() else Config.get_battle()
    var variance: float = float(battle_cfg.get("damage_variance", 0.1))
    var raw_variance := 1.0 + rng.randf_range(-variance, variance)
    return int(floor(float(attacker_atk) * raw_variance))

func can_crit(config: Dictionary = {}) -> bool:
    var battle_cfg: Dictionary = config if not config.is_empty() else Config.get_battle()
    var crit_rate: float = float(battle_cfg.get("crit_rate", 0.03))
    return rng.randf() < crit_rate

func can_miss(config: Dictionary = {}) -> bool:
    var battle_cfg: Dictionary = config if not config.is_empty() else Config.get_battle()
    var miss_rate: float = float(battle_cfg.get("miss_rate", 0.03))
    return rng.randf() < miss_rate
