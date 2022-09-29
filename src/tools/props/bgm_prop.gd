extends Spatial


var prop_id : int
var music : String
var custom_properties = {music = music, music_src = null}

#var m1 = preload("res://assets/music/Funky Disco.ogg")
#var m2 = preload("res://assets/music/Hau_oli City.ogg")
var music_source : AudioStreamOGGVorbis


onready var tree = $Properties/Tabs/TabContainer/Music/Tree
onready var music_player = $AudioStreamPlayer


func initialize():
	music == "Funky Disco"
	#music_source = m1
	custom_properties = {music = music, music_src = music_source}


func update_data(cp):
	music == cp.music
	music_source == cp.music_src


func edit_prop():
	$Properties.popup()


func _get_selected_music():
	var item = tree.get_selected()
	var selected_music = item.get_text(0)
	return selected_music


func _on_Tree_item_selected():
	music = _get_selected_music()
	#if music == "Funky Disco":
		#music_source = m1
	#elif music == "Hau_oli City":
		#music_source = m2
	custom_properties = {music = music, music_src = music_source}
	get_parent().update_prop_data(prop_id, translation, rotation, scale, custom_properties)


func _play_music():
	music_player.stream = music_source
	music_player.playing == true
	music_player.play()
	$Properties/Tabs/TabContainer/Music/Button.disabled
	$Properties/Tabs/TabContainer/Music/Button2.disabled == false
	$Properties/Tabs/TabContainer/Music/Button3.disabled == false

func _stop_music():
	music_player.stop()
	$Properties/Tabs/TabContainer/Music/Button.disabled == false
	$Properties/Tabs/TabContainer/Music/Button2.disabled == true
	$Properties/Tabs/TabContainer/Music/Button3.disabled == true
