extends Node2D

var grid_world: GridWorld
var player: CharacterBody2D

func _ready() -> void:
    var blocked := PackedVector2Array()
    blocked.append_array([
        Vector2(7, 4), Vector2(8, 4), Vector2(9, 4),
        Vector2(7, 5), Vector2(9, 5),
        Vector2(7, 6), Vector2(8, 6), Vector2(9, 6)
    ])

    grid_world = GridWorld.new(Vector2i(20, 15), blocked)
    _build_ground()
    _build_walls()
    _spawn_player()

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
    player.position = grid_world.grid_to_world(grid_world.start_cell)
    add_child(player)
