extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts

onready var emptyHearts = $EmptyHearts
onready var filledHearts = $FilledHearts

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if filledHearts != null:
		update_heart_ui(hearts)

func update_heart_ui(hearts):
	filledHearts.rect_size.x = hearts * 15

func set_max_hearts(value):
	max_hearts = max(value,1)
	self.hearts = min(hearts, max_hearts)
	if filledHearts != null:
		update_heart_ui(max_hearts)


func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_hearts")
	PlayerStats.connect("max_health_changed", self, "set_max_hearts")