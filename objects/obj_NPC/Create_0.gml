larg = 40;
alt = 40;
margem = 5;

//criando a base do meu dialogo
dialogo = {
    texto   : ["Na faixa de gaza só homem bomba!", "Na guerra é tudo ou nada Várias titânio no pente, colete à prova de bala Nós desce pra pista pra fazer o assalto, mas 'tá fechadão no 12 Se eu 'to de rolé, é 600 bolado, perfume importado, pistola no coldre Mulher, ouro e poder, lutando que se conquista Nós não precisa de crédito, nós paga tudo à vista É Ecko, Lacoste, é peça da Oakley, várias camisa de time"],
    retrato : [spr_retrato_NPC, spr_retrato_player],
    txt_vel : .3
}

debug_area = function (){
  //Area de dialogo
    var _y = bbox_bottom + margem;
    draw_rectangle(x - larg / 2, _y, x + larg / 2, _y + alt, true);  
}

dialogo_area = function (){
    var _y = bbox_bottom + margem; 
    var _player = collision_rectangle(x - larg / 2, _y, x + larg / 2, _y + alt, obj_player, 0, 1);
    if (_player) {
        //Se eu apertar enter ou espaco eu entro no estado de dialogo
        if (keyboard_check_pressed(vk_space)) {
            if (_player.estado != _player.estado_dialogo) {
                with (_player) {
            	    estado = estado_indo_dialogo;
                    
                    //Passando quem é o NPC deste dialogo
                    npc_dialogo = other.id;
                }	
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