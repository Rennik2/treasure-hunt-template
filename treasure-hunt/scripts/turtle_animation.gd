extends Node3D

var win = false
var win_screen_time = 0.0

func _process(delta: float) -> void:
	position.y = sin(Time.get_ticks_usec() / 500000.0) / 5.0 # bods emerald up and down
	rotation.y = Time.get_ticks_usec() / 300000.0 # rotates emerals around
	
	if win:
		# decreas transparency on win screen
		$"../../../WinScreen/TextureRect".modulate = Color(1.0, 1.0, 1.0 ,lerp(0, 1, win_screen_time))
		
		win_screen_time += delta / 2 # takes 2 sec for win screen to fully appear 

func _on_area_3d_body_entered(body: Node3D) -> void:
	# activates the win screen when emerald is found
	if body == $"../../../Player":
		$"../../../WinScreen".visible = true
		win = true 
		$turtle_lp_001.visible = false
		$"../../../WinScreen/AudioStreamPlayer2D".play()
