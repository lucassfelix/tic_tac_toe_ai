extends Node

var _audioStreamPool : Array
var _avaliablePool : Array
var _musicStream : AudioStreamMP3

func _ready():
	
	_musicStream = load("res://SoundFiles/BG_Music.mp3")
	
	var newMusicStream := AudioStreamPlayer.new()
	add_child(newMusicStream)
#	newMusicStream.volume_db = -15
	newMusicStream.stream = _musicStream
	newMusicStream.play()
	
	for i in range(10):
		var newAudioStream := _create_audio_stream(i)
		_audioStreamPool.append(newAudioStream)
		_avaliablePool.append(true)
	pass
	
func _create_audio_stream(var index : int) -> AudioStreamPlayer:
	var newAudioStream := AudioStreamPlayer.new()
	var _err := newAudioStream.connect("finished",self,"_on_Audio_Finished",[index])
	add_child(newAudioStream)
	return newAudioStream

func play(soundClip : AudioEvent) -> void:
	
	var audioStream : AudioStreamPlayer = null
	
	for i in range(_audioStreamPool.size()):
		if _avaliablePool[i]:
			_avaliablePool[i] = false
			audioStream = _audioStreamPool[i]
	
	if audioStream == null:
		audioStream = _create_audio_stream(_audioStreamPool.size())
		_audioStreamPool.append(audioStream)
		_avaliablePool.append(false)
		
			
	audioStream.stream = soundClip.WavAudioClip
	audioStream.volume_db = soundClip.volume_dB
	audioStream.pitch_scale = soundClip.pitch
	audioStream.play()
	
	

func _on_Audio_Finished(var index : int):
	_avaliablePool[index] = true
