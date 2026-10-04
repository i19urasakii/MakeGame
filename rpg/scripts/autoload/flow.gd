extends Node
class_name Flow

enum GameMode {
    TITLE,
    EXPLORE,
    DIALOGUE,
    MENU,
    SHOP,
    BATTLE,
    CUTSCENE,
    GAME_OVER,
    ENDING
}

var current_mode: GameMode = GameMode.TITLE

func set_mode(mode: GameMode) -> void:
    current_mode = mode
    EventBus.mode_changed.emit(mode)

func start_title() -> void:
    set_mode(GameMode.TITLE)

func start_explore() -> void:
    set_mode(GameMode.EXPLORE)

func start_dialogue() -> void:
    set_mode(GameMode.DIALOGUE)

func start_menu() -> void:
    set_mode(GameMode.MENU)
