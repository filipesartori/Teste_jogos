alvo = noone;
estado = noone;
escala = 1;
cam_w = camera_get_view_width(view_camera[0]);
cam_h = camera_get_view_height(view_camera[0]);

zoom = function (){
    //Definindo o tamanho da minha view
    camera_set_view_size(view_camera[0], cam_w * escala, cam_h * escala);
    
    //Aletrando o valor da escala na bolinha do mouse
    if (mouse_wheel_down()) {
    	escala += .1;
    } else if (mouse_wheel_up()) {
    	escala -= .1;
    }
    
}

segue_alvo = function (){
    //Pegando o tamanho da camera
    var _view_w = camera_get_view_width(view_camera[0]);
    var _view_h = camera_get_view_height(view_camera[0]);
    
    var _cam_x = x - _view_w/2;
    var _cam_y = y - _view_h/2;
    
    //Limitando a camera na room
    _cam_x = clamp(_cam_x, 0, room_width - _view_w);
    _cam_y = clamp(_cam_y, 0, room_height - _view_h);
    
    //Movimento suave da camera
    x = lerp(x, alvo.x, .2);
    y = lerp(y, alvo.y, .2);
    
    //Definindo a posicao da camera
    camera_set_view_pos(view_camera[0], _cam_x, _cam_y);
}


//Seguindo o player
segue_player = function (){
    //checando se o player existe
    if (instance_exists(obj_player)) {
    	alvo = obj_player;
    }else {
    	estado = segue_nada;
    }
    
    segue_alvo();
    
    //Se eu aperetei espaco eu sigo o inimigo
    //if (keyboard_check_released(vk_space)) {
    	//estado = segue_inimigo;
    //}
}

segue_nada = function (){
    alvo = noone;
}

//segue_inimigo = function (){
    //alvo = obj_inimigo;
    //
    //segue_alvo();
    //
    //if (keyboard_check_released(vk_space)) {
    	//estado = segue_player;
    //}
//}

estado = segue_player;