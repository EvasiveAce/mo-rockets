class_name UpgradeIcon
extends Button

@export var part: BasePart

@onready var line_2D = $Line2D

func _ready() -> void:
	if part.boughtBool:
		$IconSprite.texture = part.boughtSprite
	else:
		$IconSprite.texture = part.iconSprite

	if get_parent() is UpgradeIcon:
		line_2D.add_point(global_position + size/2)
		line_2D.add_point(get_parent().global_position + size/2)

func _on_mouse_entered() -> void:
	await get_tree().create_timer(0.0001).timeout
	Popups.ItemPopup([part.upgradeName, part.upgradeInfo, str(part.upgradeCost) if !part.boughtBool else "BOUGHT", part.upgradeDesc])
	$IconSprite.scale.x = 4.25
	$IconSprite.scale.y = 4.25

func _on_mouse_exited() -> void:
	Popups.HideItemPopup()
	$IconSprite.scale.x = 4
	$IconSprite.scale.y = 4

func _process(_delta: float) -> void:
	if get_parent() != null:
		if !part.boughtBool:
			part.unlockedBool = true
			$IconSprite.texture = part.iconSprite
