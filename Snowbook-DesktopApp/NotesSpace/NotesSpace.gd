extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

signal logout

signal add_note(title, text)
signal update_note(id, title, text)
signal delete_note(id)
signal reload


var noteContainerWidget = preload("res://NotesSpace/NoteContainer.tscn")

var _title: String
var _text: String
var _id: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func clearNotesList() -> void:
	print(123123)

	
	for n in $ScrollContainer/VBoxContainer.get_children():
		$ScrollContainer/VBoxContainer.remove_child(n)
		n.queue_free()


func clearNoteEditor() -> void:
	$Title/LineEdit.text = ''
	$Text/TextEdit.text = ''
	
	_title = ''
	_text = ''
	_id = 0



func addNote(id, title, text) -> void:
	print(434)
	print(title, text)
	
	var noteContainer = noteContainerWidget.instance()
	noteContainer.init(id, title, text)
	noteContainer.connect("noteContainerReaction", self, "_on_noteContainerReaction")
	
	$ScrollContainer/VBoxContainer.add_child(noteContainer)
	pass


func _on_noteContainerReaction(id, title, text):
	print(10101010, '  ', id, ' ', title, text)
	
	_title = title
	_text = text
	_id = id
	
	$Title/LineEdit.text = title
	$Text/TextEdit.text = text
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_LogoutButton_pressed() -> void:
	emit_signal("logout")
	pass # Replace with function body.


func _on_Button_Add_pressed() -> void:
	_title = $Title/LineEdit.text
	_text = $Text/TextEdit.text
	
	emit_signal("add_note", _title, _text)
	clearNoteEditor()
	pass # Replace with function body.


func _on_Button_Update_pressed() -> void:
	_title = $Title/LineEdit.text
	_text = $Text/TextEdit.text
	
	$need.visible = true
	
	print(-6, _id, _title, _text)
	
	emit_signal("update_note", _id, _title, _text)
	pass # Replace with function body.


func _on_Button_Delete_pressed() -> void:
	$need.visible = true
	emit_signal("delete_note", _id)
	clearNoteEditor()
	pass # Replace with function body.


func _on_Button_Reload_pressed() -> void:
	clearNotesList()
	$need.visible = false
	emit_signal("reload")
	pass # Replace with function body.


func _on_Button_Clear_pressed() -> void:
	clearNoteEditor()
	pass # Replace with function body.
