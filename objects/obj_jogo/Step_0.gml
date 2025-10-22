//Se o jogo esta pausado, pausa todas as entidades
if (global.pause) {
    if (instance_exists(obj_entidade)) {
    	with (obj_entidade) {
    	    velh = 0;
            velv = 0;
            image_speed = 0;
        }
    }
}

if (keyboard_check_released(vk_escape)) {
	global.pause = !global.pause;
}

//testando meu save
if (keyboard_check_released(vk_delete)) {
	salva_jogo(global.save);
}

if (keyboard_check_released(vk_pause)) {
	carrega_jogo(global.save);
}