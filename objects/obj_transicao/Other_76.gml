//Vou ouvir a sequencia
var _evento = event_data[? "event_type"];

//Se eu recebi qualquer boradcast da sequencia
if (_evento == "sequence event") {
    //Salvandio a menssagem
    var _menssagem = event_data[? "message"];
    
    //Quando a mensagem for Terminei, ele muda de room
    
    switch (_menssagem) {
    	case "Terminei":
            //Muda de room
            room_goto(room_destino);
            //Destruindoa  layer
            layer_destroy(lay);
            
            //Posicionando o player
            player.x = destino_x;
            player.y = destino_y;
        
            //Ativando o player novamente
            alarm[0] = game_get_speed(gamespeed_fps)/2;
        break;
        
        case "Finalizou":
            layer_destroy(lay);
            instance_destroy();
        break;
    }
    
	
    
    //quando a mensagem for Finalizou ele se exclui
}