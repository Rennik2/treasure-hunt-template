extends RigidBody3D

var being_pushed = false
var on_top = false
var direction

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $"../Player".global_position.y > global_position.y and being_pushed:
		# locks cubes rotation if you are standing on top of the cube
		on_top = true
		lock_rotation = true
	else:
		on_top = false
		lock_rotation = false
	
	if being_pushed and not on_top:
		direction = $"../Player".direction # input direction of the player 
		apply_central_force(direction * 10) # apllies fore in the direction the player is going



# player started pushing the box
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == $"../Player":
		being_pushed = true
		print("push started")
		 
#player stopped pushing the box
func _on_area_3d_body_exited(body: Node3D) -> void:
	if body == $"../Player":
		being_pushed = false
		print("push ended")
