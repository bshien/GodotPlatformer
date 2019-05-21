extends KinematicBody2D


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
#export var accelTimeG := 0.2
#export var decelTimeG := 0.1
#export var turnTimeG := 0.1
#export var accelTimeA := 0.2
#export var decelTimeA := 0.4
#export var turnTimeA := 0.1


#export var cancels := {
#	"Idle": false,
#	"Fall": false,
#	"Attack": false,
#	"Jump": false
#}

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
	

		#animation runs on a different frame system than the script
		#I set the canFall value in animation and it kept getting cancelled 
		#do state checks in script, not animation, as they are faster here (constant vs variable update)
		#canFall = false
		#canIdle = false
		playAnim("playerLightAttack", false, false)
		print("Can idle is now ", canIdle)
	
	
	#movement calculations
	var moveTimes = groundMvmtTime if onFloor else airMvmtTime
	
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


#func _on_AnimationPlayer_animation_finished(anim_name):
#	canIdle = true
#	canFall = true

#play animation and reset vars
func playAnim(animName: String, fall:=true, idle:=true):
	animP.play(animName)
	canIdle = idle
	canFall = fall