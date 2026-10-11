extends CanvasLayer

var markers:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Control/scan.visible = SaveFile.scanlines


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func changeScan():
	$Control/scan.visible = SaveFile.scanlines
