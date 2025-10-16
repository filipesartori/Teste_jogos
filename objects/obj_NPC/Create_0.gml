larg = 30;
alt = 20;
margem = 5;

debug_area = function (){
  //Area de dialogo
    var _y = bbox_bottom + margem;
    draw_rectangle(x - larg / 2, _y, x + larg / 2, _y + alt, true);  
}

dialogo_area = function (){
    var _y = bbox_bottom + margem; 
    var _player = collision_rectangle(x - larg / 2, _y, x + larg / 2, _y + alt, obj_player, 0, 1);
    image_blend = c_white
    if (_player) {
    	image_blend = c_red;
        //Se eu apertar enter ou espaco eu entro no estado de dialogo
        if (keyboard_check_pressed(vk_space)) {
        	with (_player) {
        	    estado = estado_dialogo;
            }
        }
        //Se eu apertar esc eu saio do dialogo
        if (keyboard_check_pressed(vk_escape)) {
        	with (_player) {
            	estado = estado_parado;
            }
        }
        
    }
}