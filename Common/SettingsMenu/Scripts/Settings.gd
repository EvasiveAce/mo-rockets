extends CanvasLayer

var open = false
var just_opened = false
var stringToUse = "%.2fx"

func _on_volume_value_changed(value:int) -> void:
	var audio_value = value / 100.0
	AudioServer.set_bus_volume_db(0, linear_to_db(audio_value))
	$TabContainer/Settings/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Volume/LineEdit.text = str(value)
	
func _on_line_edit_text_submitted(new_text:String) -> void:
	$TabContainer/Settings/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Volume.value = int(new_text)


func _ready():
	if Constants.mobile:
		$MenuButton.visible = true
	visible = false
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func _process(_delta: float) -> void:
	%RecordAlt.text = str(Constants.highestAltitude) + ' m' if Constants.highestAltitude < 100000 else str(Constants.highestAltitude/1000) + ' km'
	%RecordLaunch.text = str(Constants.amountOfLaunches)
	%RecordMult.text = stringToUse % [Constants.statMultiplier]
	if just_opened:
		just_opened = false
		return
	if Input.is_action_just_pressed('pause') and !Constants.transitioning and open:
		Settings._hide_settings()


func _show_settings():
	get_tree().paused = true
	visible = true
	open = true
	just_opened = true
	$AudioStreamPlayer.play()

func _hide_settings():
	Constants._play_out()
	$TabContainer/Settings/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/Panel/MarginContainer/ImportExportText.text = ''
	$TabContainer/Settings/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ValidationCode.text = ''
	visible = false
	open = false
	get_tree().paused = false

func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://Common/AssemblyStage/Scenes/AssemblyStage.tscn")


func _on_export_pressed() -> void:
	$TabContainer/Settings/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/Panel/MarginContainer/ImportExportText.text = Constants._export_game()
	DisplayServer.clipboard_set($TabContainer/Settings/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/Panel/MarginContainer/ImportExportText.text)
	$TabContainer/Settings/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ValidationCode.modulate = '00ff00'
	$TabContainer/Settings/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ValidationCode.text = 'Success! Save code copied to clipboard.'

func _on_input_pressed() -> void:
	var validCode = Constants._import_game($TabContainer/Settings/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/Panel/MarginContainer/ImportExportText.text)
	if !validCode:
		$TabContainer/Settings/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ValidationCode.modulate = 'ff0000'
		$TabContainer/Settings/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ValidationCode.text = 'Error! Invalid save code.'
	else:
		$TabContainer/Settings/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ValidationCode.modulate = '00ff00'
		$TabContainer/Settings/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ValidationCode.text = 'Success! Save code imported.'
		get_tree().change_scene_to_file("res://Common/MainMenu/Scenes/MainMenu.tscn")


func _on_tab_container_tab_changed(tab: int) -> void:
	$AudioStreamPlayer.play()


func _on_fuel_consump_value_changed(value: float) -> void:
	if value == 1.0:
		Constants.fuelConsumptionRate = 50.0
	elif value == 0.0:
		Constants.fuelConsumptionRate = 75.0
	else:
		Constants.fuelConsumptionRate = 25.0


func _on_menu_button_pressed() -> void:
	if !Constants.transitioning and open:
		Settings._hide_settings()


func _on_copy_pressed() -> void:
	DisplayServer.clipboard_set($TabContainer/Settings/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/Panel/MarginContainer/ImportExportText.text)
	$TabContainer/Settings/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ValidationCode.modulate = 'ffffff'
	$TabContainer/Settings/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ValidationCode.text = 'Success! Save code copied to clipboard.'


func _on_paste_pressed() -> void:
	var clipboard_text = DisplayServer.clipboard_get()
	$TabContainer/Settings/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/Panel/MarginContainer/ImportExportText.text = clipboard_text
	$TabContainer/Settings/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ValidationCode.modulate = 'ffffff'
	$TabContainer/Settings/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ValidationCode.text = 'Success! Save code pasted from clipboard.'