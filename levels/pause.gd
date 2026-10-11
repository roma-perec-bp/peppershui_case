extends Control

var trans:bool = false
var canDo = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func pause():
	await get_tree().create_timer(0.1).timeout
	canDo = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:		
	if Input.is_action_just_pressed("ui_cancel") and canDo:
		if trans: return
		canDo = false
		self.visible = false
		get_tree().paused = false
		TimerRoot.set_paused(false)


func _on_resume_pressed() -> void:
	if canDo:
		if trans: return
		canDo = false
		self.visible = false
		get_tree().paused = false
		TimerRoot.set_paused(false)


func _on_options_pressed() -> void:
	if canDo:
		if trans: return
		canDo = false
		$OptionMenu.inOptions = true
		$OptionMenu.visible = true


func _on_exit_pressed() -> void:
	if canDo:
		if trans: return
		canDo = false
		trans = true
		$ColorRect2.self_modulate.a = 0.2
		await get_tree().create_timer(0.6).timeout
		$ColorRect2.self_modulate.a = 0.4
		await get_tree().create_timer(0.6).timeout
		$ColorRect2.self_modulate.a = 0.6
		await get_tree().create_timer(0.6).timeout
		$ColorRect2.self_modulate.a = 0.8
		await get_tree().create_timer(0.6).timeout
		$ColorRect2.self_modulate.a = 1
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://levels/main_menu.tscn")


func _on_option_menu_back() -> void:
	canDo = true
