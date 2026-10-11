extends Node2D

var isDead:bool = false
var kills:int = 0

var time:float = 160
var start:bool = false

var shake:bool = false
var isShaking:bool = false

var canPause:bool = false

var zoomCamX: Tween = null
var zoomCamY: Tween = null
var zoomCamX2: Tween = null
var zoomCamY2: Tween = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if randi() % 6 == 0: $Sprite2D.visible = true
	$player_perec.moveSpeed = 350
	$player_perec.canMove = false
	$player_perec.spr.play("default-front")
	$hud/Control/AnimationPlayer.play("new_animation")
	await TimerRoot.delay(5)
	canPause = true
	$trans.play()
	$hud/Control/Label.visible = false
	$hud/Control/collect.visible = true
	$hud/Control/timer.visible = true
	$hud/Control/name.visible = true
	$player_perec.canMove = true
	start = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape") and canPause:
		get_tree().paused = true
		TimerRoot.set_paused(true)
		$hud/pause.pause()
		$hud/pause.visible = true
	
func _physics_process(delta: float) -> void:
	if start:
		time -= delta
		$hud/Control/timer.text = str(int(time))
		
	if time < 0 and !isDead:
		death()
	
	if SaveFile.lights:
		if shake:
			$player_perec/Camera2D.offset.x = randf_range(0,4)
			$player_perec/Camera2D.offset.y = randf_range(0,4)
			
		if isShaking:
			$player_perec/Camera2D.offset.x = randf_range(0,10)
			$player_perec/Camera2D.offset.y = randf_range(0,10)

func check_complete():
	if SaveFile.progress < 3:
		SaveFile.progress = 3
		SaveFile.save_data()
			
	$end.play()
	$hud/win.visible = true
	$hud/win/AnimationPlayer.play("end")
	
	await TimerRoot.delay(4)
	get_tree().change_scene_to_file("res://levels/inter_4.tscn")


func death():
	if !isDead:
		canPause = false
		isDead = true
		$player_perec.canMove = false
		$music.stop()
		$hud/death.visible = true
		$hud/death/dead.play("default")
		$hud/death/snd.play()
		await TimerRoot.delay(3)
		get_tree().reload_current_scene()


func _on_victim_on_dead() -> void:
	if !shake:
		shake = true
		var tween = get_tree().create_tween()
		tween.tween_property($hud/Control/vin, "self_modulate:a", 1, 6)
		
	kills += 1
	$hud/Control/collect.text = str(kills) + "/60"
	
	if zoomCamX and zoomCamX.is_running():
		zoomCamX.kill()
		
	if zoomCamX2 and zoomCamX2.is_running():
		zoomCamX2.kill()
		
	if zoomCamY and zoomCamY.is_running():
		zoomCamY.kill()
		
	if zoomCamY2 and zoomCamY2.is_running():
		zoomCamY2.kill()
	
	zoomCamX = get_tree().create_tween()
	zoomCamX.set_ease(Tween.EASE_OUT)
	zoomCamX.set_trans(Tween.TRANS_EXPO)
	zoomCamX.tween_property($player_perec/Camera2D, "zoom:x", 1.2, 0.5)
	
	zoomCamY = get_tree().create_tween()
	zoomCamY.set_ease(Tween.EASE_OUT)
	zoomCamY.set_trans(Tween.TRANS_EXPO)
	zoomCamY.tween_property($player_perec/Camera2D, "zoom:y", 1.2, 0.5)
	
	$Timer.stop()
	$Timer2.stop()
	isShaking = true
	$Timer.start()
	$Timer2.start()
	
	if kills == 60:
		shake = false
		$amb.play()
		var tween2 = get_tree().create_tween()
		tween2.tween_property($hud/Control/vin, "self_modulate:a", 0, 3)
		
		$player_perec.moveSpeed = 150
		$StaticBody2D.queue_free()
		
		$lock.visible = false
		$lock2.visible = false
		$lock3.visible = false
		$lock4.visible = false
		$lock5.visible = false
		$lock6.visible = false
		$lock7.visible = false
		$lock8.visible = false
		
		$player_perec/Camera2D.drag_horizontal_enabled = false
		$player_perec/Camera2D.drag_vertical_enabled = false
		
		start = false
		var tween = get_tree().create_tween()
		tween.tween_property($music, "volume_db", -80.0, 6)
		$hud/Control/Label.visible = true
		$hud/Control/Label.text = "\nЧто то открылось сверху..."
		await TimerRoot.delay(5)
		$hud/Control/Label.visible = false


func _on_timer_timeout() -> void:
	isShaking = false


func _on_timer_2_timeout() -> void:
	zoomCamX2 = get_tree().create_tween()
	zoomCamX2.set_ease(Tween.EASE_OUT)
	zoomCamX2.set_trans(Tween.TRANS_EXPO)
	zoomCamX2.tween_property($player_perec/Camera2D, "zoom:x", 0.8, 1)
	
	zoomCamY2 = get_tree().create_tween()
	zoomCamY2.set_ease(Tween.EASE_OUT)
	zoomCamY2.set_trans(Tween.TRANS_EXPO)
	zoomCamY2.tween_property($player_perec/Camera2D, "zoom:y", 0.8, 1)


func _on_end_trigger_body_entered(body: Node2D) -> void:
	if body.name == 'player_perec' and !isDead:
		canPause = false
		isDead = true
		$player_perec.canMove = false
		$player_perec.velocity.x = 0
		$player_perec.velocity.y = 0
		$player_perec.spr.play("default-back")
		
		await TimerRoot.delay(3)
		$rom.frame = 0
		$amb.stop()
		await TimerRoot.delay(1)
		check_complete()
