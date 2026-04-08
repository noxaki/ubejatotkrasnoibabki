extends InteractionBase

func interact(_parameters=null):
	var player = _parameters
	if player:
		player.equip_lantern()
		queue_free()
