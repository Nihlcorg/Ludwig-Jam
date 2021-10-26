extends Node

onready var tree = self.get_tree()
var heroes
var enemies
var mousepos = Vector2()
onready var Map = $Map
onready var Banner = $Banner
onready var pather = $Pather
onready var HUD = $HUD

var inputMode = 'no selection'
var turn = 0
var activePawn

func _ready():
	var mapArea = $Map/Plains1.get_used_rect()
	HUD.set_absolutes(mapArea.position * 40, mapArea.size * 40)
	heroes = get_heroes()
	enemies = get_enemies()
	player_turn()
	HUD.connect("acting", self, "action_setup")
	for hero in heroes:
		hero.connect("turn_finished", self, "hero_finished")
		hero.connect("pawn_selected", self, "_pawn_selected")
	for enemy in enemies:
		enemy.connect("pawn_selected", self, "_pawn_selected")

#	NOTICE! statements below this line are for debug purposes!
#	var domain = [[1,1],[3,3], [5,5]]
#	domain = pather.get_domain(domain, heroes[0].global_position)
#	for tile in domain: Map.red(Map.world_to_map(tile))
#	var dist = pather.get_distance(enemies[0].global_position, heroes[0].global_position)
#	enemies.append_array(heroes)
#	var speedList = sortby_speed(enemies)
#	print(speedList)
#	for tile in dist: Map.red(Map.world_to_map(tile))
#	print('dist = ')
#	print(dist)
#	var tiles = pathing(heroes[0], true)

func _unhandled_input(event):
	match(inputMode):
#		'in combat':
#			return
		'freeze':
			if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and event.is_pressed():
				activePawn.undo_movement()
				HUD.thaw_cursor()
				HUD.hide_menu()
				inputMode = 'no selection'
		'no selection':
			pass
		'pc selected':
			if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
				var mousepos = snap_to_grid(event.position)
				if Map.is_blue(mousepos):
					var trail = $Pather.test_path(mousepos, activePawn.movement, activePawn.global_position)
					print (trail)
					if trail:
						activePawn.pathing(trail)
						Map.clear()
			if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
				Map.clear()
				inputMode = 'no selection'

func action_setup(pawn, action):
	if pawn.AP > 0:
		selectedAction = action
		print(pawn.name)
		print(action)
		var stats = $WeaponHandler.use_weapon(action, pawn)
	#	print(pawn.skills.get(action))
		#Highlight action range on map
		var actionRange = pather.get_domain([stats[4]], pawn.global_position)
		for tile in actionRange:
			Map.red(Map.world_to_map(tile))
		#alter inputs to respond appropriately
		inputMode = 'action selected'
	else :
		print('out of AP!')
		Map.clear()
		inputMode = 'no selection'

var selectedAction

func _pawn_selected(pawn):
	match(inputMode):
		'no selection':
			print('select')
			activePawn = pawn
#			pathing(pawn, false)
			inputMode = 'pc selected'
		'pc selected':
			Map.clear()
			if pawn == activePawn:
				HUD.focus_pawn(pawn)
				pass
			if pawn != activePawn:
				inputMode = 'no selection'
				_pawn_selected(pawn)
		'action selected':
			if Map.is_red(pawn.global_position):
				if activePawn.AP > 0:
					print(pawn.name + ' says ouch')
					if $WeaponHandler.targets == pawn:
						$WeaponHandler.resolve()
						activePawn.AP = 'weapon'
						action_setup(activePawn, selectedAction)
					$WeaponHandler.targets = pawn
			pass
#		player context menu popup

func get_heroes():
	var heros = tree.get_nodes_in_group("Heroes")
	return heros

func get_weapon_dict(weaponList):
	var weaponDict := {}
	for weapon in weaponList:
		weaponDict[weapon] = $WeaponHandler.get_stats(weapon)
	return weaponDict

func get_enemies():
	var enems = tree.get_nodes_in_group("Enemies")
	return enems

func cell_to_pos(cell):
	var pos = Map.map_to_world(cell) + Map.cell_size / 2
	return pos

func snap_to_grid(pos):
	pos = ((pos/40).floor() * 40) + Vector2(20, 20)
	return pos

func hero_finished():
	print ('group')
	for hero in heroes:
		if hero.done == false:
			return
	enemy_turn()

func mob_finished():
	print('chk')
	for enemy in enemies:
		if enemy.done == false:
			return
	player_turn()

func player_turn():
	Banner.set_visible(true)
	Banner.set_animation("player")
	Banner.play()
	yield(Banner, "animation_finished")
	Banner.set_visible(false)
	tree.call_group("Heroes", "turn_prep")

func enemy_turn():
	enemies = get_enemies()
	Banner.set_visible(true)
	Banner.set_animation("enemy")
	Banner.play()
	yield(Banner, "animation_finished")
	Banner.set_visible(false)
	if enemies[0]:
		enemies[0].turn_prep(enemies)

func remove_array_dupes(array):
	var repeat = true
	while(repeat):
		repeat = false
		for element in array:
			if array.count(element) > 1:
				repeat = true
				array.erase(element)
	return array

func _on_HUD_boot(pawn):
	print('root boot')
	if pawn.movement <= 0: print ('out of movement!')
	else:
		var test = pather.get_range(pawn.movement, pawn.global_position)
		if test is Vector2:
			Map.blue(Map.world_to_map(test))
		for point in test:
			Map.blue(Map.world_to_map(point))
	if pawn.is_in_group('Heroes'):
		activePawn = pawn
		inputMode = 'pc selected'
