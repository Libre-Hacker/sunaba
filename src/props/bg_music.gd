extends Spatial


var prop_id : int
var music : String
var custom_properties = {music = music, music_src = null}

#var m1 = preload("res://assets/music/Funky Disco.ogg")
var music_source : AudioStreamOGGVorbis

onready var music_player = $AudioStreamPlayer


func initialize():
	music == custom_properties.music
	music_source = custom_properties.music_src
	music_player.stream = music_source
	music_player.playing == true
	music_player.play()
