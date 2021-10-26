extends Sprite

enum COLLISION {credits,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,q,end}

export(COLLISION) var layer = COLLISION.c

onready var walls = $Walls
onready var goal = $Goal
onready var pits = get_tree().get_nodes_in_group('pits')
onready var flippers = get_tree().get_nodes_in_group('flippers')
onready var checkpoint = $start

signal fall(layer, pos)
signal goal(layer, pos)

func _on_Goal_body_entered(body):
	emit_signal('goal', layer, goal.global_position)

func _on_Pit_body_entered(pit):
	emit_signal('fall', layer, pit.global_position)

func _ready():
#	walls.set_collision_layer_bit(layer, true)	
	goal.connect('body_entered', self, '_on_Goal_body_entered')
#	goal.set_collision_layer_bit(layer, true)
	var kids = get_children()
	for pit in pits:
		if kids.has(pit):
			pit.connect('pitfall', self, "_on_Pit_body_entered")
#			pit.set_collision_layer_bit(layer, true)

func go_away(vis):
	set_visible(false)
	change_layers(false)
	pass

func arrive():
	set_visible(true)
	change_layers(true)

func change_layers(on):
	walls.set_collision_layer_bit(1, on)	
	goal.set_collision_layer_bit(1, on)	
	for pit in pits:
		if get_children().has(pit):
			pit.set_collision_layer_bit(1, on)	
	for flipper in flippers:
		if get_children().has(flipper):
			flipper.switch(1, on)
