extends KinematicBody2D

#attack still broken
const Utils = preload("res://Scripts/Utils.gd")

export var runSpeed : float = 220

export var jumpHeight : float = 40
export var jumpTime : float = 0.3
export var canIdle := true
export var canFall := true


var velocity := Vector2()
#Acceleration/strafing
export var groundMvmtTime := {
	accel = 0.2,
	decel = 0.1,
	turn = 0.3
}
export var airMvmtTime := {
	accel = 0.4,
	decel = 0.2,
	turn = 0.5
}

#Child nodes
onready var animP : AnimationPlayer = $AnimationPlayer
onready var sprite : Sprite = $Sprite

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var move = 0
	
	var gravity = 2*jumpHeight/(jumpTime*jumpTime)
	velocity.y += gravity*delta

	var onFloor = is_on_floor()
	var onWall = is_on_wall()

	#movement
	if(Input.is_action_pressed("ui_right")):
		move += 1
		#sprite.flip_h = velocity.x < 0
		sprite.flip_h = false
		if onFloor:
			playAnim("playerRun")
	elif Input.is_action_pressed("ui_left"):
		move -= 1
		#sprite.flip_h = velocity.x < 0
		sprite.flip_h = true
		if onFloor:
			playAnim("playerRun")
	else:
		move = 0
		if canIdle:
			playAnim("playerIdle")

	if Input.is_action_just_pressed("jump"):
		#Ground jump
		if onFloor:
			velocity.y = -2*jumpHeight/jumpTime
			playAnim("playerJump")
		#Wall jump
		elif onWall:
			canFall = false
			playAnim("playerFlip")
			velocity.y = -2*jumpHeight/jumpTime

	#falling animation
	if !onFloor and velocity.y > 0 and canFall:
		playAnim("playerFalling")

	#attack animations
	if Input.is_action_just_pressed("light attack") and canFall:
		playAnim("playerLightAttack")
	
		#animation runs on a different frame system than the script

	#movement calculations
	var moveTimes = groundMvmtTime if is_on_floor() else airMvmtTime
	
	var accelX : float
	#Calculate acceleration
	#Moving forward
	if velocity.x * move >  0:
		accelX = runSpeed/moveTimes.accel
	#Stopping
	elif move == 0:
		accelX = runSpeed/moveTimes.decel
	#Turning around
	else:
		accelX = runSpeed/moveTimes.turn
	#How fast player wants to go based on input
	var targetSpeed = move*runSpeed
	velocity.x = Utils.moveTowards(velocity.x, targetSpeed, accelX*delta)
	
	# -y is up, +y is down
	velocity = move_and_slide(velocity, Vector2(0, -1))

#play animation and reset vars
func playAnim(animName: String, fall:=true, idle:=true):
	animP.play(animName)
	canIdle = idle
	canFall = fall