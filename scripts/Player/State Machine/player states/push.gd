extends Player_State

@export var raycast: RayCast3D
var direction: Vector3
var camera_pivot
var movable: Object

func _ready() -> void:
	call_deferred("_deferred_ready")
	
func _deferred_ready() -> void:
	camera_pivot = get_tree().get_current_scene().get_node("camera_pivot")

func enter():
	animation_player.play("push")

func exit():
	movable.pushing = false
	movable = null

func update(_delta: float):
	if movable:
		move()

func move():
	var input_dir := get_input()
	direction = (camera_pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		player.look_at(player.position + direction)
		player.velocity.x = direction.x * SPEED/2
		player.velocity.z = direction.z * SPEED/2
		
		movable.velocity.x = direction.x * SPEED/2
		movable.velocity.z = direction.z * SPEED/2
		movable.pushing = true

func enter_condition() -> bool: 
	if raycast.is_colliding():
		movable = raycast.get_collider()
	if not movable: return false
	return player.is_on_floor() and Input.is_action_pressed("push")
	
func exit_condition() -> bool:
	if not player.is_on_floor() or not raycast.is_colliding(): return true
	if not Input.is_action_pressed("push"): return true
	return false

func get_input() -> Vector2:
	if character == "White":
		return Input.get_vector("left", "right", "forward", "backward")
	# Black
	return Input.get_vector("left2", "right2", "forward2", "backward2")
