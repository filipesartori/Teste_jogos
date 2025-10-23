//Escurecendo a tela
if (global.pause) {
	desenha_pause();
    desenha_inventario();
}else { //Se o jogo nao esta pausado
	if(layer_exists("efeito_pause")){
        layer_destroy("efeito_pause");
    }
}

if (room != rm_inicio && !instance_exists(obj_transicao)) {
	desenha_coracao(20, 40);
}


//Desenhando op nome do equipamento atual
if (global.arma_player) {
	//draw_text(20, 40, global.arma_player.nome);
}