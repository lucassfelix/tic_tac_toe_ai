extends Node


var _audioStreamPool : Array
var _usedStreamPool : Array
var _musicStream : AudioStreamMP3


func _ready():
	
	_musicStream = load("res://SoundFiles/BG_Music.mp3")
	
	var newMusicStream := AudioStreamPlayer.new()
	add_child(newMusicStream)
	newMusicStream.volume_db = -15
	newMusicStream.stream = _musicStream
	newMusicStream.play()
	
	for _i in range(3):
		var newAudioStream := createAudioStream()
		_audioStreamPool.insert(0,newAudioStream)
	pass
	
func createAudioStream() -> AudioStreamPlayer:
	var newAudioStream := AudioStreamPlayer.new()
	var err := newAudioStream.connect("finished",self,"_on_Audio_Finished")
	add_child(newAudioStream)
	return newAudioStream

func playSound(soundClip : AudioEvent) -> void:
	var audioStream : AudioStreamPlayer
	if _audioStreamPool.size() == 0:
		audioStream = createAudioStream()
	else:
		audioStream = _audioStreamPool.pop_back()
	audioStream.stream = soundClip.WavAudioClip
	audioStream.volume_db = soundClip.volume_dB
	audioStream.pitch_scale = soundClip.pitch
	audioStream.play()
	_usedStreamPool.append(audioStream)

func _on_Audio_Finished():
	_audioStreamPool.insert(0,_usedStreamPool.pop_back())
