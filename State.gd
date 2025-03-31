extends Node

@onready var mesh_instance : MeshInstance3D = $MeshInstance

var files : Dictionary
var last_edited: Dictionary
var textures : Dictionary
var images : Dictionary
var directory_path

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	for file_untyped in files :
		var file = files[file_untyped] as FileAccess
		var current_file_path = file.get_path()
		
		if !file.file_exists(current_file_path) :
			print(current_file_path + ": not found")
			return;
		
		if file.get_modified_time(current_file_path) != last_edited[file_untyped] : 
			
			last_edited[file_untyped] = file.get_modified_time(current_file_path)
			
			images[file_untyped] = Image.load_from_file(current_file_path)
			
			if !images[file_untyped] :
				print("no image")
			
			textures[file_untyped] = ImageTexture.create_from_image(images[file_untyped])
			
			var material = mesh_instance.get_active_material(0) as BaseMaterial3D
			
			if !material : 
				print("Material cast invalid?")
				return;
			
			if !textures[file_untyped] :
				print("no texture")
				return;
			
			if file_untyped.contains("lbedo") :
				material.albedo_texture = textures[file_untyped]

			elif file_untyped.contains("ormal") :
				material.normal_texture = textures[file_untyped]
				print("normal applied")

			elif file_untyped.contains("eight") :
				material.heightmap_texture = textures[file_untyped]

			elif file_untyped.contains("miss") :
				material.emission_texture = textures[file_untyped]

			elif file_untyped.contains("ough") :
				material.roughness_texture = textures[file_untyped]

			elif file_untyped.contains("etal") :
				material.metallic_texture = textures[file_untyped]


func _load_directory() -> void: 
	var filepaths = DirAccess.open(directory_path).get_files()
	
	for filename in filepaths :
		var fullpath = directory_path + "/" + filename
		print("file accessed: " + fullpath)
		var tempfile = FileAccess.open(fullpath, FileAccess.READ)
		
		if filename.split(".")[-1].contains("import") :
			continue
			
		
		files[filename.split(".")[0]] = tempfile
		tempfile.close()
		
		last_edited[filename.split(".")[0]] = 0
	pass

#func _load_file() -> File: 
	#var filepaths = DirAccess.open(current_file_path).get_files()
	#
#
	##file.close()
	#pass
	
func _on_file_dialog_dir_selected(dir: String) -> void:
	directory_path = dir
	_load_directory()
	pass # Replace with function body.

#func _on_file_dialog_file_selected(path: String) -> void:
	#current_file_path = path
	#_load_file()
	
	
#TODO 
#- scale mesh to match image ratio
#- support multiple textures (albedo, normal, roughness etc)
#- find a way to show different lighting setups at runtime
	#- possibly having multple scenes with different lighting
	#- or by allowing the user to control lights directly somehow
