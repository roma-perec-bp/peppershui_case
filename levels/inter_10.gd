extends Control

var display = ""
var current_char = 0
var cur_lenght = 0
var typedTxt = ""

var curPort:bool = true
var visible_port:bool = true
var mus_play:bool = true

var shake:bool = false

var dialRu:Array[String] = [
	'Ты был создан...',
	'...',
	'Какого моё предназначение?',
	'Ты...',
	'Идеален!',
	'?',
	'Ты сильнее...',
	'Твоя сила... так велика!',
	'То что мне нужно!',
	'Какого моё предназначение?',
	'Ты должен умереть...',
	'Чтобы твоя сила передалась мне...',
	'Я не хочу!',
	'Я хочу охотиться как все остальные!',
	'...',
	'Видимо придётся все решать по плохому...',
	''
]

var dialPortait:Array[bool] = [
	false,
	false,
	true,
	false,
	false,
	true,
	false,
	false,
	false,
	true,
	false,
	false,
	true,
	true,
	false,
	false,
	false
]

var dialFrame:Array[int] = [
	0,
	0,
	8,
	0,
	0,
	8,
	0,
	0,
	0,
	8,
	0,
	0,
	8,
	8,
	0,
	0,
	0
]

var curIndex:int = 0

var dialogueOpened:bool = false;
var dialogueStarted:bool = false;
var dialogueEnded:bool = false;

var showDialBG:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$portrait.play("RESET")
	$p2_spr.visible = false
	$p1_spr.visible = false
	if mus_play:
		var tween = get_tree().create_tween()
		tween.tween_property($music, "volume_db", -6, 3)
		$music.play()
	await TimerRoot.delay(3)
	var tweenBye = create_tween()	
	tweenBye.tween_property($hide_bg, "position:y", 500, 1)
		
	dialogueOpened = true
	_changeTxt(dialRu[curIndex])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shake:
		$bg.position.x = randf_range(-10,10)
		$bg.position.y = randf_range(-10,10)
		
		$per.offset.x = randf_range(-10,10)
		$per.offset.y = randf_range(-10,10)
	
	if Input.is_action_just_pressed("ui_accept"):
		if dialogueOpened:
			if dialogueEnded:
				curIndex += 1
					
				if dialRu[curIndex] == '':
					dialogueOpened = false
					
					var tween = get_tree().create_tween()
					tween.tween_property($music, "volume_db", -80.0, 3)
	
					for n in 5:
						$end.self_modulate.a += 0.2
						await TimerRoot.delay(0.25)
						
					await TimerRoot.delay(3)
					var tween2 = get_tree().create_tween()
					tween2.tween_property($week6, "volume_db", -6, 3)
					
					$week6.play()
					
					for n in 5:
						$bg.self_modulate.a += 0.2
						await TimerRoot.delay(0.5)
						
					await TimerRoot.delay(1)
					
					for n in 5:
						$per.self_modulate.a += 0.2
						await TimerRoot.delay(0.25)
						
					await TimerRoot.delay(1)
					$sound.play()
					await TimerRoot.delay(0.57)
					$per.play("trans")
					await TimerRoot.delay(1.1)
					$per.play("shake")
					await TimerRoot.delay(0.67)
					$per.play("shake")
					await TimerRoot.delay(0.7)
					$per.play("trans_final")
					shake = true
					await TimerRoot.delay(0.2)
					$per.play("final")
					await TimerRoot.delay(1)
					var tweenEnd = get_tree().create_tween()
					tweenEnd.tween_property($end_bright, "self_modulate:a", 1, 2)
					await TimerRoot.delay(3)
					var tweenMus = get_tree().create_tween()
					tweenMus.tween_property($week6, "volume_db", -80.0, 1.5)
				else:
					_changeTxt(dialRu[curIndex])
					
			elif dialogueStarted:
				_skip_text()

func _changeTxt(text: String):
	$dial_box.visible = showDialBG
	
	if curPort != dialPortait[curIndex]:
		curPort = dialPortait[curIndex]
		if curPort == true:
			$p1_spr.frame = dialFrame[curIndex]
			$portrait.play("player_port")
			if visible_port:
				$p1_spr.visible = true
				$p2_spr.visible = false
		else:
			$p2_spr.frame = dialFrame[curIndex]
			$portrait.play("guest_port")
			
			if visible_port:
				$p2_spr.visible = true
				$p1_spr.visible = false
	
	dialogueStarted = true
	dialogueEnded = false
	display = ""
	current_char = 0
	cur_lenght = len(text)
	typedTxt = text
	
	$nextCharacter.set_wait_time(0.05)
	$nextCharacter.start()
	
func _skip_text():
	dialogueEnded = true
	$nextCharacter.stop()
	$dialogueTxt.text = dialRu[curIndex]

func _on_next_character_timeout() -> void:
	if current_char < cur_lenght:
		var next_char = typedTxt[current_char]
		display += next_char
		
		$dialogueTxt.text = display
		current_char += 1
		$talk.pitch_scale = randf_range(0.6,1.0)
		$talk.play()
	else:
		dialogueEnded = true
		$nextCharacter.stop()


func _on_sound_finished() -> void:
	get_tree().change_scene_to_file("res://levels/lvl_10.tscn")
