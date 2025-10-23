// Inherit the parent event
event_inherited();

#region variaveis comuns a todos o inimigos
destino_x      = 0;
destino_y      = 0;
vida_max       = 1;
max_vel        = 2;
dano           = 0;
sprites        = [];
somb_alpha     = .3;
campo_visao    = 100;
alvo           = false;
vida_atual     = vida_max;
estado         = "Parado";
tempo_dano     = game_get_speed(gamespeed_fps)/2;
image_speed    = 8 / game_get_speed(gamespeed_fps);
tempo_estado   = game_get_speed(gamespeed_fps) * 1;
tempo_persegue = game_get_speed(gamespeed_fps) * 2;
tempo_ataque   = game_get_speed(gamespeed_fps) * .2;
timer_dano     = tempo_dano;
t_ataque       = tempo_ataque;
tempo          = tempo_estado;
t_persegue     = tempo_persegue;
dano_dir       = 0; 
tempo_pisca    = 8;
timer_pisca    = 0;
meu_dano       = 1;
#endregion

#region comportamentos/metodos

//knockback = function (_x, _y){
    //var _dir = point_direction(_x, _y, x, y);
    //velh = lengthdir_x(2, _dir);
    //velv = lengthdir_y(2, _dir);
//}

controla_sprite = function (){
    var _dir = point_direction(0, 0, velh, velv);
    
    //Se estou indo apra a direita eu olho para a direita
    //Pegando para qual direcao ele ta olhando, Sendo q o div retorna uma divao apenas dos inteiros
    var _face = _dir div 90;
    
    switch(_face){
        case 0:
            sprite_index = sprites[0]; 
            image_xscale = 1;   
        break;
        case 1:
            sprite_index = sprites[1];    
        break;
        case 2:
            sprite_index = sprites[2]; 
            image_xscale = -1;     
        break
        case 3:
            sprite_index = sprites[3];    
        break
    }
}

#endregion

toma_dano = function (_dano = 1){
    //Só levo danos e aindo nao estou levando dano
    if (estado != "dano") {
    	estado = "dano";
        dano = _dano;
    }
    
}

aplica_dano_player = function (){
    //Checando se estou colidindo com palyer
    var _player = instance_place(x, y, obj_player);
    
    //Se eu toquei no player entao eu aplico o dano
    if (_player) {
        _player.dano_dir = point_direction(0, 0, velh, velv);
    	_player.toma_dano(meu_dano);
    }
}