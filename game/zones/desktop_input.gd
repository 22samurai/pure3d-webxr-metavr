extends Node


# These actions are only used by the desktop movement and pointer nodes.
func _ready() -> void:
	_bind_key("desktop_forward", KEY_W)
	_bind_key("desktop_backward", KEY_S)
	_bind_key("desktop_left", KEY_A)
	_bind_key("desktop_right", KEY_D)
	_bind_key("desktop_interact", KEY_F)
	_bind_mouse("desktop_interact", MOUSE_BUTTON_LEFT)


func _bind_key(action: StringName, keycode: Key) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	var event := InputEventKey.new()
	event.physical_keycode = keycode
	if not InputMap.action_has_event(action, event):
		InputMap.action_add_event(action, event)


func _bind_mouse(action: StringName, button: MouseButton) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	var event := InputEventMouseButton.new()
	event.button_index = button
	if not InputMap.action_has_event(action, event):
		InputMap.action_add_event(action, event)
