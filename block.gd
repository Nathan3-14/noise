extends StaticBody3D

var selected = false
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if selected:
		$Selected.visible = true
		selected = false
	else: $Selected.visible = false
