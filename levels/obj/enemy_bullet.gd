extends CharacterBody2D

const SPEED = 500

func _ready() -> void:
	await TimerRoot.delay(6)
	queue_free()

func _physics_process(delta: float) -> void:
	position += transform.x * SPEED * delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == 'player_exe':
		body._damage()
		queue_free()
