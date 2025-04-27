extends PanelContainer

signal weapon_used(which_id)

func load_data(data: Weapon):
	if data:
		visible = true
		$RowsContainer/ColsContainer/TextureRect.texture = data.texture
		
		var capt = "%s" % [data.name]
		$RowsContainer/ColsContainer/ItemCapt.text = capt
		var desc = "%s" % [data.desc]
		$RowsContainer/ItemDesc.text = desc
	else:
		visible = false

func set_active(active):
	$ItemButton.disabled = not active

func use():
	set_active(false)
	emit_signal("weapon_used", get_index())
