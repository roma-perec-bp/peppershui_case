extends CharacterBody2D

var splash=load("res://levels/obj/splash.tscn")

func _ready() -> void:
	velocity.y = -666
	await TimerRoot.delay(5)
	queue_free()
	
func _physics_process(delta: float) -> void:
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == 'target':
		body.damage()
		
		var inst = splash.instantiate()
		inst.position = global_position
		get_parent().add_child(inst)
	
		queue_free()
