extends Node2D

var isDead:bool = false
var canPause:bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$player_perec.canMove = false
	$player_perec.spr.play("default-front")
	$hud/Control/AnimationPlayer.play("new_animation")
	await get_tree().create_timer(5).timeout
	canPause = true
	$trans.play()
	$hud/Control/Label.visible = false
	$hud/Control/name.visible = true
	$player_perec.canMove = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape") and canPause:
		get_tree().paused = true
		TimerRoot.set_paused(true)
		$hud/pause.pause()
		$hud/pause.visible = true

func check_complete():
	if SaveFile.progress < 2:
		SaveFile.progress = 2
		SaveFile.save_data()
			
	$end.play()
	$hud/win.visible = true
	$hud/win/AnimationPlayer.play("end")
	
	await TimerRoot.delay(4)
	get_tree().change_scene_to_file("res://levels/inter_3.tscn")


func _on_dead_trigger_body_entered(body: Node2D) -> void:
	if body.name == 'player_perec' and !isDead:
		isDead = true
		canPause = false
		$player_perec.canMove = false
		$music.stop()
		$hud/death.visible = true
		$hud/death/dead.play("default")
		$hud/death/snd.play()
		await TimerRoot.delay(3)
		get_tree().reload_current_scene()
		


func _on_mus_off_body_entered(body: Node2D) -> void:
	if body.name == 'player_perec' and !isDead:
		var tween = get_tree().create_tween()
		tween.tween_property($music, "volume_db", -80.0, 6)
		$mus_off.queue_free()


func _on_end_triggger_body_entered(body: Node2D) -> void:
	if body.name == 'player_perec' and !isDead:
		canPause = false
		$end_triggger.queue_free()
		$player_perec.canMove = false
		$player_perec.hitbox.set_deferred("disabled", true)
		$player_perec.velocity.x = 0
		$player_perec.velocity.y = 0
		$player_perec/Camera2D.drag_horizontal_enabled = true
		$player_perec.spr.play("default-back")
		$fade.play()
		var tweencamZoom = get_tree().create_tween()
		tweencamZoom.set_ease(Tween.EASE_IN_OUT)
		tweencamZoom.set_trans(Tween.TRANS_QUAD)
		tweencamZoom.tween_property($player_perec/Camera2D, "zoom:x", 1.3, 4)
		var tweencamZoom2 = get_tree().create_tween()
		tweencamZoom2.set_ease(Tween.EASE_IN_OUT)
		tweencamZoom2.set_trans(Tween.TRANS_QUAD)
		tweencamZoom2.tween_property($player_perec/Camera2D, "zoom:y", 1.3, 4)
		var tween1 = get_tree().create_tween()
		tween1.tween_property($lol, "color:a", 1, 2)
		await TimerRoot.delay(3)
		var tweenR = get_tree().create_tween()
		tweenR.tween_property($lol, "color:r", 0, 4)
		var tweenG = get_tree().create_tween()
		tweenG.tween_property($lol, "color:g", 0, 4)
		var tweenB = get_tree().create_tween()
		tweenB.tween_property($lol, "color:b", 0, 4)
		var tweenD = get_tree().create_tween()
		tweenD.tween_property($dust_bg, "self_modulate:a", 1, 4)
		await TimerRoot.delay(1)
		var dust_come = get_tree().create_tween()
		dust_come.tween_property($dust, "position:x", 2519.0, 4)
		await TimerRoot.delay(4)
		$dust.play("stay")
		await TimerRoot.delay(2.5)
		$trans.play()
		$player_perec.spr.play("default-right")
		await TimerRoot.delay(3)
		$player_perec.spr.play("walk-right")
		$player_perec.velocity.x = 350
		await TimerRoot.delay(0.25)
		check_complete()
		
