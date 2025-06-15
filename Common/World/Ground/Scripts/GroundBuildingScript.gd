extends Sprite2D


var boughtRD = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Constants.rdBuildingUpgrade and !boughtRD:
		boughtRD = true
		$RDBuilding.visible = true
