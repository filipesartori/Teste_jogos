
//desenhar a minha sprite
draw_sprite_ext(sprite, image_ind, x, y, xscale, image_yscale, image_angle, image_blend, image_alpha);

//Debug do estado
if (global.debug){
    draw_set_valign(1);
    draw_set_halign(1);
    draw_text(x, y - sprite_height * 2, estado_txt);
    draw_set_valign(-1);
    draw_set_halign(-1);
}