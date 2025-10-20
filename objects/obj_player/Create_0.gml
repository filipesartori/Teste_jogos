// Inherit the parent event
event_inherited();

#region Variaveis

max_vel  = 3;
meu_acel = .1
acel     = meu_acel;
roll_vel = 5;

estado     = noone;
estado_txt = "parado"

face   = 0;
sprite = sprite_index;
xscale = 1;

seq_especial = noone;

attack = false;
shield = false;
rool   = false;

somb_scale = .6;
somb_alpha = .2;

npc_dialogo = noone;

//Imagem atual da animacao
image_ind = 0;

//Velocidade da animacao
image_spd = 8 / game_get_speed(gamespeed_fps);

//Quantidade de imagens na minha sprite
image_num = 1;

//Array 2D para controlar as sprites
sprites = [
            //Sprites parado - SEMPRE COLOCAR AS SPRITES NA ORDEM DAS FACES
            [spr_player_idle_right, spr_player_idle_up, spr_player_idle_right, spr_player_idle_down],
            //Sprites correndo
            [spr_player_move_right, spr_player_move_up, spr_player_move_right, spr_player_move_down],
            //Sprites ataque
            [spr_player_attack_right, spr_player_attack_up, spr_player_attack_right, spr_player_attack_down],
            //Sprite defesa
            [spr_player_shield_right, spr_player_shield_up, spr_player_shield_right, spr_player_shield_down],
            //Sprite roll
            [spr_player_rool_right, spr_player_rool_up, spr_player_rool_right, spr_player_rool_down]
          ];

sprites_index = 0;

//Mapeando as teclas, logo as duas fazem a mesma coisa
keyboard_set_map(ord("A"), vk_left);
keyboard_set_map(ord("D"), vk_right);
keyboard_set_map(ord("W"), vk_up);
keyboard_set_map(ord("S"), vk_down);
keyboard_set_map(ord("J"), ord("C"));
keyboard_set_map(ord("L"), ord("Z"));
keyboard_set_map(ord("K"), ord("X"));
keyboard_set_map(vk_enter, vk_space);

#endregion

ajusta_sprite = function (_indice_vetor){
    //Checando se a imagem que estou usando é oque eud everia estar usando
    if (sprite != sprites[_indice_vetor][face]) {
    	//Acabei de entrar no estado e garantindo que a imagem comeca do comeco
        image_ind = 0;
        
    }
    
    sprite = sprites[_indice_vetor][face];
    
    //Descobrindo o numero de imagens na minah sprite
    image_num = sprite_get_number(sprite);
    
    //Aumentando o valor do image_ind com base no image_spd
    image_ind += image_spd;
    
    //Zerando o imagem ind depois da animacao acabar
    image_ind %= image_num;
}

controla_player = function (){
    var _up     = keyboard_check(vk_up);
    var _down   = keyboard_check(vk_down);
    var _left   = keyboard_check(vk_left);
    var _right  = keyboard_check(vk_right);
    attack      = keyboard_check_pressed(ord("C"));
    roll        = keyboard_check_pressed(ord("X"));
    shield      = keyboard_check(ord("Z"));
    
    if (keyboard_check_pressed(vk_control) && global.arma_player) {
    	estado = estado_ataque_especial;
    }
    
    //Ajustando a face
    if (_up) face    = 1;
    if (_down) face  = 3;
    if (_left) {face  = 2; xscale = -1;}
    if (_right) {face = 0; xscale = 1;}
    
    //Só faco issos e estou apertando alguma tecla, sem apertar os dois ao mesmo  tempo

    if ((_up xor _down) or (_left xor _right)) {
    	//Descobrindo a direcao em q o player esta indo, usando point direction
        var _dir = point_direction(0, 0, (_right - _left), (_down - _up))
        
        //Pegando o valor de velh
        var _max_velh = lengthdir_x(max_vel, _dir);
        velh = lerp(velh, _max_velh, acel);
        //pegando valor do velv
        var _max_velv = lengthdir_y(max_vel, _dir);
        velv = lerp(velv, _max_velv, acel);
    } else {
        //perdendo velocidade
    	velh = lerp(velh, 0, acel);
        velv = lerp(velv, 0, acel);
    }    
    
}

estado_parado = function (){
    
    controla_player();
    
    estado_txt = "parado";
    sprites_index = 0;
    
    //ficando parado
    velv = 0;
    velh = 0;
    
    var _up     = keyboard_check(vk_up);
    var _down   = keyboard_check(vk_down);
    var _left   = keyboard_check(vk_left);
    var _right  = keyboard_check(vk_right);
    
    //Definindo sprites
    ajusta_sprite(sprites_index);
    
    //saindo do meu estado de parado
    if ((_up xor _down) or (_left xor _right)) {
    	estado = estado_movendo;
    }
    
    //Indo para o estado de ataque
    if (attack && global.arma_player) {
    	estado = estado_ataque;
    }
    if (shield) {
    	estado = estado_defesa;
    }
    if (roll) {
    	estado = estado_rolando;
    }
    
}

estado_movendo = function (){
    
    controla_player();
    
    estado_txt = "movendo";
    sprites_index = 1;
    
    //Definindo a sprite correta
    ajusta_sprite(sprites_index); 
    
    //Ajustando a sombra
    //Checar se a sprite ta no chao
    if (clamp(image_ind, 1, 3) == image_ind) {
    	//estou no chao
        somb_scale = .6;
    }else {
    	somb_scale = .4;
    }
    
    
    //Saindo do estado de movendo
    if (abs(velv) <= 0.2 && abs(velh) <= 0.2) {
    	estado = estado_parado;
        somb_scale = .6;
    }
    
    if (attack && global.arma_player) {
    	estado = estado_ataque;
        somb_scale = .6;
    }
    if (shield) {
    	estado = estado_defesa;
        somb_scale = .6;
    }
    if (roll) {
    	estado = estado_rolando;
        somb_scale = .6;
    }
}

