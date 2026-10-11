extends Node2D

var isDead:bool = false
var canPause:bool = false
var phase:int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$player_agent.canMove = false
	$player_agent.spr.play("default-front")
	$hud/Control/AnimationPlayer.play("new_animation")
	await TimerRoot.delay(5)
	canPause = true
	$trans.play()
	$hud/Control/Label.visible = false
	$hud/Control/name.visible = true
	$player_agent.canMove = true
	$hud/Control/AnimationPlayer2.play("new_animation")
	
func _physics_process(delta: float) -> void:
	$hud/Control/warn.position.x = randf_range(33,39)
	$hud/Control/warn.position.y = randf_range(125,131)
	
	$hud/Control/patience.position.x = randf_range(445,455)
	$hud/Control/patience2.position.x = randf_range(445,455)
	$hud/Control/patience.position.y = randf_range(355,365)
	$hud/Control/patience2.position.y = randf_range(355,365)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match phase:
		1:
			$hud/Control/patience.text = "Patience\n"+str(int($Path2D/PathFollow2D/perec_dark.patience))
			$hud/Control/patience2.text = "Patience\n"+str(int($Path2D/PathFollow2D/perec_dark.patience))
		2:
			$hud/Control/patience.text = "Patience\n"+str(int($Path2D2/PathFollow2D/perec_dark.patience))
			$hud/Control/patience2.text = "Patience\n"+str(int($Path2D2/PathFollow2D/perec_dark.patience))
		3:
			$hud/Control/patience.text = "Patience\n"+str(int($Path2D3/PathFollow2D/perec_dark.patience))
			$hud/Control/patience2.text = "Patience\n"+str(int($Path2D3/PathFollow2D/perec_dark.patience))
	
	if Input.is_action_just_pressed("escape") and canPause:
		get_tree().paused = true
		TimerRoot.set_paused(true)
		$hud/pause.pause()
		$hud/pause.visible = true

func check_complete():
	if SaveFile.progress < 7:
		SaveFile.progress = 7
		SaveFile.save_data()
			
	$end.play()
	$hud/win.visible = true
	$hud/win/AnimationPlayer.play("end")
	
	await TimerRoot.delay(4)
	get_tree().change_scene_to_file("res://levels/inter_8.tscn")

func _on_perec_dark_death() -> void:
	if !isDead:
		$hud/Control/AnimationPlayer2.stop()
		$player_agent.canPlayFoot = false
		canPause = false
		isDead = true
		$player_agent.canMove = false
		$music.stop()
		$hud/death.visible = true
		$hud/death/dead.play("default")
		$hud/death/snd.play()
		await TimerRoot.delay(3)
		get_tree().reload_current_scene()


func _on_activate_body_entered(body: Node2D) -> void:
	if body.name == 'player_agent':
		$activate.queue_free()
		$hud/Control/Label2.visible = true
		$Path2D/PathFollow2D/perec_dark.visible = true
		$Path2D/PathFollow2D/perec_dark.not_active = false
		$hud/Control/AnimationPlayer2.stop()
		$hud/Control/AnimationPlayer2.play("new_animation")
		#$Path2D2/PathFollow2D/perec_dark.visible = true
		#$Path2D2/PathFollow2D/perec_dark.not_active = false
		#$Path2D3/PathFollow2D/perec_dark.visible = true
		#$Path2D3/PathFollow2D/perec_dark.not_active = false
		var pat = get_tree().create_tween()
		pat.tween_property($hud/Control/patience, "self_modulate:a", 1, 1)
		var pat2 = get_tree().create_tween()
		pat2.tween_property($hud/Control/patience2, "self_modulate:a", 1, 1)
		$impact.play()
		$music.stream = load("res://music/darkness danger.wav");
		$music.play()
		var warn = get_tree().create_tween()
		warn.tween_property($hud/Control/warn, "self_modulate:a", 1, 1)
		await TimerRoot.delay(5)
		$hud/Control/Label2.visible = false
		var warn2 = get_tree().create_tween()
		warn2.tween_property($hud/Control/warn, "self_modulate:a", 0, 3)


func _on_animation_player_2_animation_finished(anim_name: StringName) -> void:
	await TimerRoot.delay(randf_range(1, 3))
	if isDead: return
	$ColorRect2.visible = true
	$hud/Control/AnimationPlayer2.play("new_animation")
	$hud/Control/thund.play()
	
func _on_end_trigger_body_entered(body: Node2D) -> void:
	$end_trigger.queue_free()
	$hud/Control/AnimationPlayer2.stop()
	$player_agent.canPlayFoot = false
	canPause = false
	isDead = true
	$player_agent.canMove = false
	$music.stop()
	$hud/Control/end_graphic.visible = true
	await TimerRoot.delay(2)
	$hud/Control/cut.play("default")
	$stat.play()
	$hud/Control/cut.visible = true
	await TimerRoot.delay(2)
	$hud/Control/cut.play("legs")
	$hud/Control/cut.visible = true
	await TimerRoot.delay(2)
	$hud/Control/cut.play("default")
	$hud/Control/cut.visible = true
	await TimerRoot.delay(2)
	$hud/Control/cut.play("grab")
	$hud/Control/cut.visible = true
	$scream.play()
	await TimerRoot.delay(0.4)
	$scream.stop()
	$stat.stop()
	check_complete()


func _on_activate_2_body_entered(body: Node2D) -> void:
	if body.name == 'player_agent':
		phase = 2
		$activate2.queue_free()
		$Path2D/PathFollow2D/perec_dark.visible = false
		$Path2D/PathFollow2D/perec_dark.not_active = true
		$hud/Control/AnimationPlayer2.stop()
		$hud/Control/AnimationPlayer2.play("new_animation")
		$Path2D2/PathFollow2D/perec_dark.visible = true
		$Path2D2/PathFollow2D/perec_dark.not_active = false
		#$Path2D3/PathFollow2D/perec_dark.visible = true
		#$Path2D3/PathFollow2D/perec_dark.not_active = false
		$impact.play()


func _on_activate_3_body_entered(body: Node2D) -> void:
	if body.name == 'player_agent':
		phase = 3
		$activate3.queue_free()
		$hud/Control/AnimationPlayer2.stop()
		$hud/Control/AnimationPlayer2.play("new_animation")
		$Path2D2/PathFollow2D/perec_dark.visible = false
		$Path2D2/PathFollow2D/perec_dark.not_active = true
		$Path2D3/PathFollow2D/perec_dark.visible = true
		$Path2D3/PathFollow2D/perec_dark.not_active = false
		$impact.play()


func _on_stop_body_entered(body: Node2D) -> void:
	if body.name == 'player_agent':
		var pat = get_tree().create_tween()
		pat.tween_property($hud/Control/patience, "self_modulate:a", 0, 1)
		var pat2 = get_tree().create_tween()
		pat2.tween_property($hud/Control/patience2, "self_modulate:a", 0, 1)
		var bye = get_tree().create_tween()
		bye.tween_property($Path2D3/PathFollow2D/perec_dark, "self_modulate:a", 0, 1)
		$Path2D3/PathFollow2D/perec_dark.not_active = true
		var tween = get_tree().create_tween()
		tween.tween_property($music, "volume_db", -80.0, 3)
