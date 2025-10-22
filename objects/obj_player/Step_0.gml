//Se o jogo está pausado, eu nao rodo nada daqui
if (global.pause or transicao){
    velh = 0;
    velv = 0;
    exit;
}
estado();

if (keyboard_check_released(vk_tab)) {
	global.debug = !global.debug;
}

if (keyboard_check_released(vk_shift)) {
	toma_dano();
}

efeito_dano();



