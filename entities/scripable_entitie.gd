extends Node3D

@export var custom_script : String = ""

@export var fgd_block = ["lua"] 

#var lua : LuaAPI

func _start():
	#lua = LuaAPI.new()
	if custom_script != "":
		print(custom_script)
		#var scrpt = lua.do_string(custom_script)
		#if scrpt != null:
			#print(scrpt)
		#lua.call_function("Start", [])
	else :
		printerr("Script is null")
