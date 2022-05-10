extends Control

signal LoginSpace_ButtonPressed(username, password, register)


func clearPassword():
	$CenterContainer/VBoxContainer/HBoxContainer2/LineEdit.clear()


func _on_Button_pressed() -> void:
	var username = $CenterContainer/VBoxContainer/HBoxContainer/LineEdit.text
	var password = $CenterContainer/VBoxContainer/HBoxContainer2/LineEdit.text
	var register = $CenterContainer/VBoxContainer/CheckButton.pressed
	
	emit_signal("LoginSpace_ButtonPressed", username, password, register)
