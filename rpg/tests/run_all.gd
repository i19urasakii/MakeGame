extends SceneTree

func _initialize() -> void:
    _test_battle_calc()
    _test_condition_evaluator()
    print("All tests passed.")
    quit()

func _test_battle_calc() -> void:
    var battle_calc_script = load("res://rpg/scripts/logic/battle_calc.gd")
    var rng := RandomNumberGenerator.new()
    rng.seed = 42

    var battle: RefCounted = battle_calc_script.new(rng)
    var test_config := {"damage_variance": 0.1, "min_damage": 1}
    var damage: int = battle.calculate_physical_damage(12, 3, test_config)
    assert(damage >= 1, "Damage must be at least 1")
    print("BattleCalc test passed. Damage: %d" % damage)

func _test_condition_evaluator() -> void:
    var evaluator_script = load("res://rpg/scripts/logic/condition_evaluator.gd")
    var evaluator: RefCounted = evaluator_script.new()
    
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
    print("ConditionEvaluator test passed.")
