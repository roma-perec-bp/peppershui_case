extends CharacterBody2D
var moveSpeed : int = 150
var direction: Vector2 = Vector2.ZERO
var car_direction: Vector2 = Vector2.DOWN

var canMove:bool = true
var canShoot:bool = true

const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

var state:String = "Idle"
@onready var spr = $spr
@onready var outline = $outline
@onready var hitbox = $col

var bullet=load("res://levels/obj/bullet.tscn")

var health:float = 100

func _damage():
	health -= 0.2

func _physics_process(delta):
	health = clamp(health, 0, 100)

	direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down"),
	).normalized()

	if canMove: velocity = direction * moveSpeed
	
	if canMove:
		if set_state() == true:
			update_anim()

	move_and_slide()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") and canMove and canShoot:
		fire_bullet()
			
func fire_bullet():
	$shoot.play()
	var bullet_scene = bullet.instantiate()
	get_parent().add_child(bullet_scene)
	bullet_scene.global_position = $shoot_area.global_position
	
func set_state() -> bool:
	var new_state: String = "default" if direction == Vector2.ZERO else "walk"
	
	if new_state == state:
		return false
	
	state = new_state
	return true
	
func update_anim() -> void:
	spr.play(state)
	outline.play(state)
