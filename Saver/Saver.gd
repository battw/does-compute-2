extends Node

const SAVE_PATH = "res://saves"
const save_resource = preload("res://Saver/SaveData.gd")
const Arrow = preload("res://Arrow/Arrow.tscn")



func save(name):
	# create directory if necessary
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_PATH):
		var error = dir.make_dir(SAVE_PATH)
		if error != OK:
			print("failed to create save directory")
			return
	
	# collect save data
	var save_data = save_resource.new()
	save_data.data["Arrows"] = []
	var arrows = get_tree().root.find_node("Arrows", true, false)
	if !arrows:
		print("failed to save. can't find arrows node to fetch arrows from")
		return
		
	for a in arrows.get_children():
		save_data.data["Arrows"].append(a.save())
	
	# save data to file
	var file_path = SAVE_PATH.plus_file(name + ".tres")
	var error = ResourceSaver.save(file_path, save_data)
	if error != OK:
		print("failed to save to path " + file_path + " (error code: " + str(error) + ")")
		return
	
	print("Game saved at " + file_path)
	
func load(name):
	print("loading " + name)
	var new_arrows = Node.new()
	new_arrows.name = "Arrows"
	# load resource
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_PATH):
		print(SAVE_PATH + " does not exist. Failed to load file.")
		return
		
	var file_path = SAVE_PATH.plus_file(name + ".tres")
	var save_data = ResourceLoader.load(file_path)
	if !save_data:
		print("failed to load " + file_path)
		return
		
	for arrow_data in save_data.data["Arrows"]:
		print(arrow_data)
		var a = Arrow.instance()
		a.load(arrow_data)
		new_arrows.add_child(a)
		
	var current_arrows = get_tree().root.find_node("Arrows", true, false)
	if !current_arrows:
		print("failed to load save. arrows node not in tree.")
		return
	
	for child in current_arrows.get_children():
		current_arrows.remove_child(child)
	current_arrows.replace_by(new_arrows)
		
	