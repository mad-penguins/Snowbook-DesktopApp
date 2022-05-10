extends Button

var register: bool = false


func _on_CheckButton_toggled(button_pressed: bool) -> void:
	register = button_pressed
	
	if button_pressed:
		text = 'Sign Up'
	else:
		text = 'Sign In'
