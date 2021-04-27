extends Node

export (PackedScene) var Mob
export var score = 0 

func _ready():
	randomize()


func _on_MobTimer_timeout():
	# Choose a random location on Path2D.
	$MobPath/MobSpawnLocation.offset = randi()
	# Create a Mob instance and add it to the scene.
	var mob = Mob.instance()
	add_child(mob)
	# Set the mob's direction perpendicular to the path direction.
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	# Set the mob's position to a random location.
	mob.position = $MobPath/MobSpawnLocation.position
	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	# Set the velocity (speed & direction).
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)



func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	$HUD.show_message("")
	$Player.start($StartPosition.position)

func _on_ScoreTimer_timeout():
	$HUD.update_score(score)
	score += 1
	
func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	get_tree().call_group("mobs", "queue_free")
	$HUD.show_game_over()


func new_game():
	score = 0
	
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
