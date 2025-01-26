extends CanvasLayer


@onready var master_slider: HSlider = $Sliders/MasterVolume/MasterSlider
@onready var music_slider: HSlider = $Sliders/MusicVolume/MusicSlider
@onready var sfx_slider: HSlider = $Sliders/SFXVolume/SFXSlider
@onready var voice_slider: HSlider = $Sliders/VoiceVolume/VoiceSlider

@onready var sfx_tester: AudioStreamPlayer = $SFXTester
@onready var voice_tester: AudioStreamPlayer = $VoiceTester
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func slide_in() -> void:
	if not visible:
		animation_player.play("slide_in")
	
func slide_out() -> void:
	if visible:
		animation_player.play("slide_out")

func _ready() -> void:
	master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(2))
	voice_slider.value = db_to_linear(AudioServer.get_bus_volume_db(3))
	
	
	master_slider.value_changed.connect(_on_volume_slider_value_changed.bind(0))
	music_slider.value_changed.connect(_on_volume_slider_value_changed.bind(1))
	sfx_slider.value_changed.connect(_on_volume_slider_value_changed.bind(2))
	voice_slider.value_changed.connect(_on_volume_slider_value_changed.bind(3))
	
func _on_volume_slider_value_changed(slider_value: float, audio_bus_index: int) -> void:
	AudioServer.set_bus_volume_db(audio_bus_index, linear_to_db(slider_value))
	if audio_bus_index == 2 and not sfx_tester.playing:
		sfx_tester.play()
	if audio_bus_index == 3 and not voice_tester.playing:
		voice_tester.play()
