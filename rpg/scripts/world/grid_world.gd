extends RefCounted
class_name GridWorld

const tile_size: int = 32
var map_size: Vector2i
var blocked_cells: Array[Vector2i] = []
var start_cell: Vector2i = Vector2i(1, 1)

func _init(size: Vector2i = Vector2i(20, 15), blocked: PackedVector2Array = PackedVector2Array()) -> void:
    map_size = size
    for item in blocked:
        blocked_cells.append(Vector2i(int(item.x), int(item.y)))

func is_in_bounds(cell: Vector2i) -> bool:
    return cell.x >= 0 and cell.y >= 0 and cell.x < map_size.x and cell.y < map_size.y

func is_walkable(cell: Vector2i) -> bool:
    if not is_in_bounds(cell):
        return false
    for blocked in blocked_cells:
        if blocked == cell:
            return false
    return true

func world_to_grid(world_pos: Vector2) -> Vector2i:
    return Vector2i(int(floor(world_pos.x / tile_size)), int(floor(world_pos.y / tile_size)))

func grid_to_world(cell: Vector2i) -> Vector2:
    return Vector2(cell.x * tile_size, cell.y * tile_size)

func try_move_from(origin: Vector2i, direction: Vector2i) -> Vector2i:
    var target := origin + direction
    if is_walkable(target):
        return target
    return origin
