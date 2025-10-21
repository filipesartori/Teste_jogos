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

////Perdendo vida ao apertar backspace
//if (keyboard_check_released(vk_backspace)) {
	//global.vida_player--;
    //global.vida_player = clamp(global.vida_player, 0, global.max_vida_player);
//}