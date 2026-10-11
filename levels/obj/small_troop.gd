extends CharacterBody2D

class_name Enemy

signal kill

const speed = 2500

@export var goal: Node = null
var dead:bool = false
var canGo:bool = false

var splash=load("res://levels/obj/splash.tscn")

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
	
	var inst = splash.instantiate()
	inst.position = $splash.global_position
	get_parent().add_child(inst)
		
	dead = true
	$dead.play()
	$kill_zone.queue_free()
	visible = false

func _on_kill_zone_body_entered(body: Node2D) -> void:
	if body.name == 'player_stif':
		emit_signal("kill")


func _on_timer_timeout() -> void:
	if $NavigationAgent2D.target_position != goal.global_position:
		$NavigationAgent2D.target_position = goal.global_position

	$Timer.start()


func _on_dead_finished() -> void:
	queue_free()
