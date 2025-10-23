meu_y_incial = 81;

image_alpha = .2;

blue = 255;
red = 255;
green = 255;

global.iniciou = false;

image_blend = make_color_rgb(red, green, blue);

meu_save = instance_number(obj_save);

meus_dados = 0;

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
        
        //Checando se apessoa clicou em mim
        if (_mouse_click && global.iniciou == false) {
            
            global.iniciou = true;
            
            //Definindo o save do jogo
            global.save = meu_save - 1;
            
        	var _sq = pega_sequencia("inicio")
            
            layer_sequence_play(_sq);
            
            //Passando meus dados pro objeto jogo
            if (instance_exists(obj_jogo)) {
            	obj_jogo.dados = meus_dados;
            }
        }
    }else {
    	y = lerp(y, meu_y_incial, .2);
        image_alpha = lerp(image_alpha, .2, .2);
        red = lerp(red, 255, .2);
        blue = lerp(blue, 255, .2);
        green = lerp(green, 255, .2);
    }
}

pega_save = function (_save){
    //tentar abrir o arquivo json do jogo e se ele conseguir ele retorna o arquivo e se ele nao conseguir ele retorna false
    var _meu_arquivo = "Meu save"  + string(_save) + ".json";
    
    var _arquivo = file_text_open_read(_meu_arquivo);
    
    //Se o arquivo for invalido eu retorno false
    if (_arquivo == -1) {
    	return false;
    }
    
    //Salvando as informacoes
    var _string = file_text_read_string(_arquivo);
    
    //Convertando a string em uam sctruct
    var _dados = json_parse(_string);
    
    //Retornando os dados
    return _dados;
}

//pegando meu save
meus_dados = pega_save(meu_save);