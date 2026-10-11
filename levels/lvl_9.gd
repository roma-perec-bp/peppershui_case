extends Node2D

var isDead:bool = false
var kills:int = 0

var start:bool = false

var shake:bool = false
var isShaking:bool = false

var canPause:bool = false

var zoomCamX: Tween = null
var zoomCamY: Tween = null
var zoomCamX2: Tween = null
var zoomCamY2: Tween = null

var chase:bool = false
var gotem:bool = false

var monster=load("res://levels/obj/monster.tscn")
var monsterSpawn:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await TimerRoot.delay(0.1)
	$player_umbra.moveSpeed = 450
	$player_umbra.canMove = false
	$intro.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape") and canPause:
		get_tree().paused = true
		TimerRoot.set_paused(true)
		$hud/pause.pause()
		$hud/pause.visible = true
	
func _physics_process(delta: float) -> void:
	if chase:
		var direct = $monster_guy.global_position.direction_to($player_umbra.global_position).normalized()
		$monster_guy.velocity = direct * 500
		$monster_guy.move_and_slide()
	
	if SaveFile.lights:
		if shake:
			$player_umbra/Camera2D.offset.x = randf_range(0,4)
			$player_umbra/Camera2D.offset.y = randf_range(0,4)
			
		if isShaking:
			$player_umbra/Camera2D.offset.x = randf_range(0,10)
			$player_umbra/Camera2D.offset.y = randf_range(0,10)

func check_complete():
	if SaveFile.progress < 9:
		SaveFile.progress = 9
		SaveFile.save_data()
			
	$end.play()
	$hud/win.visible = true
	$hud/win/AnimationPlayer.play("end")
	
	await TimerRoot.delay(4)
	get_tree().change_scene_to_file("res://levels/inter_10.tscn")


func death():
	if !isDead:
		canPause = false
		isDead = true
		$player_umbra.canMove = false
		$music.stop()
		$hud/death.visible = true
		$hud/death/dead.play("default")
		$hud/death/snd.play()
		await TimerRoot.delay(3)
		get_tree().reload_current_scene()


func _on_timer_timeout() -> void:
	isShaking = false


func _on_timer_2_timeout() -> void:
	zoomCamX2 = get_tree().create_tween()
	zoomCamX2.set_ease(Tween.EASE_OUT)
	zoomCamX2.set_trans(Tween.TRANS_EXPO)
	zoomCamX2.tween_property($player_umbra/Camera2D, "zoom:x", 1, 1)
	
	zoomCamY2 = get_tree().create_tween()
	zoomCamY2.set_ease(Tween.EASE_OUT)
	zoomCamY2.set_trans(Tween.TRANS_EXPO)
	zoomCamY2.tween_property($player_umbra/Camera2D, "zoom:y", 1, 1)


func _on_intro_finished() -> void:
	canPause = true
	$trans.play()
	$hud/Control/collect.visible = true
	$hud/Control/name.visible = true
	$player_umbra.canMove = true
	start = true
	shake = true
	$music.play()
	
	$hud/Control/kill.visible = true
	$hud/Control/flash.visible = true
	
	var tween = get_tree().create_tween()
	tween.tween_property($hud/Control/vin, "self_modulate:a", 1, 6)
	
	spawnMosner()
	
	for n in 9:
		spawnMosnerNoTimer()
	
	if SaveFile.lights:
		var tweenFlash = get_tree().create_tween()
		tweenFlash.tween_property($hud/Control/flash, "self_modulate:a", 0, 3)
	
	$hud/Control/AnimationPlayer.play("new_animation")

	await TimerRoot.delay(3)
	
	var tweenTxt = get_tree().create_tween()
	tweenTxt.tween_property($hud/Control/kill, "self_modulate:a", 0, 3)

func spawnMosner():
	if monsterSpawn != 100:
		monsterSpawn += 1
		var inst = monster.instantiate()
		var rand:int = randi_range(0, 7)
			
		match rand:
			0:
				inst.position = $spawn0.global_position
			1:
				inst.position = $spawn1.global_position
			2:
				inst.position = $spawn2.global_position
			3:
				inst.position = $spawn3.global_position
			4:
				inst.position = $spawn4.global_position
			5:
				inst.position = $spawn5.global_position
			6:
				inst.position = $spawn6.global_position
			7:
				inst.position = $spawn0.global_position
					
		get_parent().add_child(inst)
		await TimerRoot.delay(randf_range(0.05, 2))
		spawnMosner()
		
func spawnMosnerNoTimer():
	if monsterSpawn != 100:
		monsterSpawn += 1
		var inst = monster.instantiate()
		var rand:int = randi_range(0, 7)
			
		match rand:
			0:
				inst.position = $spawn0.global_position
			1:
				inst.position = $spawn1.global_position
			2:
				inst.position = $spawn2.global_position
			3:
				inst.position = $spawn3.global_position
			4:
				inst.position = $spawn4.global_position
			5:
				inst.position = $spawn5.global_position
			6:
				inst.position = $spawn6.global_position
			7:
				inst.position = $spawn0.global_position
					
		get_parent().add_child(inst)

func _on_player_umbra_on_dead() -> void:
	kills += 1
	$hud/Control/collect.text = str(kills) + "/100"
	
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
	zoomCamX.tween_property($player_umbra/Camera2D, "zoom:x", 1.4, 0.5)
	
	zoomCamY = get_tree().create_tween()
	zoomCamY.set_ease(Tween.EASE_OUT)
	zoomCamY.set_trans(Tween.TRANS_EXPO)
	zoomCamY.tween_property($player_umbra/Camera2D, "zoom:y", 1.4, 0.5)
	
	$Timer.stop()
	$Timer2.stop()
	isShaking = true
	$Timer.start()
	$Timer2.start()
	
	if kills == 100:
		shake = false
		var tween2 = get_tree().create_tween()
		tween2.tween_property($hud/Control/vin, "self_modulate:a", 0, 3)
		
		canPause = false
		isDead = true
		$player_umbra.canMove = false
		$player_umbra.spr.play("default-front")
		$player_umbra.velocity.x = 0
		$player_umbra.velocity.y = 0
		$player_umbra/Camera2D.drag_horizontal_enabled = false
		$player_umbra/Camera2D.drag_vertical_enabled = false
		start = false
		var tween = get_tree().create_tween()
		tween.tween_property($music, "volume_db", -80.0, 6)
		$hud/Control/Label.visible = true
		$hud/Control/Label.text = "ПОЗДРАВЛЯЮ\nТы победил!"
		$trans.play()
		await TimerRoot.delay(3)
		$player_umbra.canMove = true
		$hud/Control/Label.text = "ПОЗДРАВЛЯЮ\nТы победил?"
		$monster_guy.visible = true
		$map.visible = false
		$trans.play()
		chase = true
		$loop_noise.play()
		isShaking = true
		


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == 'player_umbra' and chase:
		$hud/Control/AnimatedSprite2D.play("rus")
		$player_umbra.canMove = false
		$player_umbra.velocity.x = 0
		$player_umbra.velocity.y = 0
		$loop_noise.stop()
		$AudioStreamPlayer.play()
		$hud/Control/AnimatedSprite2D.visible = true
		await TimerRoot.delay(3)
		$AudioStreamPlayer.stop()
		check_complete()
