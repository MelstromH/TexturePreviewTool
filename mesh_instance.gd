extends MeshInstance3D

var counter : int = 500
var increasing : bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if counter > 1000 && increasing :
		increasing = false
	
	if counter < 0 && !increasing :  
		increasing = true
		
	if increasing :
		counter += 1
		rotate_y(0.001)
	else : 
		counter -= 1
		rotate_y(-0.001)
	
	#print(counter)
	
	
	pass
