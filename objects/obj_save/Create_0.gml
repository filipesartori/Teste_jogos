meu_y_incial = 81;

image_alpha = .2;

blue = 255;
red = 255;
green = 255;

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
        if (_mouse_click) {
        	var _lay = layer_get_id("inicio");
            var _seq = layer_get_all_elements(_lay);
            var _sq;
            
            //Encontrando dentro do arrwy op elemento que é a sequencia
            //rodando pelo vetor
            for (var i = 0; i < array_length(_seq); i++) {
            	//Checanso se o elemento atual é uams equencia
                var _atual = _seq[i];

                if (layer_get_element_type(_atual) == layerelementtype_sequence) {
                    //Se o elemento atual for minah sequencia eu salvoe le na minah avriavel sq e temrino oi loop
                	_sq = _atual;
                    
                    break;
                }
            }
            
            
            layer_sequence_play(_sq);
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