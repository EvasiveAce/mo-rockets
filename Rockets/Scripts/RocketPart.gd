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

@export var partSprite: Texture2D