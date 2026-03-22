extends CharacterBody3D
const SPEED = 3
const JUMP_HEIGHT = 5
var offset_camera

func _ready() -> void:
	offset_camera = %camera.global_position - global_position

func _process(delta: float) -> void:
	velocity += get_gravity() * delta
	if Input.is_action_just_pressed("Player_jump") and is_on_floor():
		velocity.y = JUMP_HEIGHT

	var direcao = Input.get_vector("Player_left","Player_right","Player_up","Player_down")

	if direcao != Vector2.ZERO:
		if $char/AnimationPlayer.current_animation != "walk":
			$char/AnimationPlayer.play("walk")
	else:
		if $char/AnimationPlayer.current_animation != "idle":
			$char/AnimationPlayer.play("idle")
	velocity = Vector3(direcao.x * SPEED, velocity.y, direcao.y * SPEED).rotated(Vector3.UP, %camera.rotation.y)
	
	if direcao.length() > 0:
		var vetor_rotacionado = Vector2(direcao.y, direcao.x).rotated(%camera.rotation.y)
		rotation.y = vetor_rotacionado.angle()
	%camera.rotation.y += Input.get_axis("camera-","camera+") * 2 * delta
	%camera.rotation.x += Input.get_axis("cameraY-","cameraY+") * 2 * delta
	%camera.global_position = global_position + offset_camera.rotated(Vector3.UP, %camera.rotation.y)
	move_and_slide()
