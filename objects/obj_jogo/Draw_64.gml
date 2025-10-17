draw_text(20, 20, global.pause);

//Escurecendo a tela
if (global.pause) {
	desenha_pause();
}else { //Se o jogo nao esta pausado
	if(layer_exists("efeito_pause")){
        layer_destroy("efeito_pause");
    }
}