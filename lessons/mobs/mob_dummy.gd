extends CharacterBody3D

enum State {
	LOOK_AT_PLAYER,
	WAIT,
	FIRE_PROJECTILE,
}

var current_state: State = State.LOOK_AT_PLAYER:
	set = set_current_state
	
func set_current_state(new_state: State) -> void:
	current_state = new_state
	
	match current_state:
		State.LOOK_AT_PLAYER:
			get_tree().create_timer(2.0).timeout.connect(
				set_current_state.bind(State.WAIT)
			)
		State.WAIT:
			get_tree().create_timer(0.5).timeout.connect(
				set_current_state.bind(State.FIRE_PROJECTILE)
			)
		State.FIRE_PROJECTILE:
			var projectile: Projectile3D = projectile_scene.instantiate()
			add_sibling(projectile)
			
			projectile.global_position = shooting_point.global_position
			projectile.look_at(
				shooting_point.global_position + shooting_point.global_basis.z
			)
			get_tree().create_timer(0.5).timeout.connect(
				set_current_state.bind(State.LOOK_AT_PLAYER)
			)
	
var player: CharacterBody3D = null


@export var projectile_scene: PackedScene = null
@onready var shooting_point: Node3D = %ShootingPoint

func _ready() -> void:
	player = get_tree().root.get_node("Level/Player3D")
	set_current_state(State.LOOK_AT_PLAYER)
	
func _physics_process(delta: float) -> void:
	match current_state:
		State.LOOK_AT_PLAYER:
			var direction := global_position.direction_to(
				player.global_position
			)
			var target_rotation_y := Vector3.FORWARD.signed_angle_to(
				direction, Vector3.UP
			) + PI
			rotation.y = lerp_angle(
				rotation.y, target_rotation_y, 2.0 * delta
			)
