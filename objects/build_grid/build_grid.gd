extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func world_to_tile(worldPos: Vector2) -> Vector2i:
	pass

func set_tile(pos: Vector2i, tile: Node2D):
	pass
