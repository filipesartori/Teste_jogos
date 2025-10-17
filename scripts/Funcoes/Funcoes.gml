///@function desenha_sombra(sprite, escala, [alpha], [cor])
function desenha_sombra(_sprite, _escala,  _alpha = .2, _cor = c_white,){
    draw_sprite_ext(_sprite, 0, x, y, _escala, _escala, 0, _cor, _alpha);
}

function ajusta_depth(){
    depth = -y;
}


//variaveis globais
global.debug = false;
global.pause = false;