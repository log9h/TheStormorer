@tool
extends RichTextEffect
class_name ShiftingText

var bbcode = "shifting_text"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var shift = int(char_fx.env.get("shift", 1))
	var offset = Vector2(0, shift * char_fx.range.x)
	char_fx.offset = offset
	return true
