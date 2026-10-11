extends Node2D

var isDead:bool = false
var canPause:bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	$player_perec.canMove = false
	$player_perec.moveSpeed = 50
	$hud/Control/AnimationPlayer.play("new_animation")
	await get_tree().create_timer(5).timeout
	canPause = true
	$trans.play()
	$hud/Control/Label.visible = false
	$hud/Control/name.visible = true
	$player_perec.canMove = true

func check_complete():
	$end.play()
	$hud/win.visible = true
	$hud/win/AnimationPlayer.play("end")
	
	await TimerRoot.delay(4)
	if SaveFile.end:
		get_tree().change_scene_to_file("res://levels/main_menu.tscn")
	else:
		SaveFile.give_access()
		SaveFile.save_data()
	
		$done.play()
		$hud/access.visible = true
		await TimerRoot.delay(3)
		for n in 5:
			$hud/access/ColorRect.self_modulate.a += 0.2
			await TimerRoot.delay(0.5)
			
		await TimerRoot.delay(1)
		get_tree().change_scene_to_file("res://levels/main_menu.tscn")

func _on_mus_off_body_entered(body: Node2D) -> void:
	if body.name == 'player_perec' and !isDead:
		var tween = get_tree().create_tween()
		tween.tween_property($music, "volume_db", -80.0, 6)
		$mus_off.queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == 'player_perec':
		$Area2D.queue_free()
		$player_perec.canMove = false
		$player_perec.velocity.x = 0
		$player_perec.velocity.y = 0
		$paper.play()
		$hud/Control/paper.visible = true
		await get_tree().create_timer(3).timeout
		$pen.play()
		$hud/Control/paper.frame = 1
		await get_tree().create_timer(1).timeout
		$player_perec.canMove = true
		$hud/Control/paper.visible = false
		


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.name == 'player_perec':
		$Area2D2.queue_free()
		$hud/Control/paper.frame = 2
		$player_perec.canMove = false
		$player_perec.velocity.x = 0
		$player_perec.velocity.y = 0
		$paper.play()
		$hud/Control/paper.visible = true
		await get_tree().create_timer(3).timeout
		$pen.play()
		$hud/Control/paper.frame = 3
		await get_tree().create_timer(1).timeout
		$player_perec.canMove = true
		$hud/Control/paper.visible = false


func _on_area_2d_3_body_entered(body: Node2D) -> void:
	if body.name == 'player_perec':
		$music.stop()
		$Area2D3.queue_free()
		$hud/Control/paper.frame = 4
		$player_perec.canMove = false
		$player_perec.velocity.x = 0
		$player_perec.velocity.y = 0
		$paper.play()
		$hud/Control/paper.visible = true
		$AudioStreamPlayer.play()


func _on_audio_stream_player_finished() -> void:
	check_complete()
