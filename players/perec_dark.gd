extends CharacterBody2D

signal death

@onready var sprite:AnimatedSprite2D = $spr
@onready var path_follow: PathFollow2D = get_parent()

var ghost_item=load("res://players/perec_dark_trail.tscn")

@export var player: Node

var move_speed:float = 60
var loop :bool = true

var last_pos: Vector2

var heard:bool = false
var in_insta_zone:bool = false
var in_small_zone:bool = false
var patience:float = 400

var not_active:bool = true

var inKillZone:bool = false

func _ready() -> void:
	#position = path_follow.global_position
	last_pos = global_position
	
func _physics_process(delta: float) -> void:	
	if !not_active: 
		if heard == false:
			path_follow.set_progress(path_follow.get_progress() + move_speed * delta)
	#position = path_follow.global_position
	
	var move := position - last_pos
	if move.length() > 0.1:
		updateAnim(move)
		
	last_pos = global_position
	
	if inKillZone and heard:
		emit_signal("death")
	
	if heard:
		var direction = global_position.direction_to(player.global_position).normalized()
		velocity = direction * 300
	
	if in_insta_zone == true and not_active == false:
		if player.state == 'walk':
			heard = true
			
	if in_small_zone == true and not_active == false:
		if player.state == 'walk':
			patience -= 2
		else:
			if patience <= 399:
				patience += 1
	else:
		if patience <= 399:
			patience += 1
		
	if patience < 0:
		heard = true
		
	move_and_slide()

func updateAnim(move:Vector2) -> void:
	var anim_name := 'walk-'
	anim_name += (
		"right"
		if abs(move.x) > abs(move.y) and move.x > 0
		else "left" if abs(move.x) > abs(move.y) else "back" if move.y > 0 else "front" 
	)
	
	sprite.play(anim_name)

func add_trail():
	var ghost = ghost_item.instantiate()
	ghost.set_property(global_position)
	get_tree().current_scene.add_child(ghost)

func _on_timer_timeout() -> void:
	if !not_active: add_trail()


func _on_instant_death_body_entered(body: Node2D) -> void:
	if body.name == 'player_agent':
		in_insta_zone = true


func _on_instant_death_body_exited(body: Node2D) -> void:
	if body.name == 'player_agent':
		in_insta_zone = false


func _on_small_hear_body_entered(body: Node2D) -> void:
	if body.name == 'player_agent':
		in_small_zone = true


func _on_small_hear_body_exited(body: Node2D) -> void:
	if body.name == 'player_agent':
		in_small_zone = false


func _on_death_body_entered(body: Node2D) -> void:
	if body.name == 'player_agent':
		inKillZone = true


func _on_death_body_exited(body: Node2D) -> void:
	if body.name == 'player_agent':
		inKillZone = false
