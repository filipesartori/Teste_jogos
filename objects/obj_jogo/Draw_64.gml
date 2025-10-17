//Escurecendo a tela
if (global.pause) {
	desenha_pause();
    desenha_inventario();
}else { //Se o jogo nao esta pausado
	if(layer_exists("efeito_pause")){
        layer_destroy("efeito_pause");
    }
}