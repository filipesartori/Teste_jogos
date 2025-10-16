somb_scale = .5
//desenhando a sombra
if (image_index > 1) {
	somb_scale = .7
}

draw_self();

//Debug do meu estado
if (global.debug) {
    draw_set_halign(1);
    draw_set_valign(1);
    draw_text(x, y - sprite_height, estado);
    draw_set_halign(-1);
    draw_set_valign(-1);
    
    //Visualizando onde é o destino dele
    draw_circle(destino_x, destino_y, 16, false);
    
    //Desenhando meu campo de visao
    draw_circle(x, y, campo_visao, true);
}


