extends Control

func _ready() -> void:
	$"Inner Hotbar/NinePatchRect/Inventory/Slot".set_item(load("res://Coded/Items/Data/wooden/wooden_sword.tres"))
	$"Inner Hotbar/NinePatchRect/Inventory/Slot2".set_item(load("res://Coded/Items/Data/wooden/wooden_pickaxe.tres"))
	$"Inner Hotbar/NinePatchRect/Inventory/Slot3".set_item(load("res://Coded/Items/Data/wooden/wooden_axe.tres"))
	$"Inner Hotbar/NinePatchRect/Inventory/Slot4".set_item(load("res://Coded/Items/Data/wooden/wooden_shovel.tres"))
	$"Inner Hotbar/NinePatchRect/Inventory/Slot5".set_item(load("res://Coded/Items/Data/wooden/wooden_sickle.tres"))
	$"Inner Hotbar/NinePatchRect/Inventory/Slot6".set_item(load("res://Coded/Items/Data/wooden/wooden_staff.tres"))
