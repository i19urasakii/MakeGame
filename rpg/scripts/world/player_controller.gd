extends CharacterBody2D

var grid_world: GridWorld
var current_cell: Vector2i = Vector2i(1, 1)
var start_position: Vector2 = Vector2.ZERO
var target_position: Vector2 = Vector2.ZERO
var move_duration: float = 0.15
var move_timer: float = 0.0
var facing: String = "down"

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
    if grid_world == null:
        grid_world = GridWorld.new(Vector2i(20, 15), PackedVector2Array())
    _apply_position()
    _update_sprite_color()

func set_grid_world(world: GridWorld) -> void:
    grid_world = world
    current_cell = world.start_cell
    _apply_position()

func _apply_position() -> void:
    position = grid_world.grid_to_world(current_cell)
    start_position = position
    target_position = position

func _physics_process(delta: float) -> void:
    if move_timer > 0.0:
        move_timer = max(0.0, move_timer - delta)
        var t := 1.0 - (move_timer / move_duration)
        position = start_position.lerp(target_position, t)
        if move_timer <= 0.0:
            position = target_position
            current_cell = grid_world.world_to_grid(position)
        return

    var move_dir := _read_move_direction()
    if move_dir == Vector2i.ZERO:
        if Input.is_action_just_pressed("confirm"):
            var scene := get_tree().current_scene
            if scene != null and scene.has_method("try_interact"):
                scene.try_interact(current_cell, facing)
        return

    var next_cell := grid_world.try_move_from(current_cell, move_dir)
    if next_cell == current_cell:
        _set_facing(move_dir)
        return

    current_cell = next_cell
    start_position = position
    target_position = grid_world.grid_to_world(current_cell)
    move_timer = move_duration
    _set_facing(move_dir)

func _read_move_direction() -> Vector2i:
    var dir := Vector2i.ZERO

    if Input.is_action_just_pressed("move_up"):
        dir.y = -1
    elif Input.is_action_just_pressed("move_down"):
        dir.y = 1
    elif Input.is_action_just_pressed("move_left"):
        dir.x = -1
    elif Input.is_action_just_pressed("move_right"):
        dir.x = 1

    return dir

func _set_facing(direction: Vector2i) -> void:
    if direction.x > 0:
        facing = "right"
    elif direction.x < 0:
        facing = "left"
    elif direction.y > 0:
        facing = "down"
    elif direction.y < 0:
        facing = "up"
    _update_sprite_color()

func _update_sprite_color() -> void:
    match facing:
        "up":
            sprite.modulate = Color(0.95, 0.75, 0.55)
        "down":
            sprite.modulate = Color(0.75, 0.95, 0.65)
        "left":
            sprite.modulate = Color(0.65, 0.8, 1.0)
        "right":
            sprite.modulate = Color(1.0, 0.85, 0.75)
