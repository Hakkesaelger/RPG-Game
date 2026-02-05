extends CharacterBody2D

var is_attacking: bool = false
const activates_text = true
@export var SPEED: int = 300
@export var JUMP_VELOCITY: int = -400

func _process(_delta: float) -> void:
	if is_attacking:
		$AnimatedSprite2D.play("attack")
		$SwordPivot/Sword.monitorable = true
		$SwordPivot/Sword.monitoring = true
	elif velocity == Vector2.ZERO:
		$AnimatedSprite2D.play("idle")
	elif velocity.y < 0:
		$AnimatedSprite2D.play("jump")
	elif  velocity.y > 0:
		$AnimatedSprite2D.play("fall")
	elif velocity.x != 0:
		$AnimatedSprite2D.play("walk")
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
		$SwordPivot.rotation = 0
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
		$SwordPivot.rotation = PI

func _physics_process(delta: float) -> void:
	if InputHandler.is_action_given("player","attack") and not is_attacking:
		is_attacking = true
		$AttackTimer.start()
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if InputHandler.is_action_given("player","jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction: int = 0
	if InputHandler.is_action_given("player","move_left"): direction = -1
	if InputHandler.is_action_given("player","move_right"): direction = 1
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_attack_timer_timeout() -> void:
	is_attacking = false
	$SwordPivot/Sword.monitoring = false
	$SwordPivot/Sword.monitorable = false
