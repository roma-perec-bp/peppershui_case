extends CharacterBody2D

const speed = 20000

@export var goal: Node = null
var canGo:bool = false

func _ready() -> void:
	$NavigationAgent2D.target_position = goal.global_position
	
func _physics_process(delta: float) -> void:
	if canGo:
		var nav_point_direction = to_local($NavigationAgent2D.get_next_path_position()).normalized()
		velocity = nav_point_direction * speed * delta
		$NavigationAgent2D.target_position = goal.global_position
		move_and_slide()

func _on_timer_timeout() -> void:
	if $NavigationAgent2D.target_position != goal.global_position:
		$NavigationAgent2D.target_position = goal.global_position

	$Timer.start()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == 'player_stif' and canGo == false:
		canGo = true
		$alarm.play()
		$spr.play()
