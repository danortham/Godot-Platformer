extends CharacterBody2D


const SPEED = 100.0
const ACCELORATION = 700
const FRICTION = 1000
const JUMP_VELOCITY = -250.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var coyote_jump_timer = $CoyoteJumpTimer

func _physics_process(delta):
	var input_axis = Input.get_axis("ui_left", "ui_right")
	apply_gravity(delta)
	handle_jump()
	handle_acceloration(input_axis, delta)
	apply_friction(input_axis, delta)
	update_animations(input_axis)
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		coyote_jump_timer.start()
	
func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
func handle_jump():
	if is_on_floor() or coyote_jump_timer.time_left > 0.0:
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = JUMP_VELOCITY
	if not is_on_floor():
		if Input.is_action_just_released("ui_accept") and velocity.y < JUMP_VELOCITY / 2:
			velocity.y = JUMP_VELOCITY / 2

func apply_friction(input_axis, delta):
	if input_axis == 0:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

func handle_acceloration(input_axis, delta):
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, SPEED  * input_axis, ACCELORATION * delta)

func update_animations(input_axis):
	if input_axis != 0:
		animated_sprite_2d.flip_h = (input_axis < 0)
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("Idle")
		
	if not is_on_floor():
		animated_sprite_2d.play("jump")
