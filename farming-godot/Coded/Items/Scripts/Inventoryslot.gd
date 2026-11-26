extends NinePatchRect

class_name InventorySlot

@export var item_data: ItemData

@onready var icon: TextureRect = $Iconbox/Icon
@onready var itemname: Label = $Itemname
@onready var desc: Label = $Desc
@onready 	var itemdataold = item_data

func _ready() -> void:
	updateslot()
	
func updateslot() -> void:
	if item_data == null:
		icon.texture = null
		itemname.text = ""
		desc.text = ""
		return
	icon.texture = item_data.icon
	itemname.text = item_data.item_name
	desc.text = item_data.description
	
func set_item(newitem: ItemData) -> void:
	item_data = newitem
	updateslot()
