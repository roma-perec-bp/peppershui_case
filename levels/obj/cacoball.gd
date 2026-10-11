extends CharacterBody2D

var speed = 500
var buh:int = 0
var isDed:bool = false

func _ready() -> void:
	$AnimationPlayer.play("new_animation")
	velocity.x = randi_range(-1, 1)
	velocity.y = 1

func _physics_process(delta: float) -> void:
	# Move the sprite
	global_position += velocity * speed * delta
	
	# Handle bouncing off horizontal screen edges
	if !isDed:
		if global_position.x < 0:
			print('buh')
			buh += 1
			velocity.x *= -1
			$bop.play()
			
		# Handle bouncing off vertical screen edges
		if global_position.y < 0:
			print('buh')
			velocity.y *= -1
			buh += 1
			$bop.play()
			
		if global_position.x > 640:
			print('buh')
			buh += 1
			velocity.x *= -1
			$bop.play()
			
		# Handle bouncing off vertical screen edges
		if global_position.y > 480:
			print('buh')
			velocity.y *= -1
			buh += 1
			$bop.play()
	
	if buh == 8 and isDed == false:
		death()
		
func death():
	isDed = true
	velocity.x = 0
	velocity.y = 0
	$Sprite2D.visible = false
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play("default")

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == 'player_exe' and !isDed:
		body._damage()
		body._damage()
		body._damage()
		body._damage()
		body._damage()
		body._damage()
		death()
