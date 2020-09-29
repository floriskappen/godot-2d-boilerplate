extends Node2D

onready var MovementStates = {
	"IDLE": $MovementStates/IDLE
}

var state_stack = []
var state_stack_size = 10

func _ready():
	change_movement_state({
		"state": MovementStates["IDLE"]
	})
	pass

func _physics_process(delta):
	var current_movement_state = current_movement_state()
	var update_state_data = current_movement_state.execute(self, delta)
	if update_state_data != null:
		change_movement_state(update_state_data)

func change_movement_state(new_state_data):
	var previous_state
	var message
	if new_state_data.has("message"):
		message = new_state_data["message"]
	if len(state_stack) > 0:
		previous_state = current_movement_state()
	
	state_stack.append(new_state_data["state"])
	var current_movement_state = current_movement_state()
	if len(state_stack) > state_stack_size:
		state_stack.remove(0)
	
	if previous_state != null:
		previous_state.exit(self)
	if current_movement_state != null:
		current_movement_state.enter(self, message)

func current_movement_state(): return state_stack[len(state_stack) - 1]
