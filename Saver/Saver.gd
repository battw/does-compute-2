extends Node

const SAVE_PATH = "res://saves"
const save_resource = preload("res://Saver/SaveData.gd")
const Arrow = preload("res://Arrow/Arrow.tscn")
const Dot = preload("res://Dot/Dot.tscn")


func save(name):
	# create directory if necessary
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_PATH):
		var error = dir.make_dir(SAVE_PATH)
		if error != OK:
			print("failed to create save directory")
			return
	
	# collect save data
	var save = save_resource.new()
	for saver in get_tree().get_nodes_in_group("Savers"):	
		save.data[saver.name] = []
		print("Saving " + saver.name)
		for a in saver.get_children():
			save.data[saver.name].append(a.save())
	
	# save data to file
	var file_path = SAVE_PATH.plus_file(name + ".tres")
	var error = ResourceSaver.save(file_path, save)
	if error != OK:
		print("failed to save to path " + file_path + " (error code: " + str(error) + ")")
		return
	
	print("Game saved at " + file_path)
	
	
	
func load(name):
	print("loading save: " + name)
#	
	# load resource
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_PATH):
		print(SAVE_PATH + " does not exist. Failed to load file.")
		return
		
	var file_path = SAVE_PATH.plus_file(name + ".tres")
	var save = ResourceLoader.load(file_path)
	if !save:
		print("failed to load " + file_path)
		return
	
	for saver in get_tree().get_nodes_in_group("Savers"):
		for child in saver.get_children():
			saver.remove_child(child)
		
		if !save.data.has(saver.name):
			print("save.data has no key: " + saver.name)
			return
			
		print("loading " + saver.name)
		
		for data in save.data[saver.name]:
			var type = data.get("type")
			if !type:
				print("load data does not contain an instance type")
				return
			var a = get(type)
			if !a:
				print("unable to load object of type: " + type)
				print("type not recognised by Saver.gd")
				return
			a = a.instance()
			a.load(data)
			saver.add_child(a)
			
