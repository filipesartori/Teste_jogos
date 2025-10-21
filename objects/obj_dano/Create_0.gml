lista_atacados = ds_list_create();
meu_pai = noone;

if (instance_exists(obj_player)) {
	meu_pai = obj_player.id;
}