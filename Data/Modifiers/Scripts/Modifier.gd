class_name Modifier
extends Resource

enum StatType {
    NONE,
    SPEED,
    FUEL,
    RESEARCH
}

@export var modifierName: String

@export var statModifier1Name: StatType
@export var statModifier1Amount: float
@export var statModifier2Name: StatType
@export var statModifier2Amount: float

func _get_stat1_modifier() -> float:
    return snapped(statModifier1Amount * Constants.statMultiplier, 0.01)

func _get_stat2_modifier() -> float:
    return snapped(statModifier2Amount * Constants.statMultiplier, 0.01)