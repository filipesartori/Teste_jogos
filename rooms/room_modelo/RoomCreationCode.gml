//criando player se ele nao existe
if (!instance_exists(obj_player)) {
	var _player = instance_create_layer(1248, 608, "Player", obj_player);
}