extends Node2D

# skills is an array of string names of skills, i.e. ['shoot', 'stab', 'parry', etc.]
var skills = [] setget add_skills, get_skills

func add_skills(value : String):
	skills.append(value)
#	get_domain()

func get_skills():
	return skills.duplicate()

onready var skillDictionary = {
#	this dictionary tracks skill growth for a given pawn
	"shortbow": [1, 50],
	"longsword": [1, 50],
	"lance": [1, 50],
	"halberd": [1, 50],
	"tongue": [1, 50],
}

func skill_growth(skill):
	#lvl is the adjusted skill value after growth
	var lvl = skillDictionary[skill]
	lvl[0] += 1
	skillDictionary[skill] = lvl
	pass

func get_level(weapon : String):
	return skillDictionary.get(weapon)

# domain is a 2d array where each element represents the range of a skill
# where element[0] is the lower limit and element[1] is the upper limit

#TODO: domain will eventually need to include support skill and item ranges
#func get_domain():
#	domain = [[]]
#	var i = 0
#	while i < skills.size():
#		print('check')
#		if i == 0: domain = [skillDictionary.get(skills[i])[SKILL_STATS.RNG]]
#		else:
#			var skillRange = skillDictionary.get(skills[i])[SKILL_STATS.RNG]
#			domain.append(i, skillRange)
#		i += 1
#	return domain

enum UNIT_TYPES {
	FROG = 0,
	HERA = 1,
	GERRIK = 2,
	LANCIER = 3,
	BOSS = 4,
}

enum UNIT_INFO {
	NAME = 0,
	GROUP = 1,
	PIC = 2,
	ICON = 3,
	DEFAULT_WPN = 4
	
}

# info is in array [NAME, GROUP, PIC, ICON, DEFAULT_SKILL]
onready var info = {
	UNIT_TYPES.HERA: ['Hera', 'Heroes', "res://pawns/players/hera/character 2.png", 'res://pawns/players/hera/pixelHera.tres', 'shortbow'],
	UNIT_TYPES.GERRIK: ['Gerrik', 'Heroes', "res://pawns/players/gerrik/Character 1.png", 'res://pawns/players/gerrik/HeroFrames.tres', 'longsword'],
	UNIT_TYPES.FROG: ['Frogge', 'Heroes', "res://pawns/players/frogge/froge1.png", 'res://pawns/players/frogge/frogframes.tres', 'tongue'],
	#{'unitName': 'Frogge', 'group': 'Heroes', 'portrait': "res://pawns/players/frogge/froge1.png", 'frames': 'res://pawns/players/frogge/frogframes.tres'},
	UNIT_TYPES.BOSS: ['Boss', 'Enemies', "res://pawns/enemies/boss/Boss.png", 'res://pawns/enemies/boss/Boss.tres', 'halberd'],
}

enum UNIT_DEFAULT {
	DEFAULT_WPN = 0,
	DEFAULT_SKILL = 1,
}

onready var defaults = {
	UNIT_TYPES.HERA : ['shortbow'],
	UNIT_TYPES.GERRIK : ['longsword'],
	UNIT_TYPES.FROG : ['tongue'],
	UNIT_TYPES.BOSS : ['halberd'],
}

enum UNIT_STATS {
	AGL = 0,
	DEF = 1,
	MOV = 2,
	STR = 3,
	SPD = 4,
	MAXHP = 5,
}

onready var statsDictionary = {
	# stats are in array [AGL, DEF, MOV, STR, SPD, MAXHP]
	UNIT_TYPES.HERA: [9, 7, 5, 8, 4, 100], #'moveRange': 5, 'atkRange': 3, atk:20, def : 5,}, this was the old structure
	UNIT_TYPES.GERRIK: [7, 6, 3, 10, 3, 100],
	UNIT_TYPES.FROG: [10, 4, 6, 5, 6, 100],
	UNIT_TYPES.BOSS: [8, 7, 3, 10, 2, 100],
}

export(UNIT_TYPES) var unit = UNIT_TYPES.FROG

