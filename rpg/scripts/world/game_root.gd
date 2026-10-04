extends Node2D

var grid_world: GridWorld
var player: CharacterBody2D
var npcs: Array = []
var dialogue_box: Control

func _ready() -> void:
    var map_data: Dictionary = Db.get_data("village")
    var blocked := PackedVector2Array()
    for entry in map_data.get("blocked", []):
        if entry is Dictionary:
            blocked.append(Vector2(float(entry.get("x", 0)), float(entry.get("y", 0))))

    grid_world = GridWorld.new(Vector2i(20, 15), blocked)
    _build_ground()
    _build_walls()
    _spawn_player()
    _spawn_npcs()
    _spawn_dialogue_box()

func _build_ground() -> void:
    var ground := ColorRect.new()
    ground.color = Color(0.22, 0.35, 0.25)
    ground.position = Vector2.ZERO
    ground.size = Vector2(grid_world.map_size.x * grid_world.tile_size, grid_world.map_size.y * grid_world.tile_size)
    add_child(ground)

func _build_walls() -> void:
    for cell in grid_world.blocked_cells:
        var wall := ColorRect.new()
        wall.color = Color(0.29, 0.22, 0.18)
        wall.position = grid_world.grid_to_world(cell)
        wall.size = Vector2(grid_world.tile_size, grid_world.tile_size)
        add_child(wall)

func _spawn_player() -> void:
    var player_scene := preload("res://rpg/scenes/player/player.tscn")
    player = player_scene.instantiate()
    player.set("grid_world", grid_world)
    var start: Dictionary = Db.get_data("village").get("player_start", {"x": 1, "y": 1})
    player.current_cell = Vector2i(int(start.get("x", 1)), int(start.get("y", 1)))
    player._apply_position()
    add_child(player)

func _spawn_npcs() -> void:
    var village_data: Dictionary = Db.get_data("village")
    for npc_data in village_data.get("npcs", []):
        if not (npc_data is Dictionary):
            continue
        var npc_scene := preload("res://rpg/scenes/npc/npc.tscn")
        var instance: Node2D = npc_scene.instantiate()
        instance.set("npc_id", String(npc_data.get("npc_id", "")))
        instance.set("display_name", String(npc_data.get("name", "村人")))
        instance.set("dialogue_id", String(npc_data.get("dialogue_id", "")))
        instance.position = grid_world.grid_to_world(Vector2i(int(npc_data.get("x", 0)), int(npc_data.get("y", 0))))
        add_child(instance)
        npcs.append(instance)

func _spawn_dialogue_box() -> void:
    var dialogue_scene := preload("res://rpg/scenes/ui/dialogue_box.tscn")
    dialogue_box = dialogue_scene.instantiate()
    add_child(dialogue_box)
    dialogue_box.visible = false

func try_interact(player_cell: Vector2i, facing: String) -> void:
    var target_cell := player_cell
    match facing:
        "up":
            target_cell += Vector2i(0, -1)
        "down":
            target_cell += Vector2i(0, 1)
        "left":
            target_cell += Vector2i(-1, 0)
        "right":
            target_cell += Vector2i(1, 0)

    for npc in npcs:
        var cell := grid_world.world_to_grid(npc.position)
        if cell == target_cell:
            var npc_id: String = String(npc.get("npc_id", ""))
            var dialogue_id: String = String(npc.get("dialogue_id", ""))
            if dialogue_id != "":
                dialogue_box.show_dialogue(dialogue_id)
            else:
                dialogue_box.show_text("%s" % npc.get("display_name", "村人"), "今日は何もないようだ。")
            return

    dialogue_box.show_text("", "何もないようだ。")
