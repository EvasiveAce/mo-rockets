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


