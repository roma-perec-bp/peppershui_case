extends Node2D

var isDead:bool = false
var canPause:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$player_christmas.canMove = false
	$player_christmas.spr.play("default-front")
	$hud/Control/AnimationPlayer.play("new_animation")
	await TimerRoot.delay(5)
	canPause = true
	$trans.play()
	$hud/Control/Label.visible = false
	$hud/Control/name.visible = true
	$player_christmas.canMove = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape") and canPause:
		get_tree().paused = true
		TimerRoot.set_paused(true)
		$hud/pause.pause()
		$hud/pause.visible = true

func check_complete():
	if SaveFile.progress < 6:
		SaveFile.progress = 6
		SaveFile.save_data()
			
	$end.play()
	$hud/win.visible = true
	$hud/win/AnimationPlayer.play("end")
	
	await TimerRoot.delay(4)
	get_tree().change_scene_to_file("res://levels/inter_7.tscn")


func _on_run_body_entered(body: Node2D) -> void:
	if body.name == 'player_christmas':
		$run.queue_free()
		var pizdec = get_tree().create_tween()
		pizdec.tween_property($death, "position:y", 600, 1)

func _on_finish_body_entered(body: Node2D) -> void:
	if body.name == 'player_christmas':
		canPause = false
		$music.stop()
		$hud/death.visible = true
		if SaveFile.lights:
			$hud/death/AnimatedSprite2D.play("default")
		else:
			$hud/death/AnimatedSprite2D.play("safe")
		$ded.play()


func _on_animated_sprite_2d_animation_finished() -> void:
	$ded.stop()
	check_complete()
