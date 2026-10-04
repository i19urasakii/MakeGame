extends SceneTree

const BattleCalc = preload("res://scripts/logic/battle_calc.gd")
const ConditionEvaluator = preload("res://scripts/logic/condition_evaluator.gd")

func _initialize() -> void:
    var rng := RandomNumberGenerator.new()
    rng.seed = 42

    var battle := BattleCalc.new(rng)
    var damage := battle.calculate_physical_damage(12, 3, {"damage_variance": 0.1, "min_damage": 1})
    assert(damage >= 1, "Damage must be at least 1")

    var evaluator := ConditionEvaluator.new()
    var flags := {
        "met_chief": true,
        "defeated_demon_king": false,
        "gold": 125,
        "level": 3,
        "items": {"herb": 2}
    }
    var condition := {
        "all": [
            {"flag": "met_chief"},
            {"flag_not": "defeated_demon_king"},
            {"gold_gte": 100}
        ]
    }
    assert(evaluator.evaluate(condition, flags), "Condition check should pass")

    print("All tests passed.")
    quit()
