extends Resource
class_name ItemData

@export var item_id: String
@export var item_name: String
@export_multiline var description: String

@export var icon: AtlasTexture
@export var selected_icon: AtlasTexture

	
@export var max_stack: int = 64
@export var item_action: Resource
