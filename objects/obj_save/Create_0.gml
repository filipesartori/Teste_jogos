meu_y_incial = 81;

image_alpha = .2;

blue = 255;
red = 255;
green = 255;

image_blend = make_color_rgb(red, green, blue);

meu_save = instance_number(obj_save);

meu_efeito = function (){
    image_blend = make_color_rgb(red, green, blue);
    
    var _mouse_sobre = position_meeting(mouse_x, mouse_y, id);
    var _mouse_click = mouse_check_button_released(mb_left);
    
    if (_mouse_sobre) {
    	y = lerp(y, meu_y_incial - 20, .2);
        image_alpha = lerp(image_alpha, .8, .2);
        red = lerp(red, 80, .2);
        blue = lerp(blue, 80, .2);
        green = lerp(green, 200, .2);
    }else {
    	y = lerp(y, meu_y_incial, .2);
        image_alpha = lerp(image_alpha, .2, .2);
        red = lerp(red, 255, .2);
        blue = lerp(blue, 255, .2);
        green = lerp(green, 255, .2);
    }
}

pega_save = function (){
    //tentar abrir o arquivo json do jogo e se ele conseguir ele retorna o arquivo e se ele nao conseguir ele retorna false
}