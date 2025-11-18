extends Control

@onready var security_card: TextureRect = $Bag/SecurityCard
@onready var bag: Panel = $Bag

var dragging := false
var drag_offset := Vector2.ZERO
var selected_item

func _process(_delta: float) -> void:
	if dragging:
		var new_pos = get_global_mouse_position() + drag_offset
		new_pos.x = clamp(new_pos.x, bag.position.x, bag.position.x + bag.size.x - security_card.size.x)
		new_pos.y = clamp(new_pos.y, bag.position.y, bag.position.y + bag.size.y - security_card.size.y)

		security_card.global_position = new_pos

func _input(event):
	# Start dragging
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and security_card.get_global_rect().has_point(event.position):
			dragging = true
			drag_offset = security_card.global_position - event.position

		# Stop dragging
		if not event.pressed:
			dragging = false
