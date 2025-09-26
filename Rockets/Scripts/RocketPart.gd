class_name RocketPart
extends BasePart

enum StatType {
    NONE,
    SPEED,
    FUEL,
    RESEARCH
}

enum PartType {
    NOSE,
    BODY,
    BOTTOM
}

@export var partType : PartType

@export var statModifier1Name: StatType
@export var statModifier1Amount: float
@export var statModifier2Name: StatType
@export var statModifier2Amount: float

var modulate : Color

@export var partSprite: Texture2D

var speedValue := 0.0
var fuelValue := 0.0

func _get_stat1_modifier() -> float:
    return snapped(randf_range(-0.5 * (float(Constants.highestAltitude) / 1000.0), 0.5 * (float(Constants.highestAltitude) / 1000.0)), 0.01)

func _get_stat2_modifier() -> float:
    return snapped(randf_range(-0.5 * (float(Constants.highestAltitude) / 1000.0), 0.5 * (float(Constants.highestAltitude) / 1000.0)), 0.01)