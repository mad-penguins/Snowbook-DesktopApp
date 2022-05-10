extends Control

var server_address = 'http://127.0.0.1:5000'
var _username: String
var _password: String
var _token: String

var _notes_id_list: Array
var _current_index: int = 0

var shift: int
var state: int = 0;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shift = get_viewport().size.x
	
	$LoginSpace.visible = true
	
	$NotesSpace.rect_position += Vector2(shift,0)
	$NotesSpace.visible = false
	

	pass

#
#func _shifting(node):
#
#


func loadNote():
	if _current_index < len(_notes_id_list):
		var x = _notes_id_list[_current_index]
		
		$HTTPRequest.request(
			server_address+"/notes/"+str(x).http_escape()+"/"+_token.http_escape()
		)
		_current_index += 1
	


func _on_HTTPRequest_request_completed(
		result: int,
		response_code: int,
		headers: PoolStringArray,
		body: PoolByteArray
	) -> void:
	print(body.get_string_from_utf8())
	var d: Dictionary = JSON.parse(body.get_string_from_utf8()).result
	print(d)
	
	var error: String = d.get('error', 'none')
	
	if error != 'none':
		$AcceptDialog.dialog_text = error.to_upper()
		
		$AcceptDialog.popup_centered()
	else:
		if d.get('register', 'none') == 'OK':
			_login()
		elif d.get('login', 'none') == 'OK':
			_password = ' '
			_token = d.get('token')
			
			$Tween.interpolate_property(
				$LoginSpace,
				"rect_position",
				$LoginSpace.rect_position,
				Vector2(
					$LoginSpace.rect_position.x - shift,
					$LoginSpace.rect_position.y
				),
				0.5,
				Tween.TRANS_LINEAR,
				Tween.EASE_IN_OUT
			)
			
			$NotesSpace.clearNotesList()
			$NotesSpace.visible = true
			$Tween.interpolate_property(
				$NotesSpace,
				"rect_position",
				$NotesSpace.rect_position,
				Vector2(
					$NotesSpace.rect_position.x - shift,
					$NotesSpace.rect_position.y
				),
				0.5,
				Tween.TRANS_LINEAR,
				Tween.EASE_IN_OUT
			)
			$Tween.start()
			
			state = 1
			
			print(_token)
			
		elif d.get('getAllNotes', 'none') == 'OK':
			_notes_id_list = d.get('notes')
			_current_index = 0
			loadNote()
		elif d.get('getNote', 'none') == 'OK':
			var id = d.get('note').get('id')
			var title = d.get('note').get('title')
			var text = d.get('note').get('text')
			$NotesSpace.addNote(id, title, text)
			loadNote()
		elif d.get('createNewNote', 'none') == 'OK':
			var id = d.get('note_id')
			$HTTPRequest.request(
					server_address+"/notes/"+str(id).http_escape()+"/"+_token.http_escape()
				)


func _login():
	$HTTPRequest.request(
		server_address+"/login?username="+_username.http_escape()+\
		"&password="+_password.http_escape()
	)


func _register():
	$HTTPRequest.request(
		server_address+"/register?username="+_username.http_escape()+\
		"&password="+_password.http_escape()
	)


func _on_LoginSpace_LoginSpace_ButtonPressed(
	username,
	password,
	register
	) -> void:
	_username = username
	_password = password
	
	if register:
		_register()
	else:
		_login()


func getAllNotes():
	$HTTPRequest.request(
		server_address+"/notes/"+_token.http_escape()
	)

func _on_Tween_tween_all_completed() -> void:
	if state == 1:
		$LoginSpace.visible = false
		
		getAllNotes()
	elif state == 0:
		$NotesSpace.visible = false
		


func _on_NotesSpace_logout() -> void:
	_token = ' '
	_username =  ' '
	_password = ' '
	
	$NotesSpace.clearNotesList()
	$NotesSpace.clearNoteEditor()
	
	$LoginSpace.clearPassword()
	
	$LoginSpace.visible = true
	$Tween.interpolate_property(
		$LoginSpace,
		"rect_position",
		$LoginSpace.rect_position,
		Vector2(
			$LoginSpace.rect_position.x + shift,
			$LoginSpace.rect_position.y
		),
		0.5,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	
	
	$Tween.interpolate_property(
		$NotesSpace,
		"rect_position",
		$NotesSpace.rect_position,
		Vector2(
			$NotesSpace.rect_position.x + shift,
			$NotesSpace.rect_position.y
		),
		0.5,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	$Tween.start()
	
	state = 0


func _add_note(title, text) -> void:
	print(456456, title, text)
	$HTTPRequest.request(
		server_address+"/notes/new/"+_token.http_escape()+\
		"?title="+title.http_escape()+\
		"&text="+text.http_escape()
	)


func _update_note(id, title, text) -> void:
	print(4-6, title, text)
	$HTTPRequest.request(
		server_address+"/notes/"+str(id).http_escape()+"/update/"+_token.http_escape()+\
		"?title="+title.http_escape()+\
		"&text="+text.http_escape()
	)


func _delete_note(id) -> void:
	$HTTPRequest.request(
		server_address+"/notes/"+str(id).http_escape()+"/delete/"+_token.http_escape()
	)


func _on_NotesSpace_add_note(title, text) -> void:
	_add_note(title, text)
	pass # Replace with function body.


func _on_NotesSpace_update_note(id, title, text) -> void:
	_update_note(id, title, text)
	pass # Replace with function body.


func _on_NotesSpace_delete_note(id) -> void:
	_delete_note(id)
	pass # Replace with function body.


func _on_NotesSpace_reload() -> void:
	getAllNotes()
	pass # Replace with function body.
