extends Node2D

var collect:int = 0
var canPause:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$hud/Control/AnimationPlayer.play("new_animation")
	await TimerRoot.delay(5)
	canPause = true
	$trans.play()
	$hud/Control/Label.visible = false
	$hud/Control/name.visible = true
	$hud/Control/collect.visible = true
	$player_perec.canMove = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape") and canPause:
		get_tree().paused = true
		TimerRoot.set_paused(true)
		$hud/pause.pause()
		$hud/pause.visible = true

#legs
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == 'player_perec':
		$collect.play()
		$legs.visible = false
		$player_perec.legs.visible = true
		collect += 1
		check_complete()
		$hud/Control/collect.text = str(collect) + '/4'
		$legs.queue_free()
		
func check_complete():
	if collect == 4:
		canPause = false
		if SaveFile.progress < 1:
			SaveFile.progress = 1
			SaveFile.save_data()
		
		$music.stop()
		$player_perec.canMove = false
		
		$player_perec.legs.play("default-front")
		$player_perec.body.play("default-front")
		$player_perec.head.play("default-front")
		$player_perec.cone.play("default-front")
		$player_perec.head.play("default-front")
		$player_perec.eye.play("default-front")
	
		await TimerRoot.delay(1)
		$end.play()
		$hud/win.visible = true
		$hud/win/AnimationPlayer.play("end")
		
		await TimerRoot.delay(4)
		get_tree().change_scene_to_file("res://levels/inter_2.tscn")


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
