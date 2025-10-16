// Inherit the parent event
event_inherited();

max_vel = 2;

estado = "Parado";
alvo = false;
campo_visao = 100;
destino_x = 0;
destino_y = 0;
tempo_persegue = game_get_speed(gamespeed_fps) * 2;
t_persegue = tempo_persegue;
tempo_ataque = game_get_speed(gamespeed_fps) * .2;
t_ataque = tempo_ataque;
somb_alpha = .3;

tempo_estado = game_get_speed(gamespeed_fps) * 1;
tempo = tempo_estado;

image_speed = 8 / game_get_speed(gamespeed_fps);

controla_sprite = function (){
    var _dir = point_direction(0, 0, velh, velv);
    
    
    //Se estou indo apra a direita eu olho para a direita
    //Direita
    
    //Pegando para qual direcao ele ta olhando, Sendo q o div retorna uma divao apenas dos inteiros
    var _face = _dir div 90;
    
    switch(_face){
        case 0:
            sprite_index = spr_cogumelo_right; 
            image_xscale = 1;   
        break;
        case 1:
            sprite_index = spr_cogumelo_up;    
        break;
        case 2:
            sprite_index = spr_cogumelo_right; 
            image_xscale = -1;     
        break
        case 3:
            sprite_index = spr_cogumelo_down;    
        break
    }
    //Cima
    //Esquerda
    //Baixo
}

muda_estado = function () {
     //checando se eu estou com mouse em cima do meu inimigo
    var _mouse_sobre = position_meeting(mouse_x, mouse_y, id);
    
    //Checando se clicaram com o butao do meio
    var _click = mouse_check_button_released(mb_middle);
    
    //Se a pessoa clicou em quanto o mouse esta sobre o inimido ele muda o estado
    if (_mouse_sobre && _click){
        estado = get_string("Digite o Estado", "Parado");
    }
}

//Observendo o player
olhando = function () {
    var _player = collision_circle(x, y, campo_visao, obj_player, 0, 1);
    
    //Se o player entrou no campo de visao, eu sigo ele
    if (_player && t_persegue <= 0) {
    	estado = "Persegue";
        alvo = _player;
    }
}

controla_estado = function () {
    
    switch(estado){
        case "Parado":
            image_speed = 8 / game_get_speed(gamespeed_fps);
        
            //Diminuindo o timer de persegue
            if(t_persegue > 0) t_persegue--;
        
            //Diminuindo o tempo
            tempo--;
            image_blend = c_white
            //Deve ficar parado
            velh = 0;
            velv = 0;
        
            //Regra para siar deste estado
            if (tempo <= 0){ //Mudando de estado
                estado = choose("Parado", "Andando");
                
                //Resetando timer
                tempo = tempo_estado;
            }
            //Regra oara o estado de persgue
            olhando();
        
        break;
        
        case "Andando":
            
            image_speed = 12 / game_get_speed(gamespeed_fps);
            
            if(t_persegue > 0) t_persegue--;
                
            tempo--;
            image_blend = c_white
            //Checando se ainda nao tenho destino
            //Quando chegar no destino, escolho outro destino
        
            //Checar a minha distancia para o destino
            var _dist = point_distance(x, y, destino_x, destino_y);
        
            if (destino_x == 0 or destino_y == 0  or _dist < max_vel * 2) {
            	//Escolhendo um destino
                destino_x = random_range(0, room_width);
                destino_y = random_range(0, room_height);
            }
        
            //Andando até o ponto
            
            //Descobrindo a direcao que tenho que ir
            var _dir = point_direction(x, y, destino_x, destino_y);
        
            
        
            //Dando valor apra meu velh
            velh = lengthdir_x(max_vel, _dir);
            //Dando valor para meu velv
            velv = lengthdir_y(max_vel, _dir);
        
            //Se eu bati em uma parede andando, eu paro
            if (place_meeting(x + velh, y + velv, obj_chao)) {
            	estado = "Parado"
                tempo = tempo_estado;
                destino_x = 0;
                destino_y = 0;
            }
            
            //regra para mudar de estado
            if (tempo <= 0 ) {
            	tempo = tempo_estado;
                estado = choose("Parado", "Andando", "Andando");
                
                //Resetando meu destino
                destino_x = 0;
                destino_y = 0;
            }
            //Regra oara o estado de persgue
            //Só posso perseguir o player se meu t_persegue ja acabou
            olhando();
        
        break;    
        
        case "Persegue":
            //Quando ele tiver perseguindo o player ele vai ter uma cor diferente
            image_blend = c_orange;
            image_speed = 16 / game_get_speed(gamespeed_fps);
        
            //Indo na direcao do player
            if (alvo) {
            	destino_x = alvo.x;
                destino_y = alvo.y;
            } else {
            	//Vou para outro estado
                estado = choose("Parado", "Andando", "Parado");
                destino_x = 0;
                destino_y = 0;
                tempo = tempo_estado;
            }
        
            var _dir_p = point_direction(x, y, destino_x, destino_y);
            velh = lengthdir_x(max_vel, _dir_p);
            velv = lengthdir_y(max_vel, _dir_p); 
        
            //Regra para deixar de seguir o player
            var _dist_p = point_distance(x, y, destino_x, destino_y);
        
            //Player saiu do meu campo de visao + 70
            if (_dist_p > campo_visao + 70) {
            	alvo = false;
                tempo = tempo_estado;
                destino_x = 0;
                destino_y = 0;
            }
        
            //Checandos e estou muito proxmo do player
            if (_dist_p < campo_visao / 3) {
            	estado = "carrega_ataque"
                tempo = tempo_estado;
            }
        
        break;
        
        case "Ataque":
            image_blend = c_red
            
            //Resetando o time de persegue
            t_persegue = tempo_persegue;
        
            //Ficando mais rapido 
            var _dir_a = point_direction(x, y, destino_x, destino_y)
        
            velh = lengthdir_x(max_vel * 4, _dir_a);
            velv = lengthdir_y(max_vel * 4, _dir_a);
        
            //Se eu cheguei no meu destino, eu fico de boas
            var _dist_a = point_distance(x, y, destino_x, destino_y)
            if (_dist_a < 10) {
            	estado = "Parado";
            }
            
        
        break;
        
        case "carrega_ataque":
            t_ataque--;
            velh = 0;
            velv = 0;
        
            var _green = (t_ataque / tempo_ataque) * 255;
            var _blue = (t_ataque / tempo_ataque) * 120;
        
             //Alterando o image blend
            image_blend = make_color_rgb(255, _green, _blue); 
        
            if(t_ataque <= 0){
                estado = "Ataque";
                t_ataque = tempo_ataque;
            }
        
        
        break;
    }

}