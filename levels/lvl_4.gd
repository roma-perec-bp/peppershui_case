extends Node2D

var collect:int = 0
var canPause:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$player_perec.canMove = false
	$player_perec.spr.play("default-front")
	$hud/Control/AnimationPlayer.play("new_animation")
	await TimerRoot.delay(5)
	canPause = true
	$trans.play()
	$hud/Control/Label.visible = false
	$hud/Control/name.visible = true
	$hud/Control/collect.visible = true
	$player_perec.canMove = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape") and canPause:
		get_tree().paused = true
		TimerRoot.set_paused(true)
		$hud/pause.pause()
		$hud/pause.visible = true

#legs
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == 'player_perec':
		$collect.play()
		collect += 1
		check_complete()
		$hud/Control/collect.text = str(collect) + '/6'
		
		match (collect):
			1:
				$collect2.play()
				$part.position.x = $target1.position.x 
				$part.position.y = $target1.position.y
			2:
				$collect2.play()
				$part.position.x = $target2.position.x 
				$part.position.y = $target2.position.y
			3:
				$collect2.play()
				$part.position.x = $target3.position.x 
				$part.position.y = $target3.position.y
			4:
				$collect2.play()
				$part.position.x = $target4.position.x 
				$part.position.y = $target4.position.y
			5:
				$collect2.play()
				$part.position.x = $target5.position.x 
				$part.position.y = $target5.position.y
		
func check_complete():
	if collect == 6:
		canPause = false
		if SaveFile.progress < 4:
			SaveFile.progress = 4
			SaveFile.save_data()
			
		$music.stop()
		$cut.play()
		$player_perec.canMove = false
		$hud/end.visible = true
		$hud/end/AnimationPlayer.play("new_animation")


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.name == 'player_perec':
		$collect.play()
		$cone.visible = false
		$player_perec.cone.visible = true
		collect += 1
		check_complete()
		$hud/Control/collect.text = str(collect) + '/4'
		$cone.queue_free()


func _on_area_2d_3_body_entered(body: Node2D) -> void:
	if body.name == 'player_perec':
		$collect.play()
		$head.visible = false
		$player_perec.head.visible = true
		collect += 1
		check_complete()
		$hud/Control/collect.text = str(collect) + '/4'
		$head.queue_free()
		
func _on_area_2d_4_body_entered(body: Node2D) -> void:
	if body.name == 'player_perec':
		$collect.play()
		$body.visible = false
		$player_perec.body.visible = true
		collect += 1
		check_complete()
		$hud/Control/collect.text = str(collect) + '/4'
		$body.queue_free()


func _on_cut_finished() -> void:
	$end.play()
	$hud/win.visible = true
	$hud/win/AnimationPlayer.play("end")
		
	await TimerRoot.delay(4)
	get_tree().change_scene_to_file("res://levels/inter_5.tscn")