export onready var movRange = statsDictionary.get(unit)[UNIT_STATS.MOV]
#export onready var atkRange = statsDictionary.get(unit).get('atkRange') obsolete variable, replaced by domain
onready var STR = statsDictionary.get(unit)[UNIT_STATS.STR] setget ,get_strength
onready var DEF = statsDictionary.get(unit)[UNIT_STATS.DEF] setget ,get_defense
onready var AGL = statsDictionary.get(unit)[UNIT_STATS.AGL] setget ,get_agility
onready var SPD = statsDictionary.get(unit)[UNIT_STATS.SPD] setget ,get_speed
onready var MOV = statsDictionary.get(unit)[UNIT_STATS.MOV]
 
onready var APMax = 5 setget mod_AP
var AP = APMax setget use_AP, get_AP
var HP = 100 setget die

# func used to alter max AP for a pawn
func mod_AP(mod):
	APMax += mod

# atm action is the string name of the action, could be used later to
# find the AP cost of an action should they end up having diff costs
func use_AP(action):
	AP -= 1
	if AP == 0 && movement == 0: end_turn()

func get_AP():
	return AP

#equipment stats
#modify native stats, only rarer equip mods STR, MOV, AGL, etc.
onready var STV = 0
onready var DFV = 0
onready var SPV = 0
onready var AGV = 0
onready var MV = 0

#weapon stats
var weapon

func equip_weapon(wpn : String):
	weapon = wpn
	pass

onready var movement = movRange
onready var done = false

# combat specific variables
onready var distances = {} 
onready var runnable = false
#var domain = [[]] setget ,get_domain

# static variables specific to unit
var portrait
var unitName setget ,get_name

func get_dict():
	var pawnDict = {
#		the first two entries are static so pull from dictionary
		"name" : info.get(unit)[UNIT_INFO.NAME],
		"portrait" : info.get(unit)[UNIT_INFO.PIC],
#		the rest can be changed so use the variable
		"health": HP,
		"strength": STR,
		"defense": DEF,
		"self" : self,
	}
	return pawnDict
	pass

func set_group(type):
	var group = info.get(type)[UNIT_INFO.GROUP]
	self.add_to_group(group)

func get_group(type):
	return info.get(type)[UNIT_INFO.GROUP]

func _ready():
	self.add_to_group('pawns')
	set_group(unit)
	add_skills(info.get(unit)[UNIT_INFO.DEFAULT_WPN])
#	get_domain()
	pass

signal pawn_selected(node)
signal turn_finished()

func _on_hitbox_input_event(viewport, event, shape_idx):
	if done:
		return
	if not event is InputEventMouseButton:
		return
	if event.button_index != BUTTON_LEFT or event.pressed:
		return
	var EventDistance = get_local_mouse_position().abs().floor()
	if EventDistance.x < 20 && EventDistance.y < 20:
		emit_signal("pawn_selected", self)
#		Grid.turnPC = self.name
#		$PopupMenu.popup()

onready var stat_modifiers = []

func modify_stats(modifier):
	var stat
	match(modifier[0]):
		'strength':
			stat = UNIT_STATS.STR
		'defense':
			stat = UNIT_STATS.DEF
		'agility':
			stat = UNIT_STATS.AGl
		'speed':
			stat = UNIT_STATS.SPD
		'movement':
			stat = UNIT_STATS.MOV
		'max health':
			pass
		'health':
			pass
		
	var value = statsDictionary.get(stat)
	value += modifier[1]
	statsDictionary[stat] = value
	if modifier.size() == 3:
		stat_modifiers.append(modifier)

func mod_expiry():
	for mod in stat_modifiers:
		#pre-test or post-test loop?
		if mod[2] > 0 :
			mod[2] -= 1
			if mod [2] == 0:
				mod[1] *= -1
				modify_stats([mod[0], mod[1]])

func get_strength():
	return (STR + STV)
	
func get_agility():
	return (AGL + AGV)
	
func get_defense():
	return (DEF + DFV)
	
func get_speed():
	return (SPD + SPV)

func get_name():
	return info.get(unit)[UNIT_INFO.NAME]

func die(damage):
	HP -= damage
	if self.HP <=0:
#		pawn dies
		print(info.get(unit)[UNIT_INFO.NAME] + ' dies!')
		self.queue_free()

func turn_prep():
	done = false
	movement = self.movRange
	AP = APMax
	print('prep')

func end_turn():
	self.done = true
	emit_signal("turn_finished")
