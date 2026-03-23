extends CharacterBody3D
const SPEED = 3
const JUMP_HEIGHT = 5
const Min = deg_to_rad(-40)
const Max = deg_to_rad(10)

var offset_camera

func _ready() -> void:
	
	offset_camera = %camera.global_position - global_position

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_HEIGHT
	var direcao = Input.get_vector("Player_left","Player_right","Player_up","Player_down")
	
	if not is_on_floor():
		if $char/AnimationPlayer.has_animation("wheelchair-sit"):
			if $char/AnimationPlayer.current_animation != "jump":
				$char/AnimationPlayer.play("wheelchair-sit")
	elif direcao != Vector2.ZERO:
		if $char/AnimationPlayer.current_animation != "walk":
			$char/AnimationPlayer.play("walk")
	else:
		if $char/AnimationPlayer.current_animation != "idle":
			$char/AnimationPlayer.play("idle")
	
	velocity = Vector3(direcao.x * SPEED, velocity.y, direcao.y * SPEED).rotated(Vector3.UP, %camera.rotation.y)
	
	if direcao.length() > 0:
		
		var vetor_rotacionado = Vector2(direcao.y, direcao.x).rotated(%camera.rotation.y)
		
		rotation.y = vetor_rotacionado.angle()
	
	if Input.is_action_pressed("camera+"):
		%camera.rotation.y += 2 * delta
	if Input.is_action_pressed("camera-"):
		%camera.rotation.y -= 2 * delta
	
	if Input.is_action_pressed("cameraY-"):
		%camera.rotation.x += 2 * delta
	if Input.is_action_pressed("cameraY+"):
		%camera.rotation.x -= 2 * delta
	
	%camera.rotation.x = clamp(%camera.rotation.x, Min, Max)
	
	var offset_rotated = offset_camera
	offset_rotated = offset_rotated.rotated(Vector3.RIGHT, %camera.rotation.x)
	offset_rotated = offset_rotated.rotated(Vector3.UP, %camera.rotation.y)
	%camera.global_position = global_position + offset_rotated
	
	move_and_slide()
