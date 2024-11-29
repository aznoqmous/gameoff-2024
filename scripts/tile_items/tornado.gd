class_name Tornado
extends TileItem

func init():
	super()
	
	var tile: Tile = get_tile()
	print(tile, floor(currentPosition/game.tileSize))
	tile.on_set_item.connect(handle_tile_set_item)
	tile.on_enter_tile.connect(handle_enter_tile)
	
# handle tile items
func handle_tile_set_item(item: TileItem):
	if not item or item == self: return
	var direction = item.lastPosition - item.position
	if not direction: return
	item.push(direction * 4)
	fall()

# handle player
func handle_enter_tile():
	game.player.clear_cast()
	game.player.move(game.player.lastDirection * 4)
	fall()
