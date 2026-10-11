extends Control

signal back

var inOptions:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reload_checkboxes()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel") and inOptions:
		inOptions = false
		self.visible = false
		emit_signal("back")

func reload_checkboxes():
	$sync.button_pressed = SaveFile.vsync
	$light.button_pressed = SaveFile.lights
	$screen.button_pressed = SaveFile.fullScreen
	$scanlin.button_pressed = SaveFile.scanlines
	
	$mus.value = SaveFile.music_volume
	$sound.value = SaveFile.sfx_volume


func _on_mus_value_changed(value: float) -> void:
	SaveFile.music_volume = value
	SaveFile.save_data()
	SaveFile.reload_setting(2)


func _on_sound_value_changed(value: float) -> void:
	SaveFile.sfx_volume = value
	SaveFile.save_data()
	SaveFile.reload_setting(3)


func _on_light_toggled(toggled_on: bool) -> void:
	SaveFile.lights = toggled_on
	SaveFile.save_data()


func _on_screen_toggled(toggled_on: bool) -> void:
	SaveFile.fullScreen = toggled_on
	SaveFile.save_data()
	SaveFile.reload_setting(0)


func _on_sync_toggled(toggled_on: bool) -> void:
	SaveFile.vsync = toggled_on
	SaveFile.save_data()
	SaveFile.reload_setting(1)


func _on_scanlin_toggled(toggled_on: bool) -> void:
	SaveFile.scanlines = toggled_on
	SaveFile.save_data()
	Scanlines.changeScan()


func _on_exit_pressed() -> void:
	if inOptions:
		inOptions = false
		self.visible = false
		emit_signal("back")
