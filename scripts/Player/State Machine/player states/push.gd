extends Player_State

@export var raycast: RayCast3D
@export var speed_cut := 2.5
var direction: Vector3
var camera_pivot
var movable: Object

func _ready() -> void:
	call_deferred("_deferred_ready")
	
func _deferred_ready() -> void:
	camera_pivot = get_tree().get_current_scene().get_node("camera_pivot")

func enter():
	animation_player.speed_scale = 1.5
	animation_player.play("push")

func exit():
	animation_player.speed_scale = 1
	movable.pushing = false
	movable = null

func update(_delta: float):
	if movable:
		move()

func move():
	#input
	var input_dir := get_input()
	if abs(input_dir.x) > abs(input_dir.y): input_dir.y = 0
	else: input_dir.x = 0

	direction = (camera_pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		# Verifica se o jogador está a ir para trás em relação ao movable
		var player_to_movable = (movable.global_transform.origin - player.global_transform.origin).normalized()
		var dot_product = player_to_movable.dot(direction)

		if not dot_product < -0.5: # O jogador nao está a mover-se para trás em relação ao movable
			player.look_at(player.position + direction)
			animation_player.play("push")
		else:
			animation_player.play_backwards("push")
			
			
		player.velocity.x = direction.x * SPEED/speed_cut
		player.velocity.z = direction.z * SPEED/speed_cut
		
		movable.velocity.x = direction.x * SPEED/speed_cut
		movable.velocity.z = direction.z * SPEED/speed_cut
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
