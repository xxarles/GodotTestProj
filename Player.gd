extends Area2D

signal hit
export var speed = 100  # How fast the player will move (pixels/sec).

var screen_size  # Size of the game window.
var velocity = Vector2()  # The player's movement vector.
var momentum = Vector2()  # The player's movement vector.

func _ready():
	hide()
	screen_size = get_viewport_rect().size

func _process(delta):
	if Input.is_action_pressed("ui_right"):
		momentum.x += 1
	if Input.is_action_pressed("ui_left"):
		momentum.x -= 1
	if Input.is_action_pressed("ui_down"):
		momentum.y += 1
	if Input.is_action_pressed("ui_up"):
		momentum.y -= 1
		
	
	if momentum.length() > 0.1:
		velocity = momentum * speed
		$AnimatedSprite.play()
	else:
		if abs(momentum.x) <0.1:
			velocity.x = 0
		if abs(momentum.y) <0.1:
			velocity.y = 0
		
		$AnimatedSprite.stop()
		
	if abs(momentum.x) > 0.1:
		print(momentum.x)
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		# See the note below about boolean assignment
		$AnimatedSprite.flip_h = momentum.x < 0
	
	elif abs(momentum.y) > 0.1:
		print(momentum.y)
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = momentum.y > 0
	
	momentum.x -= abs(momentum.x)*momentum.x * 0.01 + momentum.x*0.05 + 0.01*abs(momentum.x)/(momentum.x+1e-5)
	momentum.y -= abs(momentum.y)*momentum.y * 0.01 + momentum.y*0.05+ 0.01*abs(momentum.y)/(momentum.y+1e-5)
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false


func _on_Player_body_entered(body):
	hide()  # Player disappears after being hit.
	emit_signal("hit")
	print("HIT")
	$CollisionShape2D.set_deferred("disabled", true)




