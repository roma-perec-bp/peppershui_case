extends CharacterBody2D

class_name Big_Enemy
signal kill
const speed = 3500

var dead:bool = false
var health:int = 2

var splash=load("res://levels/obj/splash.tscn")

@export var goal: Node = null
var canGo:bool = false

func _ready() -> void:
	$NavigationAgent2D.target_position = goal.global_position
	
func _physics_process(delta: float) -> void:
	if canGo:
		var nav_point_direction = to_local($NavigationAgent2D.get_next_path_position()).normalized()
		velocity = nav_point_direction * speed * delta
		move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == 'player_stif' and canGo == false:
		if dead: return
		canGo = true
		$alarm.play()
		$Timer.start()
		$spr.play()
		

func death():
	if dead: return
	dead = true
	
	var inst = splash.instantiate()
	inst.position = $splash.global_position
	get_parent().add_child(inst)
	
	$dead.play()
	$kill_zone.queue_free()
	visible = false
	
func pain():
	if dead: return
	
	health -= 1
	
	if health == 0:
		death()
		return
		
	$pain.play()
	
	$spr.modulate = Color(0.6, 0.6, 0.6)
	await TimerRoot.delay(0.3)
	$spr.modulate = Color(1, 1, 1)

func _on_kill_zone_body_entered(body: Node2D) -> void:
	if body.name == 'player_stif':
		emit_signal("kill")


func _on_timer_timeout() -> void:
	if $NavigationAgent2D.target_position != goal.global_position:
		$NavigationAgent2D.target_position = goal.global_position

	$Timer.start()


func _on_dead_finished() -> void:
	queue_free()
