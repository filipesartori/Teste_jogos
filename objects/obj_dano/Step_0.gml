var _colisoes = ds_list_create();
var _qtd = instance_place_list(x, y, obj_inimigo_pai, _colisoes, false);

//Checar se quem eu colidi nao esta na lista dos atacados
for (var i = 0; i < _qtd; i++) {
	//Salvando o cara atual
    var _outro = _colisoes[| i];
    //Checando se o outro nao esta na lista de atacados
    if (ds_list_find_index(lista_atacados, _outro) == -1) {
        if (_outro != meu_pai) {
        	//Adicionei na lista
            ds_list_add(lista_atacados, _outro);
            var _dano = global.arma_player != noone ? global.arma_player.dano : 0;
            //aplica o dano
            _outro.toma_dano(_dano);
            _outro.dano_dir = point_direction(x, y, _outro.x, _outro.y - (_outro.sprite_height/2));
        }
    }
}

/*
//Aplicando o dano SE eu acertar alguem
if (_qtd) {
	for (var i = 0; i < _qtd; i++) {
        var _outro = _colisoes[| i];
	    _outro.toma_dano();
	    _outro.dano_dir = point_direction(x, y, _outro.x, _outro.y);
	    //_colisoes[| i].knockback(x, y);
    }
}
*/
//Destruindo a estrtura de dados
ds_list_destroy(_colisoes);