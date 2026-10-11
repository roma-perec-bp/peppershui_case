extends Node2D

var isDead:bool = false
var canPause:bool = false

var shake:bool = false
var isShaking:bool = false
var end:bool = false

var cut:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$player_stif.canMove = false
	$player_stif.spr.play("default-front")
	$hud/Control/AnimationPlayer.play("new_animation")
	await get_tree().create_timer(5).timeout
	canPause = true
	$trans.play()
	$hud/Control/Label.visible = false
	$hud/Control/Label2.visible = true
	$hud/Control/name.visible = true
	$player_stif.canMove = true
	await get_tree().create_timer(5).timeout
	$hud/Control/Label2.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape") and canPause:
		get_tree().paused = true
		TimerRoot.set_paused(true)
		$hud/pause.pause()
		$hud/pause.visible = true
		
	if SaveFile.lights:
		if isShaking:
			$player_stif/Camera2D.offset.x = randf_range(-10,10)
			$player_stif/Camera2D.offset.y = randf_range(-10,10)

func check_complete():
	if SaveFile.progress < 8:
		SaveFile.progress = 8
		SaveFile.save_data()
			
	$end.play()
	$hud/win.visible = true
	$hud/win/AnimationPlayer.play("end")
	
	await TimerRoot.delay(4)
	get_tree().change_scene_to_file("res://levels/inter_9.tscn")


func _on_dead_trigger_body_entered(body: Node2D) -> void:
	if body.name == 'player_stif' and !isDead:
		isDead = true
		canPause = false
		$player_stif.canMove = false
		$music.stop()
		$hud/death.visible = true
		$hud/death/dead.play("default")
		$hud/death/snd.play()
		await TimerRoot.delay(3)
		get_tree().reload_current_scene()
		


func _on_small_troop_kill() -> void:
	if !isDead:
		isDead = true
		canPause = false
		$player_stif.canMove = false
		$music.stop()
		$hud/death.visible = true
		$hud/death/dead.play("default")
		$hud/death/snd.play()
		await TimerRoot.delay(3)
		get_tree().reload_current_scene()


func _on_big_troop_kill() -> void:
	if !isDead:
		isDead = true
		canPause = false
		$player_stif.canMove = false
		$music.stop()
		$hud/death.visible = true
		$hud/death/dead.play("default")
		$hud/death/snd.play()
		await TimerRoot.delay(3)
		get_tree().reload_current_scene()


func _on_player_stif_shoot() -> void:
	$shakeTime.stop()
	isShaking = true
	$shakeTime.start()


func _on_shake_time_timeout() -> void:
	isShaking = false
	$player_stif/Camera2D.offset.x = 0
	$player_stif/Camera2D.offset.y = 0
		


func _on_end_trigger_body_entered(body: Node2D) -> void:
	if body.name == 'player_stif' and !cut:
		cut = true
		$hud/Control/ColorRect.visible = true
		$hud/death/snd.play()
		isDead = true
		canPause = false
		$player_stif.canMove = false
		$music.stop()
		await TimerRoot.delay(3)
		$player_stif/Camera2D.enabled = false
		$Camera2D.enabled = true
		var tween = get_tree().create_tween()
		tween.tween_property($danger, "volume_db", -6, 1)
		$danger.play()
		for n in 5:
			$hud/Control/ColorRect.self_modulate.a -= 0.2
			await TimerRoot.delay(0.25)
			
		await TimerRoot.delay(2)
		var dust_come = get_tree().create_tween()
		dust_come.tween_property($zomb_cut, "position:y", 3698.0, 2)
		$zomb_cut.play("leave")
		await TimerRoot.delay(3)
		$danger.stop()
		$ohNo.play()
		await TimerRoot.delay(1)
		check_complete()
