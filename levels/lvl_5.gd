extends Node2D

var isDead:bool = false
var canPause:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$player_zomb.canMove = false
	$player_zomb.spr.play("default-front")
	$hud/Control/AnimationPlayer.play("new_animation")
	await TimerRoot.delay(5)
	canPause = true
	$trans.play()
	$hud/Control/Label.visible = false
	$hud/Control/name.visible = true
	$player_zomb.canMove = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape") and canPause:
		get_tree().paused = true
		TimerRoot.set_paused(true)
		$hud/pause.pause()
		$hud/pause.visible = true

func check_complete():
	if SaveFile.progress < 5:
		SaveFile.progress = 5
		SaveFile.save_data()
			
	$end.play()
	$hud/win.visible = true
	$hud/win/AnimationPlayer.play("end")
	
	await TimerRoot.delay(4)
	get_tree().change_scene_to_file("res://levels/inter_6.tscn")


func _on_dead_trigger_body_entered(body: Node2D) -> void:
	if body.name == 'player_zomb' and !isDead:
		canPause = false
		isDead = true
		$player_zomb.canMove = false
		$music.stop()
		$hud/death.visible = true
		$hud/death/dead.play("default")
		$hud/death/snd.play()
		await TimerRoot.delay(3)
		get_tree().reload_current_scene()
		


func _on_mus_off_body_entered(body: Node2D) -> void:
	if body.name == 'player_zomb' and !isDead:
		var tween = get_tree().create_tween()
		tween.tween_property($music, "volume_db", -80.0, 6)
		$mus_off.queue_free()


func _on_end_trigger_body_entered(body: Node2D) -> void:
	if body.name == 'player_zomb' and !isDead:
		canPause = false
		isDead = true
		$player_zomb.canMove = false
		$player_zomb.hitbox.set_deferred("disabled", true)
		$player_zomb.velocity.x = 0
		$player_zomb.velocity.y = 0
		$player_zomb.spr.play("default-back")
		await TimerRoot.delay(1)
		var tweencamZoom = get_tree().create_tween()
		tweencamZoom.tween_property($player_zomb/Camera2D, "offset:x", 150, 3)
		var tweencamZoom2 = get_tree().create_tween()
		tweencamZoom2.tween_property($player_zomb/Camera2D, "offset:y", -50, 3)
		await TimerRoot.delay(4)
		$knock.play()
		$kate.frame = 0
		$trans.play()
		await TimerRoot.delay(1.5)
		check_complete()
