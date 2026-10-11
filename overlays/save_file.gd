extends Node

#SETTINGS
var fullScreen = true
var scanlines = true
var vsync = false
var lights = true

var music_volume = 0
var sfx_volume = 0

var progress:int = 0
var end = false

var saveData = "user://save.dat"
var accessTo = "user://unlock.dat"

func _ready():
	load_save()
	reload_all_setting()
	
func reload_setting(doThis:int):
	check(doThis)
	
func reload_all_setting():
	check(5)
			
func give_access():
	end = true
	var file = FileAccess.open(accessTo, FileAccess.WRITE)
	var save_file = important()
	file.store_var(save_file)

func save_data():
	var file = FileAccess.open(saveData, FileAccess.WRITE)
	var save_file = createData()
	file.store_var(save_file)
	
func load_save():
	var file = FileAccess.open(saveData, FileAccess.READ)
	if FileAccess.file_exists(saveData):
		var loaded_save = file.get_var()
		#SETTINGS
		fullScreen = loaded_save.FullScreen
		vsync = loaded_save.Vsync
		lights = loaded_save.FlashingLights
		
		scanlines = loaded_save.scanlines

		music_volume = loaded_save.MusicVolume
		sfx_volume = loaded_save.SoundVolume
		
		#LVL
		progress = loaded_save.progress
		end = loaded_save.end

func createData():
	var data = {
		#SETTINGS
		"FullScreen": fullScreen,
		"Vsync": vsync,
		"FlashingLights": lights,
		"scanlines": scanlines,
		
		"MusicVolume": music_volume,
		"SoundVolume": sfx_volume,
		#LVL
		"progress": progress,
		"end": end,
	}
	return data

func check(doThis): #CHECKS FOR APPLYING SETTINGS OR BOOTING GAME
	match doThis:
		0: #FULL SCREEN CHECK
			if fullScreen == true:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1: #VSYNC CHECK
			if vsync == true:
				DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
			else:
				DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		2: #MUSIC VOLUME
			AudioServer.set_bus_volume_db(1, music_volume)
			
			if music_volume > -24:
				AudioServer.set_bus_mute(1, false)
			else:
				AudioServer.set_bus_mute(1, true)
				
		3: #SFX VOLUME
			AudioServer.set_bus_volume_db(2, sfx_volume)
			
			if sfx_volume > -24:
				AudioServer.set_bus_mute(2, false)
			else:
				AudioServer.set_bus_mute(2, true)
		5: #LAST ALWAYS CHECKS EVERYTHING
			AudioServer.set_bus_volume_db(1, music_volume)
			AudioServer.set_bus_volume_db(2, sfx_volume)
			if fullScreen == true:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
				
			if vsync == true:
				DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
			else:
				DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func important():
	var data = {
		"case 1": true,
		"case 2": true,
		"case 3": true,
		"case 4": true,
		"case 5": true,
		"case 6": true,
		"case 7": true,
		"case 8": true,
		"case 9": true,
		"case 10": true,
	}
	return data
