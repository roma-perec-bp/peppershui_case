extends Node2D

var canPause:bool = false
var isDead:bool = false
var shakeHead:bool = false
var shakeEnd:bool = false
var shaking:bool = false

var start:bool = false

var phase:int = 1

var health:int = 100
var damaged:bool = false

var bullet=load("res://levels/obj/enemy_bullet.tscn")
var fly=load("res://levels/obj/enemy_flyt.tscn")
var cacobab=load("res://levels/obj/cacoball.tscn")
var rockey=load("res://levels/obj/rocket.tscn")

var exp=load("res://levels/obj/explode.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await TimerRoot.delay(0.1)
	$player_exe.canMove = false
	var tween = get_tree().create_tween()
	tween.tween_property($hud/Control2/ColorRect2, "self_modulate:a", 0, 3)
	await TimerRoot.delay(3)
	if SaveFile.lights: $intro.play("new_animation")
	$intro_music.play()
	var hescoming = get_tree().create_tween()
	hescoming.tween_property($ultra_hui, "position:y", 243.0, 18)
	await TimerRoot.delay(20)
	var fade1 = get_tree().create_tween()
	fade1.tween_property($ultra_hui, "modulate:r", 1, 1)
	var fade2 = get_tree().create_tween()
	fade2.tween_property($ultra_hui, "modulate:g", 1, 1)
	var fade3 = get_tree().create_tween()
	fade3.tween_property($ultra_hui, "modulate:b", 1, 1)
	var fade4 = get_tree().create_tween()
	fade4.tween_property($ColorRect, "self_modulate:a", 0, 1)
	var fade5 = get_tree().create_tween()
	fade5.tween_property($player_exe, "modulate:r", 1, 1)
	var fade6 = get_tree().create_tween()
	fade6.tween_property($player_exe, "modulate:g", 1, 1)
	var fade7 = get_tree().create_tween()
	fade7.tween_property($player_exe, "modulate:b", 1, 1)
	await TimerRoot.delay(3)
	shakeHead = true
	$ultra_hui/head_anim.play("laugh")
	$ultra_hui/body_anim.stop()
	$ultra_hui/eyes_anim.stop()
	$ultra_hui/left_hand_anim.stop()
	$ultra_hui/right_hand_anim.stop()
	$laugh.play()
	await TimerRoot.delay(6)
	$ultra_hui/head_anim.play("laugh_stop")
	shakeHead = false
	$ultra_hui/head.offset.x = 0
	$ultra_hui/head.offset.y = 0
	$Camera2D.offset.x = 0
	$Camera2D.offset.y = 0
	await TimerRoot.delay(2)
	$ultra_hui/head_anim.play("idle")
	$ultra_hui/body_anim.play("idle")
	$ultra_hui/eyes_anim.play("idle")
	$ultra_hui/left_hand_anim.play("idle")
	$ultra_hui/right_hand_anim.play("idle")
	$music.play()
	$player_exe.canMove = true
	canPause = true
	start = true
	shaking = true
	$hud/Control/ProgressBar.visible = true
	$hud/Control/Label.visible = true
	await TimerRoot.delay(1)
	attack_phase1()
	$reload.play()
	$Timer.set_wait_time(randi_range(1, 1.5))
	$Timer.start()
	await TimerRoot.delay(2)
	$trans.play()
	$hud/Control/name.visible = true
	$hud/Control/Label.visible = false
	
func _physics_process(delta: float) -> void:
	$hud/Control/ProgressBar.value = $player_exe.health
	
	if shakeHead:
		$ultra_hui/head.offset.x = randf_range(-10,10)
		$ultra_hui/head.offset.y = randf_range(-10,10)
		
		if SaveFile.lights:
			$Camera2D.offset.x = randf_range(-10,10)
			$Camera2D.offset.y = randf_range(-10,10)
	
	if SaveFile.lights:	
		if shaking:
			$Camera2D.offset.x = randf_range(-4,4)
			$Camera2D.offset.y = randf_range(-4,4)
		
	if shakeEnd:
		if SaveFile.lights:	
			$Camera2D.offset.x = randf_range(-15,15)
			$Camera2D.offset.y = randf_range(-15,15)
		
		if randi() % 15 == 0:
			var hui = exp.instantiate()
			get_parent().add_child(hui)
			hui.global_position.x = randf_range(0,640)
			hui.global_position.y = randf_range(0,480)
		
	if start:
		#ATTACK 1 FIRST ANGLE
		$bullet_type_1_0.look_at(Vector2($player_exe.global_position.x - 400, $player_exe.global_position.y))
		$bullet_type_1_1.look_at(Vector2($player_exe.global_position.x - 300, $player_exe.global_position.y))
		$bullet_type_1_2.look_at(Vector2($player_exe.global_position.x - 200, $player_exe.global_position.y))
		$bullet_type_1_3.look_at(Vector2($player_exe.global_position.x - 100, $player_exe.global_position.y))
		$bullet_type_1_4.look_at(Vector2($player_exe.global_position.x, $player_exe.global_position.y))
		$bullet_type_1_5.look_at(Vector2($player_exe.global_position.x + 100, $player_exe.global_position.y))
		$bullet_type_1_6.look_at(Vector2($player_exe.global_position.x + 200, $player_exe.global_position.y))
		$bullet_type_1_7.look_at(Vector2($player_exe.global_position.x + 300, $player_exe.global_position.y))
		$bullet_type_1_8.look_at(Vector2($player_exe.global_position.x + 400, $player_exe.global_position.y))
		
		#ATTACK 1 SECOND ANGLE
		$bullet_type_1_9.look_at(Vector2($player_exe.global_position.x - 500, $player_exe.global_position.y))
		$bullet_type_1_10.look_at(Vector2($player_exe.global_position.x - 400, $player_exe.global_position.y))
		$bullet_type_1_11.look_at(Vector2($player_exe.global_position.x - 300, $player_exe.global_position.y))
		$bullet_type_1_12.look_at(Vector2($player_exe.global_position.x - 200, $player_exe.global_position.y))
		$bullet_type_1_13.look_at(Vector2($player_exe.global_position.x - 100, $player_exe.global_position.y))
		$bullet_type_1_14.look_at(Vector2($player_exe.global_position.x, $player_exe.global_position.y))
		$bullet_type_1_15.look_at(Vector2($player_exe.global_position.x + 100, $player_exe.global_position.y))
		$bullet_type_1_16.look_at(Vector2($player_exe.global_position.x + 200, $player_exe.global_position.y))
		$bullet_type_1_17.look_at(Vector2($player_exe.global_position.x + 300, $player_exe.global_position.y))
		
		#ATTACK 2 STRAIGHT
		$bullet_type_2_0.look_at(Vector2($player_exe.global_position.x, $player_exe.global_position.y))
		$bullet_type_2_1.look_at(Vector2($player_exe.global_position.x, $player_exe.global_position.y))
		$bullet_type_2_2.look_at(Vector2($player_exe.global_position.x, $player_exe.global_position.y))
		$bullet_type_2_3.look_at(Vector2($player_exe.global_position.x, $player_exe.global_position.y))
		$bullet_type_2_4.look_at(Vector2($player_exe.global_position.x, $player_exe.global_position.y))
		$bullet_type_2_5.look_at(Vector2($player_exe.global_position.x, $player_exe.global_position.y))
		$bullet_type_2_6.look_at(Vector2($player_exe.global_position.x, $player_exe.global_position.y))
		$bullet_type_2_7.look_at(Vector2($player_exe.global_position.x, $player_exe.global_position.y))
		$bullet_type_2_8.look_at(Vector2($player_exe.global_position.x, $player_exe.global_position.y))

		#ATTACK 3 FIRST ANGLE
		if $ultra_hui/head/beam/Area2D.overlaps_body($player_exe) and larp:
			$player_exe._damage()
			
		#ATTACK 5 FLY
		$bullet_fly_left_0.look_at(Vector2($player_exe.global_position.x, $player_exe.global_position.y))
		$bullet_fly_left_1.look_at(Vector2($player_exe.global_position.x, $player_exe.global_position.y))
		$bullet_fly_left_2.look_at(Vector2($player_exe.global_position.x, $player_exe.global_position.y))
		$bullet_fly_left_3.look_at(Vector2($player_exe.global_position.x, $player_exe.global_position.y))
		$bullet_fly_left_5.look_at(Vector2($player_exe.global_position.x, $player_exe.global_position.y))
		$bullet_fly_left_4.look_at(Vector2($player_exe.global_position.x, $player_exe.global_position.y))
		$bullet_fly_right_0.look_at(Vector2($player_exe.global_position.x, $player_exe.global_position.y))
		$bullet_fly_right_1.look_at(Vector2($player_exe.global_position.x, $player_exe.global_position.y))
		$bullet_fly_right_2.look_at(Vector2($player_exe.global_position.x, $player_exe.global_position.y))
		$bullet_fly_right_3.look_at(Vector2($player_exe.global_position.x, $player_exe.global_position.y))
		$bullet_fly_right_4.look_at(Vector2($player_exe.global_position.x, $player_exe.global_position.y))
		$bullet_fly_right_5.look_at(Vector2($player_exe.global_position.x, $player_exe.global_position.y))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape") and canPause:
		get_tree().paused = true
		TimerRoot.set_paused(true)
		$hud/pause.pause()
		$hud/pause.visible = true

func death():
	if !isDead:
		damaged = true
		canPause = false
		isDead = true
		$player_exe.canMove = false
		$music.stop()
		$hud/death.visible = true
		$hud/death/dead.play("default")
		$hud/death/snd.play()
		await TimerRoot.delay(3)
		var tween = get_tree().create_tween()
		tween.tween_property($hud/Control2/ColorRect2, "self_modulate:a", 1, 1)
		await TimerRoot.delay(1)
		get_tree().reload_current_scene()

var even:int = 1
var even2:int = 1
var even3:int = 1
var beaming:bool = false
var larp:bool = false
var maxAttack:int = 2
var ballin:bool = false
func attack_phase1():
	var attackPhase1:int = randi_range(0, maxAttack)
	
	if beaming and attackPhase1 == 2: 
		attack_phase1()
		return
		
	if ballin and attackPhase1 == 5: 
		attack_phase1()
		return
				
	match attackPhase1:
		0:
			for n in 4:
				if even == 1:
					even = 0
				else:
					even = 1
					
				$bullet_spread.play()
					
				if even == 0:
					var b0 = bullet.instantiate()
					get_parent().add_child(b0)
					b0.transform = $bullet_type_1_0.global_transform
		
					var b1 = bullet.instantiate()
					get_parent().add_child(b1)
					b1.transform = $bullet_type_1_1.global_transform
		
					var b2 = bullet.instantiate()
					get_parent().add_child(b2)
					b2.transform = $bullet_type_1_2.global_transform
		
					var b3 = bullet.instantiate()
					get_parent().add_child(b3)
					b3.transform = $bullet_type_1_3.global_transform
		
					var b4 = bullet.instantiate()
					get_parent().add_child(b4)
					b4.transform = $bullet_type_1_4.global_transform
		
					var b5 = bullet.instantiate()
					get_parent().add_child(b5)
					b5.transform = $bullet_type_1_5.global_transform
		
					var b6 = bullet.instantiate()
					get_parent().add_child(b6)
					b6.transform = $bullet_type_1_6.global_transform
		
					var b7 = bullet.instantiate()
					get_parent().add_child(b7)
					b7.transform = $bullet_type_1_7.global_transform
		
					var b8 = bullet.instantiate()
					get_parent().add_child(b8)
					b8.transform = $bullet_type_1_8.global_transform
				else:
					var b0 = bullet.instantiate()
					get_parent().add_child(b0)
					b0.transform = $bullet_type_1_9.global_transform
		
					var b1 = bullet.instantiate()
					get_parent().add_child(b1)
					b1.transform = $bullet_type_1_10.global_transform
		
					var b2 = bullet.instantiate()
					get_parent().add_child(b2)
					b2.transform = $bullet_type_1_11.global_transform
		
					var b3 = bullet.instantiate()
					get_parent().add_child(b3)
					b3.transform = $bullet_type_1_12.global_transform
		
					var b4 = bullet.instantiate()
					get_parent().add_child(b4)
					b4.transform = $bullet_type_1_13.global_transform
		
					var b5 = bullet.instantiate()
					get_parent().add_child(b5)
					b5.transform = $bullet_type_1_14.global_transform
		
					var b6 = bullet.instantiate()
					get_parent().add_child(b6)
					b6.transform = $bullet_type_1_15.global_transform
		
					var b7 = bullet.instantiate()
					get_parent().add_child(b7)
					b7.transform = $bullet_type_1_16.global_transform
		
					var b8 = bullet.instantiate()
					get_parent().add_child(b8)
					b8.transform = $bullet_type_1_17.global_transform
					
				await TimerRoot.delay(0.3)
		1:
			for n in 8:
				$bullet_spam.play()
				var b0 = bullet.instantiate()
				get_parent().add_child(b0)
				b0.transform = $bullet_type_2_0.global_transform
			
				var b1 = bullet.instantiate()
				get_parent().add_child(b1)
				b1.transform = $bullet_type_2_1.global_transform
			
				var b2 = bullet.instantiate()
				get_parent().add_child(b2)
				b2.transform = $bullet_type_2_2.global_transform
					
				var b3 = bullet.instantiate()
				get_parent().add_child(b3)
				b3.transform = $bullet_type_2_3.global_transform
					
				var b4 = bullet.instantiate()
				get_parent().add_child(b4)
				b4.transform = $bullet_type_2_4.global_transform
			
				var b5 = bullet.instantiate()
				get_parent().add_child(b5)
				b5.transform = $bullet_type_2_5.global_transform
			
				var b6 = bullet.instantiate()
				get_parent().add_child(b6)
				b6.transform = $bullet_type_2_6.global_transform
					
				var b7 = bullet.instantiate()
				get_parent().add_child(b7)
				b7.transform = $bullet_type_2_7.global_transform
					
				var b8 = bullet.instantiate()
				get_parent().add_child(b8)
				b8.transform = $bullet_type_2_8.global_transform
					
				await TimerRoot.delay(0.05)
		2:
			$ultra_hui/head/beam.self_modulate.a = 0.5
			$ultra_hui/head/beam.play("default")
			$reload.play()
			$ghast.play()
			beaming = true
			await TimerRoot.delay(1)
			shakeHead = true
			shaking = false
			larp = true
			$ColorRect.self_modulate.a = 1
			var fade4 = get_tree().create_tween()
			fade4.tween_property($ColorRect, "self_modulate:a", 0, 0.5)
			$ultra_hui/head/beam.self_modulate.a = 1
			$ultra_hui/head/beam.play("ass")
			$beam.play()
			await TimerRoot.delay(0.6)
			shakeHead = false
			shaking = true
			larp = false
			$ultra_hui/head.offset.x = 0
			$ultra_hui/head.offset.y = 0
			$ultra_hui/head/beam.self_modulate.a = 0
			$ultra_hui/head/beam.play("default")
			await TimerRoot.delay(3)
			beaming = false
			
		3:
			for n in 12:
				if even3 == 1:
					even3 = 0
				else:
					even3 = 1
					
				$shoot.play()
					
				if even3:
					match randi_range(0, 4):
						0:
							var b1 = bullet.instantiate()
							get_parent().add_child(b1)
							b1.transform = $bullet_right_0.global_transform
						1:
							var b1 = bullet.instantiate()
							get_parent().add_child(b1)
							b1.transform = $bullet_right_1.global_transform
						2:
							var b1 = bullet.instantiate()
							get_parent().add_child(b1)
							b1.transform = $bullet_right_2.global_transform
						3:
							var b1 = bullet.instantiate()
							get_parent().add_child(b1)
							b1.transform = $bullet_right_2.global_transform
				else:
					match randi_range(0, 4):
						0:
							var b1 = bullet.instantiate()
							get_parent().add_child(b1)
							b1.transform = $bullet_left_0.global_transform
						1:
							var b1 = bullet.instantiate()
							get_parent().add_child(b1)
							b1.transform = $bullet_left_1.global_transform
						2:
							var b1 = bullet.instantiate()
							get_parent().add_child(b1)
							b1.transform = $bullet_left_2.global_transform
						3:
							var b1 = bullet.instantiate()
							get_parent().add_child(b1)
							b1.transform = $bullet_left_2.global_transform

				await TimerRoot.delay(0.5)

		4:
			if even2 == 1:
				even2 = 0
			else:
				even2 = 1
					
			for n in 16:
				$flies.play()
				
				if even2:
					match randi_range(0, 5):
						0:
							var b1 = fly.instantiate()
							get_parent().add_child(b1)
							b1.transform = $bullet_fly_left_0.global_transform
						1:
							var b1 = fly.instantiate()
							get_parent().add_child(b1)
							b1.transform = $bullet_fly_left_1.global_transform
						2:
							var b1 = fly.instantiate()
							get_parent().add_child(b1)
							b1.transform = $bullet_fly_left_2.global_transform
						3:
							var b1 = fly.instantiate()
							get_parent().add_child(b1)
							b1.transform = $bullet_fly_left_3.global_transform
						4:
							var b1 = fly.instantiate()
							get_parent().add_child(b1)
							b1.transform = $bullet_fly_left_4.global_transform
						5:
							var b1 = fly.instantiate()
							get_parent().add_child(b1)
							b1.transform = $bullet_fly_left_5.global_transform
				else:
					match randi_range(0, 5):
						0:
							var b1 = fly.instantiate()
							get_parent().add_child(b1)
							b1.transform = $bullet_fly_right_0.global_transform
						1:
							var b1 = fly.instantiate()
							get_parent().add_child(b1)
							b1.transform = $bullet_fly_right_1.global_transform
						2:
							var b1 = fly.instantiate()
							get_parent().add_child(b1)
							b1.transform = $bullet_fly_right_2.global_transform
						3:
							var b1 = fly.instantiate()
							get_parent().add_child(b1)
							b1.transform = $bullet_fly_right_3.global_transform
						4:
							var b1 = fly.instantiate()
							get_parent().add_child(b1)
							b1.transform = $bullet_fly_right_4.global_transform
						5:
							var b1 = fly.instantiate()
							get_parent().add_child(b1)
							b1.transform = $bullet_fly_right_5.global_transform

				await TimerRoot.delay(0.05)
				
		5:
			ballin = true
			$ghast.play()
			for n in 4:
				$huiyak.play()
				$generate.play()
				var b1 = cacobab.instantiate()
				get_parent().add_child(b1)
				b1.transform = $caco_spawn.global_transform
				await TimerRoot.delay(0.3)
				
			await TimerRoot.delay(5)
			ballin = false
			
		6:
			for n in 7:
				match randi_range(0, 10):
					0:
						var b1 = rockey.instantiate()
						get_parent().add_child(b1)
						b1.global_position = $rocket_0.global_position
					1:
						var b1 = rockey.instantiate()
						get_parent().add_child(b1)
						b1.global_position = $rocket_1.global_position
					2:
						var b1 = rockey.instantiate()
						get_parent().add_child(b1)
						b1.global_position = $rocket_2.global_position
					3:
						var b1 = rockey.instantiate()
						get_parent().add_child(b1)
						b1.global_position = $rocket_3.global_position
					4:
						var b1 = rockey.instantiate()
						get_parent().add_child(b1)
						b1.global_position = $rocket_4.global_position
					5:
						var b1 = rockey.instantiate()
						get_parent().add_child(b1)
						b1.global_position = $rocket_5.global_position
					6:
						var b1 = rockey.instantiate()
						get_parent().add_child(b1)
						b1.global_position = $rocket_6.global_position
					7:
						var b1 = rockey.instantiate()
						get_parent().add_child(b1)
						b1.global_position = $rocket_7.global_position
					8:
						var b1 = rockey.instantiate()
						get_parent().add_child(b1)
						b1.global_position = $rocket_8.global_position
					9:
						var b1 = rockey.instantiate()
						get_parent().add_child(b1)
						b1.global_position = $rocket_9.global_position
					10:
						var b1 = rockey.instantiate()
						get_parent().add_child(b1)
						b1.global_position = $rocket_10.global_position
						
				await TimerRoot.delay(0.35)

func _on_progress_bar_value_changed(value: float) -> void:
	if value < 1 and not isDead:
		death()


func _on_timer_timeout() -> void:
	attack_phase1()

func _on_music_damage_finished() -> void:
	if phase != 4:
		$music.stream = load("res://music/boss_phase"+str(phase)+".wav")
		$music_damage.stream = load("res://music/boss_lost"+str(phase)+".wav")
		
		var tween = get_tree().create_tween()
		tween.tween_property($ColorRect3, "self_modulate:a", 0, 1)
		
		var tweenL = get_tree().create_tween()
		tweenL.tween_property($ultra_hui/head/l_eye, "self_modulate:a", 1, 1)
		var tweenR = get_tree().create_tween()
		tweenR.tween_property($ultra_hui/head/r_eye, "self_modulate:a", 1, 1)
	
	match phase:
		2:
			health = 150
			maxAttack = 4
		3:
			health = 200
			maxAttack = 6
		4:
			health = 255
	
	if phase != 4:
		$player_exe.canShoot = true
		damaged = false
		$music.play()
		$music_damage.stop()
		attack_phase1()
		$Timer.start()
		shaking = true
		$hud/Control/Label.visible = true
		
		match phase:
			2:
				$hud/Control/Label.text = 'Это его останавливает!\n Продолжай в том же духе'
			3:
				$hud/Control/Label.text = 'Еще чуть чуть!\nПросто стреляй в него'
			4:
				pass
		
		await TimerRoot.delay(3)
		$hud/Control/Label.visible = false
		$trans.play()
	else:
		var fade1 = get_tree().create_tween()
		fade1.tween_property($ultra_hui, "modulate:r", 0, 1)
		var fade2 = get_tree().create_tween()
		fade2.tween_property($ultra_hui, "modulate:g", 0, 1)
		var fade3 = get_tree().create_tween()
		fade3.tween_property($ultra_hui, "modulate:b", 0, 1)
		
		$music_inter.play()
		
		$hud/Control/Label2.visible = true
		$hud/Control/Label2.text = "Ты почти это сделал!"
		$trans.play()
		await TimerRoot.delay(4)
		$hud/Control/Label2.visible = true
		$hud/Control/Label2.text = "Большинство получило плохую концовку"
		$trans.play()
		await TimerRoot.delay(4)
		$hud/Control/Label2.visible = true
		$hud/Control/Label2.text = "Но ты... получишь другую"
		$trans.play()
		await TimerRoot.delay(4)
		$hud/Control/Label2.visible = true
		$hud/Control/Label2.text = "Нанеси последний удар"
		$trans.play()
		await TimerRoot.delay(4)
		$hud/Control/Label2.visible = true
		$hud/Control/Label2.text = "УБЕЙ ЕГО"
		$player_exe.canShoot = true
		$trans.play()

func _on_target_damage_func() -> void:
	if damaged:
		return
		
	$damage.play()
	
	if randi() % 50 == 0:
		$rand_dmg.play()
	
	health -= 1
	
	if health <= 0:
		phase += 1
		if phase != 5:
			$player_exe.canShoot = false
			$Timer.stop()
			damaged = true
			
			if phase == 4:
				$player_exe.health = 100
			else:
				$player_exe.health += 25
			
			$music.stop()
			shaking = false
			shakeHead = true
			$music_damage.play()
			
			var tween = get_tree().create_tween()
			tween.tween_property($ColorRect3, "self_modulate:a", 1, 1)
			
			var tweenL = get_tree().create_tween()
			tweenL.tween_property($ultra_hui/head/l_eye, "self_modulate:a", 0, 1)
			var tweenR = get_tree().create_tween()
			tweenR.tween_property($ultra_hui/head/r_eye, "self_modulate:a", 0, 1)
		
			match phase:
				2:
					$line0.play()
				3:
					$line1.play()
				4:
					$line2.play()

			await TimerRoot.delay(3)
			shakeHead = false
			$ultra_hui/head.offset.x = 0
			$ultra_hui/head.offset.y = 0
			$Camera2D.offset.x = 0
			$Camera2D.offset.y = 0
		else:
			$Timer.stop()
			damaged = true
			
			canPause = false
			$music_finale.stop()
			$music_end.play()
			
			var tweenX = get_tree().create_tween()
			tweenX.tween_property($ColorRect3, "self_modulate:a", 1, 1)
			
			var tweenL = get_tree().create_tween()
			tweenL.tween_property($ultra_hui/head/l_eye, "self_modulate:a", 0, 1)
			var tweenR = get_tree().create_tween()
			tweenR.tween_property($ultra_hui/head/r_eye, "self_modulate:a", 0, 1)
			
			shaking = false
			shakeEnd = true
			
			await TimerRoot.delay(3)
			$AudioStreamPlayer.play()
			await TimerRoot.delay(2)
			
			var tween = get_tree().create_tween()
			tween.tween_property($hud/Control2/ColorRect2, "self_modulate:a", 1, 2)
			await TimerRoot.delay(2)
			shakeEnd = false
			$player_exe.canMove = false
			
			var tween2 = get_tree().create_tween()
			tween2.tween_property($hud/Control2/ColorRect3, "self_modulate:a", 1, 4)
			
			var tween3 = get_tree().create_tween()
			tween3.tween_property($hud/Control2/Sprite2D, "self_modulate:a", 1, 4)
			
			var tween4 = get_tree().create_tween()
			tween4.tween_property($hud/Control2/Sprite2D2, "self_modulate:a", 1, 4)
			await TimerRoot.delay(4)
			var hescoming = get_tree().create_tween()
			hescoming.tween_property($hud/Control2/Sprite2D2, "position:y", 559.0, 1)
			await TimerRoot.delay(2)
			var tween3X = get_tree().create_tween()
			tween3X.tween_property($hud/Control2/Sprite2D, "self_modulate:a", 0, 1)
			await TimerRoot.delay(4)
			if SaveFile.progress < 10:
				SaveFile.progress = 10
				SaveFile.save_data()
				
			get_tree().change_scene_to_file("res://levels/ending.tscn")


func _on_music_inter_finished() -> void:
	var fade1 = get_tree().create_tween()
	fade1.tween_property($ultra_hui, "modulate:r", 1, 1)
	var fade2 = get_tree().create_tween()
	fade2.tween_property($ultra_hui, "modulate:g", 1, 1)
	var fade3 = get_tree().create_tween()
	fade3.tween_property($ultra_hui, "modulate:b", 1, 1)
	
	var tween = get_tree().create_tween()
	tween.tween_property($ColorRect3, "self_modulate:a", 0, 1)
		
	var tweenL = get_tree().create_tween()
	tweenL.tween_property($ultra_hui/head/l_eye, "self_modulate:a", 1, 1)
	var tweenR = get_tree().create_tween()
	tweenR.tween_property($ultra_hui/head/r_eye, "self_modulate:a", 1, 1)
	
	damaged = false
	$music_finale.play()
	
	$hud/Control/Label2.visible = false

	attack_phase1()
	$Timer.start()
	shaking = true