estado_ataque = function () {
    static _meu_dano = noone;
    
    estado_txt = "ataque";
    
    ajusta_sprite(2);
    
    velh = 0;
    velv = 0;
    
    //preciso criar o dano
    //Só crio o dano se eu n tenho um dano
    if (!_meu_dano) {
    	var _dano_x = x + lengthdir_x(sprite_width, face * 90);
        var _dano_y = y + lengthdir_y(sprite_height, face * 90);
        //A face esta olhando para cima se sim o valor de add é metade da sprite, caso contrario o valor de add é 0
        var _add    = face == 1 ? sprite_height / 2 : 0;
        
        _meu_dano = instance_create_depth(_dano_x, _dano_y - (sprite_height/2) + _add, depth, obj_dano);
    }
    
    
    //Saindo do estado de ataque
    if (image_ind + image_spd >= image_num) {
    	estado = estado_parado;
        
        //Resetando o meu dano
        instance_destroy(_meu_dano);
        _meu_dano = noone;
    }
}

estado_ataque_especial = function (){
    image_alpha = 0;
    velh = 0;
    velv = 0;
    //controla_player();
    estado_txt = "Ataque Especial"
    //Preciso ver se tenho uma espada
    if (global.arma_player) {
    	if (!seq_especial) {
        	//Usando o atk especial dessa espada
            seq_especial = global.arma_player.esp();
        }
    }else {
    	estado = estado_parado;
    }
    
    //checando se a animacao acabou
    if (seq_especial) {
    	if (layer_sequence_is_finished(seq_especial)) {
        	estado = estado_parado;
            image_alpha = 1;
            layer_sequence_destroy(seq_especial);
            seq_especial = noone;
            
            //Se a layer especial existe eu destruo
            if (layer_exists("ataque_especial")) {
            	layer_destroy("ataque_especial");
            }
        }
    }else {
    	estado = estado_parado;
        image_alpha = 1;
    }
    
}

estado_defesa = function (){
    estado_txt = "defesa"
    
    //Controlando o player
    controla_player();
    
    ajusta_sprite(3);
    
    //Garantindo que estou parado
    velv = 0;
    velh = 0;
    
    //Saindo do estado
    if (!shield) {
    	estado = estado_parado;
    }
}

estado_rolando = function (){
    //Pegando as teclas
    
    
    
    if (estado_txt != "rolando") {
        //Pegando as teclas para rolar na direcao certa
        var _up     = keyboard_check(vk_up);
        var _down   = keyboard_check(vk_down);
        var _left   = keyboard_check(vk_left);
        var _right  = keyboard_check(vk_right);
        
    	//Se nao é igual é pq eu acabei de entrar no estado
        
        //Achando minha direcao
        if ((_up xor _down) or (_right xor _left)){
            var _dir_r = point_direction(0, 0, _right - _left, _down - _up);
            velh = lengthdir_x(roll_vel, _dir_r);
            velv = lengthdir_y(roll_vel, _dir_r);
        }else { // caso contrario rolo na direcao que estou virado
        	velh = lengthdir_x(roll_vel, face * 90)
            velv = lengthdir_y(roll_vel, face * 90)
        }
        //Pulando um frame
        image_ind++;
        
    }
    
    estado_txt = "rolando";
    
    //Peguei a sprite certa
    ajusta_sprite(4);
    
    //Ajustando a velocidade
    //Vou definir um tempo para animacao, e com base nesse tempo ele vai ajustar o image_spd
    //Sabendo quantos frames a sprite tem
    image_spd = sprite_get_number(sprite) / (game_get_speed(gamespeed_fps) / 4);
    
    //Saindo do estado de rolando
    if (image_ind + image_spd  >= image_num) {
    	estado = estado_parado;
        
        //Resetnado minha image_spd
        image_spd = 8 / game_get_speed(gamespeed_fps);
    }
}

estado_indo_dialogo = function (){
    velh = 0;
    velv = 0;
    
    ajusta_sprite(1);
    
    //Checando se estou na direita ou esquerda
    //Me movendo na horizontal se eu nao estou na posicao correta
    if (npc_dialogo) {
        var _x = npc_dialogo.x
        var _y = npc_dialogo.y + npc_dialogo.margem;
        if (bbox_top != _y) {
        	//Ajustando velv
            velv = sign(_y - bbox_top);
            
            //Ajustando a face
            face = velv < 0 ? 1 : 3;
            
            y = round(y);
        } else if (x != _x){
            face = 0;
            velh = sign(_x - x);
            xscale = velh;
            x = round(x);
        } else {
        	estado = estado_dialogo;
            
        }
    }
}

estado_dialogo = function (){
    estado_txt = "Dialogo";
    velh = 0;
    velv = 0;
    face = 1;
    ajusta_sprite(0);
    
    //Criando o dialogo
    //Checando se ele ainda n existe
    if (!instance_exists(obj_dialogo)) {
    	var _obj_dialogo = instance_create_depth(0, 0, 0, obj_dialogo);
        _obj_dialogo.player = id;
        
        //Passando o dialogo do NPC para o obj dialogo
        with (npc_dialogo) {
                        //Dialogo do objeto dialogo   dialogo do NPC
        	_obj_dialogo.dialogo                    = dialogo;                   
        }
    }
}

estado = estado_parado;
