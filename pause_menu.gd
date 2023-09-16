extends Control

var is_resume_press = false
var is_save_press   = false


func _on_resume_pressed():
	is_resume_press = true


func _on_save_pressed():
	is_save_press = true


func _on_quit_pressed():
	get_tree().quit()



func _on_sense_mouse_entered():
	$Save/LineEdit.visible = true


func _on_sense_mouse_exited():
	$Save/LineEdit.visible = false
