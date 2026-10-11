extends Control

var curState:int = 0
var curSelectedMain:int = 1
var curSelectedLvl:int = 0
var trans:bool = true

@export var lvl_boxes: Array[Node] = []

var saveData = "C:/Users/"+OS.get_environment("USERNAME")+'/AppData/Roaming/OgreCrew/Pepper-s-Files/unlock.sol'

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !FileAccess.file_exists(saveData):
		get_tree().quit()
	
	get_tree().paused = false
	TimerRoot.set_paused(false)
	Scanlines.changeScan()
	
	if SaveFile.progress < 1:
		$Lvl_Select/lvl2.modulate.r = 0.3
		$Lvl_Select/lvl2.modulate.g = 0.3
		$Lvl_Select/lvl2.modulate.b = 0.3
		
	if SaveFile.progress < 2:
		$Lvl_Select/lvl3.modulate.r = 0.3
		$Lvl_Select/lvl3.modulate.g = 0.3
		$Lvl_Select/lvl3.modulate.b = 0.3
		
	if SaveFile.progress < 3:
		$Lvl_Select/lvl4.modulate.r = 0.3
		$Lvl_Select/lvl4.modulate.g = 0.3
		$Lvl_Select/lvl4.modulate.b = 0.3
		
	if SaveFile.progress < 4:
		$Lvl_Select/lvl5.modulate.r = 0.3
		$Lvl_Select/lvl5.modulate.g = 0.3
		$Lvl_Select/lvl5.modulate.b = 0.3
		
	if SaveFile.progress < 5:
		$Lvl_Select/lvl6.modulate.r = 0.3
		$Lvl_Select/lvl6.modulate.g = 0.3
		$Lvl_Select/lvl6.modulate.b = 0.3
		
	if SaveFile.progress < 6:
		$Lvl_Select/lvl7.modulate.r = 0.3
		$Lvl_Select/lvl7.modulate.g = 0.3
		$Lvl_Select/lvl7.modulate.b = 0.3
		
	if SaveFile.progress < 7:
		$Lvl_Select/lvl8.modulate.r = 0.3
		$Lvl_Select/lvl8.modulate.g = 0.3
		$Lvl_Select/lvl8.modulate.b = 0.3
		
	if SaveFile.progress < 8:
		$Lvl_Select/lvl9.modulate.r = 0.3
		$Lvl_Select/lvl9.modulate.g = 0.3
		$Lvl_Select/lvl9.modulate.b = 0.3
		
	if SaveFile.progress < 9:
		$Lvl_Select/lvl10.modulate.r = 0.3
		$Lvl_Select/lvl10.modulate.g = 0.3
		$Lvl_Select/lvl10.modulate.b = 0.3
	
	change_selection_main(0)
	$AnimationPlayer.play("intro")
	await TimerRoot.delay(5)
	$mus.play()
	await TimerRoot.delay(2)
	trans = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left") and not trans and curState == 0:
		change_selection_main(-1)
			
	if Input.is_action_just_pressed("right") and not trans and curState == 0:
		change_selection_main(1)
		
	if Input.is_action_just_pressed("ui_accept") and not trans and curState == 0:
		select_state()
	elif Input.is_action_just_pressed("ui_accept") and not trans and curState == 1:
		select_level()
		$selected.play()
		
	if Input.is_action_just_pressed("ui_cancel") and not trans and curState == 1:
		$selected.play()
		curState = 0
		$Menu.visible = true
		$Lvl_Select.visible = false
		
	var add:int = 0
	
	if Input.is_action_just_pressed("left") and not trans and curState == 1:
		add = -1
	elif Input.is_action_just_pressed("right") and not trans and curState == 1:
		add = 1
		
	if add != 0:
		var oldRow:int = floor(curSelectedLvl / 5)
		var rowSize:int = int(min(5, lvl_boxes.size() - oldRow * 5))
		
		curSelectedLvl += add;
		var curRow:int = floor(curSelectedLvl / 5)
		if curSelectedLvl >= lvl_boxes.size(): curRow + 1
		
		if curRow != oldRow:
			if curRow < oldRow: 
				curSelectedLvl = curSelectedLvl + rowSize
			else: 
				curSelectedLvl = curSelectedLvl - rowSize
				
		if curSelectedLvl == -1:
			curSelectedLvl = 4
				
		change_selection_lvl()
		
	if(lvl_boxes.size() > 5):
		var add2:int = 0
		if Input.is_action_just_pressed("up") and not trans and curState == 1: add2 = -1
		elif Input.is_action_just_pressed("down") and not trans and curState == 1: add2 = 1

		if add2 != 0:
			var diff:int = curSelectedLvl - (floor(curSelectedLvl / 5) * 5);
			curSelectedLvl += add2 * 5;

			if curSelectedLvl < 0:
				curSelectedLvl += ceil(lvl_boxes.size() / 5) * 5;
				if curSelectedLvl >= lvl_boxes.size(): curSelectedLvl -= 5;

			if curSelectedLvl >= lvl_boxes.size():
				curSelectedLvl = diff;

			change_selection_lvl();

var id:int = 0
func change_selection_lvl():
	id = 0
	$selected.play()
	for target: Node in lvl_boxes:
		target.modulate.a = 0.6
		
	for target: Node in lvl_boxes:
		id += 1
		if id == curSelectedLvl + 1:
			target.modulate.a = 1
	

func change_selection_main(integer:int):
	if integer != 0: $selected.play()
	
	curSelectedMain += integer
		
	if curSelectedMain == -1:
		curSelectedMain = 2
		
	if curSelectedMain == 3:
		curSelectedMain = 0
			
	match(curSelectedMain):
		0:
			$Menu/START.modulate.a = 0.6
			$Menu/OPTIONS.modulate.a = 0.6
			$Menu/EXIT.modulate.a = 1
		1:
			$Menu/START.modulate.a = 1
			$Menu/OPTIONS.modulate.a = 0.6
			$Menu/EXIT.modulate.a = 0.6
		2:
			$Menu/START.modulate.a = 0.6
			$Menu/OPTIONS.modulate.a = 1
			$Menu/EXIT.modulate.a = 0.6

func select_level():
	if SaveFile.progress < curSelectedLvl:
		return
		
	trans = true
	$fade.visible = false
	$fade_end.visible = true
	$AnimationPlayer.play("end")
	var tween = get_tree().create_tween()
	tween.tween_property($mus, "volume_db", -80.0, 3)
	

func select_state():
	match (curSelectedMain):
		0:
			$selected.play()
			trans = true
			$fade.visible = false
			$fade_end.visible = true
			$AnimationPlayer.play("end")
			var tween = get_tree().create_tween()
			tween.tween_property($mus, "volume_db", -80.0, 3)
		1:
			curState = 1
			$Menu.visible = false
			$Lvl_Select.visible = true
			change_selection_lvl()
		2:
			$selected.play()
			trans = true
			$OptionMenu.inOptions = true
			$OptionMenu.visible = true


func _on_option_menu_back() -> void:
	$selected.play()
	trans = false


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == 'end':
		if curState == 1:
			get_tree().change_scene_to_file("res://levels/inter_"+ str(curSelectedLvl + 1) + ".tscn")
		else:
			get_tree().quit()
