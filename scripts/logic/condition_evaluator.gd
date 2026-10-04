extends RefCounted
class_name ConditionEvaluator

func evaluate(condition: Dictionary, flags: Dictionary = {}) -> bool:
    if condition.is_empty():
        return true

    if condition.has("all"):
        for child in condition["all"]:
            if not evaluate(child, flags):
                return false
        return true

    if condition.has("any"):
        for child in condition["any"]:
            if evaluate(child, flags):
                return true
        return false

    if condition.has("not"):
        return not evaluate(condition["not"], flags)

    if condition.has("flag"):
        return bool(flags.get(condition["flag"], false))

    if condition.has("flag_not"):
        return not bool(flags.get(condition["flag_not"], false))

    if condition.has("gold_gte"):
        return int(flags.get("gold", 0)) >= int(condition["gold_gte"])

    if condition.has("level_gte"):
        return int(flags.get("level", 0)) >= int(condition["level_gte"])

    if condition.has("has_item"):
        return bool(flags.get("items", {}).get(condition["has_item"], 0) > 0)

    for key in condition.keys():
        if key == "all" or key == "any" or key == "not":
            continue
        if key == "flag" or key == "flag_not":
            continue
        if not bool(condition[key]):
            return false

    return true
