extends Area2D
signal hit

export var speed = 400 # pixels per sec
var screen_size
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	#hide()
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
		
	if velocity.x != 0:
		$AnimatedSprite.animation = 'walk'
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = 'up'
		$AnimatedSprite.flip_v = velocity.y > 0
		
		
	$AnimatedSprite.rotation_degrees = 0
	# up right	
	if velocity.x > 0 and velocity.y < 0:	
		$AnimatedSprite.rotation_degrees = 45
		
	# up left
	elif velocity.x < 0 and velocity.y < 0:	
		$AnimatedSprite.rotation_degrees = -45
		
	# down right
	elif velocity.x < 0 and velocity.y > 0:	
		$AnimatedSprite.rotation_degrees = -135	
	# down left
	elif velocity.x > 0 and velocity.y > 0:	
		$AnimatedSprite.rotation_degrees = 135	
		
	
	var height = 135 / 2 
	var width = 108 / 2 # scaled
	var offsetH = width / 2
	var offsetV = height / 2
	position += velocity * delta
	position.x = clamp(position.x, offsetH, screen_size.x - offsetH)
	position.y = clamp(position.y, offsetV, screen_size.y - offsetV)
		
#	pass


func _on_Player_body_entered(body):
	#hide() # Player disappears after being hit.
	emit_signal("hit")
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
