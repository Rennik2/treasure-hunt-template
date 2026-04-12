extends RigidBody3D

var being_pushed = false
var direction

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if being_pushed:
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
		direction = Vector3.ZERO
		being_pushed = false
		print("push ended")
