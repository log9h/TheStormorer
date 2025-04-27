extends Node2D

enum map_tiles {CAMPFIRE, STORMORER, ENEMY}
var tile_chances = [30, 40, 30]

enum ground_tiles {STORM_LAST, NORMAL_LAST, STORM, NORMAL, _s}

var opening_tiles = [map_tiles.STORMORER, map_tiles.CAMPFIRE, map_tiles.ENEMY]
var opening_grounds = [ground_tiles.NORMAL, ground_tiles.NORMAL, ground_tiles.STORM]

var map = []
var grounds = []
const MAP_GENERATE_SIZE = 15
var prev_tile_generated = opening_tiles[-1]

var current_tile_index = 0
var tiles_traveled = 0

func init():
	map = opening_tiles
	grounds = opening_grounds
	while len(map) < MAP_GENERATE_SIZE:
		generate_tile()
	update_ui(2)

func generate_tile():
	var random = randi_range(1, 100)
	
	var tile
	var acc_chance = 0
	for i in len(tile_chances): # 10 30 30 20 10
		var chance = tile_chances[i]
		if acc_chance < random and random <= (acc_chance + chance):
			tile = i
		acc_chance += chance


	if tile == prev_tile_generated:
		tile = abs(tile - 1) % len(map_tiles)
	
	prev_tile_generated = tile
	map.append(tile)
	
	var ground = randi_range(0, 1)
	grounds.append(ground)

func update_ui(offset=0):
	for i in (7 - offset):
		var ground: Sprite2D = get_child(i+offset)
		var icon: Sprite2D = ground.get_child(0)
		
		ground.frame = grounds[i]
		if ground.frame < 2:
			ground.frame += 2
		if (i + offset) == 0 or (i + offset) == 6:
			ground.frame -= 2
			icon.visible = false
		
		
		icon.frame = map[i]

func scroll():
	if len(grounds) < len(map):
		grounds.append(ground_tiles.NORMAL)
	if not $Ground1.visible:
		$Ground1.visible = true
		update_ui(1)
	elif not $Ground0.visible:
		$Ground0.visible = true
		update_ui(0)
	else:
		map.pop_front()
		grounds.pop_front()
		generate_tile()
		update_ui(0)
		current_tile_index -= 1
	current_tile_index += 1
	tiles_traveled += 1
	$StageLabel.text = "\nSTAGE: %s" % [tiles_traveled+1]

func get_current_tile():
	return map[current_tile_index]

func get_current_ground():
	return grounds[current_tile_index]

func shift_grounds(offset):
	if offset == -1:
		grounds = grounds.slice(1) + [ground_tiles.NORMAL]
	elif offset == 1:
		grounds = [ground_tiles.NORMAL] + grounds.slice(0, len(grounds)-2)
	if not $Ground1.visible:
		update_ui(1)
	else:
		update_ui(0)
		
