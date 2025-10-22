room_destino = noone;
destino_x = 0;
destino_y = 0;
player = noone;

//Ativando meu alarme
alarm[0] = game_get_speed(gamespeed_fps)/2;

cria_sequencia = function (_sq){
    lay = layer_create(depth, "transicao");
    layer_sequence_create(lay, obj_player.x, obj_player.y, _sq);
}

cria_sequencia(sq_transicao);