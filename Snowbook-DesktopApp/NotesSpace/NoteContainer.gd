extends VBoxContainer


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var _id: int
var _title: String
var _text: String

signal noteContainerReaction(id, title, text)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	

func init(id, title, text):
	$Label.text = '# '+ title
	_id = id
	_title = title
	_text = text
	print(4545, title, text)


func _on_Button_pressed() -> void:
	emit_signal("noteContainerReaction", _id, _title, _text)
	
	pass # Replace with function body.
