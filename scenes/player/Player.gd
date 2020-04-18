extends KinematicBody2D

signal shoot
signal damaged

export var ACCELERATION := 1000
export var CROUCH_SPEED := 50
export var NORMAL_SPEED := 400
export var SPRINT_SPEED := 800
export var FRICTION := 300
export var ROTATION_SPEED := 10

export var HEALTH := 100
# export var bullet_scene: PackedScene

var bullet_speed = 400
var velocity := Vector2.ZERO

slave var slave_position := Vector2()
slave var slave_rotation := 0

func _physics_process(delta: float) -> void:
	if is_network_master():
		move(delta)
		rotate(delta)
		shoot(delta)
		rset_unreliable("slave_position", position)
		rset_unreliable("slave_rotation", rotation)
	else:
		position = slave_position
		rotation = slave_rotation

func move(delta: float) -> void:
	# movement
	var input_vector := Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	var curr_speed := NORMAL_SPEED
	if Input.get_action_strength("crouch"):
		curr_speed = CROUCH_SPEED
	elif Input.get_action_strength("sprint"):
		curr_speed = SPRINT_SPEED
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * curr_speed, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = move_and_slide(velocity)

func rotate(delta: float) -> void:
	# direction
	var mpos := Vector2.ZERO
	if Global.joystickConnected:
		mpos = Vector2(Input.get_joy_axis(0, JOY_AXIS_2), Input.get_joy_axis(0, JOY_AXIS_3))
	else:
		mpos = get_local_mouse_position()
	rotation += mpos.angle() * ROTATION_SPEED * delta

func shoot(_delta: float) -> void:
	# shoot
	if Input.is_action_just_pressed("shoot"):
#		var bullet = bullet_scene.instance()
#		bullet.set_global_position($GunNozzle.get_global_position())
#		get_parent().add_child(bullet)
#		bullet.set_linear_velocity(Vector2(sin(rotation) * bullet_speed, cos(rotation) * bullet_speed))
		emit_signal("shoot")

