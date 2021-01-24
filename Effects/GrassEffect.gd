extends Node2D

# This grass effect is a different scene for educational purposes.
# This animation can be done inside the original Grass scene.
onready var animatedSprite = $AnimatedSprite

func _ready():
	animatedSprite.frame = 0
	animatedSprite.play("Scatter")	 


func _on_AnimatedSprite_animation_finished():
	queue_free()
