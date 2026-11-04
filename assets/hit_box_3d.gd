@tool
@icon("res://assets/icons/hit_box_3d.svg")
class_name HitBox3D
extends Area3D

## Emitted when the hit box hits a hurt box.
signal hit_hurt_box(hurt_box: HurtBox3D)

const DAMAGE_SOURCE_PLAYER := 0b01
const DAMAGE_SOURCE_MOB := 0b10

## The amount of damage the hit box deals.
@export var damage := 1
## The type of damage source: who is attacking. This sets the collision layer so hurt boxes can filter hits.
@export_flags("Player", "Mob") var source_type := DAMAGE_SOURCE_PLAYER:
	set = set_source_type
## The types of hurt boxes this hit box can hit. This sets the collision mask to detect matching hurt boxes.
@export_flags("Player", "Mob") var can_hit := DAMAGE_SOURCE_MOB:
	set = set_can_hit


func _init() -> void:
	monitoring = true
	monitorable = true
	area_entered.connect(
		func _on_area_entered(area: Area3D) -> void:
			if area is HurtBox3D:
				hit_hurt_box.emit(area)
	)


func set_source_type(new_value: int) -> void:
	source_type = new_value
	collision_layer = source_type


func set_can_hit(new_value: int) -> void:
	can_hit = new_value
	collision_mask = can_hit
