ds_grid_clear(global.inventario, 0);

//Definindo o tamanho do GUI
display_set_gui_size(512, 288);

//Sistema de save usando json
salva_jogo = function (_save){
    //Alterando o nome do arquivo 
    var _arquivo = "Meu save"  + string(_save+1) + ".json"
    
    //Convertendo o inventario em um array
    var _inv;
    
    for (var i = 0; i < ds_grid_height(global.inventario); i++) {
    	for (var j = 0; j < ds_grid_width(global.inventario); j++) {
            //Salvando a info do inventario no meu vetro2d
        	_inv[j][i] = global.inventario[# j, i];
        }
    }
    
    
    //Criando a struct com meus dados
    var _dados = {
        //Criando uma struct com os dados do player
        player:
        {
            meu_x    : obj_player.x,
            meu_y    : obj_player.y,
            rm       : room,
            vida     : global.vida_player,
            max_vida : global.max_vida_player,
            arma     : global.arma_player
            
        },
        
        inventario: _inv
       
    }
    //Converter em json
    var _string = json_stringify(_dados);
    
    //Abrindo meu arquivo
    var _file = file_text_open_write(_arquivo);
    
    //escrevendo as informacoes
    file_text_write_string(_file, _string);
    
    //fechando meu arquivo
    file_text_close(_file);
}

//Carregando o jogo do json
carrega_jogo = function (_save){
    var _arquivo = "Meu save"  + string(_save+1) + ".json"
    
    //Abrindo o arquivo
    var _file = file_text_open_read(_arquivo);
    
    //Pegando os dados do arquivo
    var _string = file_text_read_string(_file);
    
    //fechando meu arquivo
    file_text_close(_file);
    
    //Convertendo a string em struct
    var _dados = json_parse(_string);
    
    //Passando as informacoes para o player
    obj_player.x           = _dados.player.meu_x;
    obj_player.y           = _dados.player.meu_y;
    room                   = _dados.player.rm;
    global.max_vida_player = _dados.player.max_vida;
    global.vida_player     = _dados.player.vida;
    global.arma_player     = _dados.player.arma;
    
    //Limpando meu inventario
    ds_grid_clear(global.inventario, 0);
    
    //Passando os dados do vetor do inventario apra ds_grid
    for (var i = 0; i < ds_grid_height(global.inventario); i++) {
    	for (var j = 0; j < ds_grid_width(global.inventario); j++) {
        	global.inventario[# j, i] = _dados.inventario[j][i];
            
            //ele nao comsegue salvar as estruturas com as funcoes
            //porem eu consigo saber qual item eu tenho lá
            //entao eu vou amndar ele recriar no inventario o item que deveria estar lá
            //Checando qual é o item, tipo e id do item
            var _item_atual = _dados.inventario[j][i];
            if (_item_atual) {
            	//Checar qual tipo de item
                switch (_item_atual._tipo) {
                	case item_tipo.armas:
                        //Colocando a arma correta no slot
                        global.inventario[# j, i] = global.armas[| _item_atual.arma_id];
                    break;
                    
                    case item_tipo.consumiveis:
                        global.inventario[# j, i] = global.consumiveis[| _item_atual.meu_id];
                    break;
                }
                	
            }
        }
    }
}

//me dando uma arma
global.inventario[# 2, 2] = global.armas[| armas.espadonha];
global.inventario[# 0, 1] = global.armas[| armas.machonha];
global.inventario[# 0, 0] = global.armas[| armas.tridonha];

global.inventario[#1, 0] = global.consumiveis[| consumievis.pocao_vermelha];
global.inventario[#1, 1] = global.consumiveis[| consumievis.pocao_coracao];

//Desenhando a vida do player
desenha_coracao = function (_x, _y){
    //Desenhando a quantidade de vida total sobre 2
    var _w = sprite_get_width(spr_coracao) / 1.5;
    for (var i = 0; i < global.max_vida_player; i += 2) {
    	draw_sprite(spr_coracao, 0, _x + i * _w, _y);
    }
    
    //Desenhnado os coracoes preenchidos
    for (var i = 0; i < global.vida_player; i += 2) {
        //garantindo que o img vai ficar com valor de 1 se a ultima vida tiver o valor impar
        var _img = ((global.vida_player - i) != 1) + 1;
        
    	draw_sprite(spr_coracao, _img, _x + i * _w, _y);
    }
    
}

encontra_item = function (_x, _y){
    return global.inventario[# _x, _y];
}

desenha_pause = function (){
    var _w = display_get_gui_width();
    var _h = display_get_gui_height();
    draw_set_alpha(.5)
    draw_rectangle_color(0, 0, _w, _h, c_black, c_black, c_black, c_black, 0);
    draw_set_alpha(1)
    
    
    
    if(!layer_exists("efeito_pause")){
        //Criar layer de desfoque
        var _blur = fx_create("_filter_linear_blur");
        fx_set_parameter(_blur, "g_LinearBlurVector", [5, 5]);
        
        layer_create(-10000, "efeito_pause");
        layer_set_fx("efeito_pause", _blur);
    }else {
    }
    
    //Criar o desfoque
    
    //configurar efeito blur
    
}

troca_item = function (_x, _y, _item){
    //Pegando o item na posicao do inventario
    var _item_guardado = global.inventario[# _x, _y];
    //Colocando o item que ele me deu na poisao do inverntario
    global.inventario[# _x, _y] = _item;
    
    return _item_guardado;
}

conta_armas = function (_arma){
    var _qtd = 0
    for (var i = 0; i < ds_grid_height(global.inventario); i++) {
    	for (var j = 0; j < ds_grid_width(global.inventario); j++) {
        	if (global.inventario[# j, i] == _arma) {
            	_qtd++;
            }
        }
    }
    return _qtd;
}

desenha_inventario = function (){
    //variaveis para saber a selecao X e Y
    static _sel_x = 0, _sel_y = 0;
    static _item_mouse = 0;
    
    //pegando as dimesoes da minha GUI
    var _gui_w            = display_get_gui_width();
    var _gui_h            = display_get_gui_height();
    var _sprite_w         = sprite_get_width(spr_inventario_fundo);
    var _sprite_h         = sprite_get_height(spr_inventario_fundo);
    var _inv_w            = _gui_w * .5;
    var _inv_h            = _gui_h * .5;
    var _inv_x            = _gui_w/2 - _inv_w/2;
    var _inv_y            = _gui_h/2 - _inv_h/2;
    var _inv_m_x          = _inv_w * 0.02;
    var _inv_m_y          = _inv_h * 0.04;
    var _item_x           = _inv_x + _inv_m_x;
    var _item_y           = _inv_y + _inv_m_y;
    var _item_w           = _inv_w * .7 - _inv_m_x;
    var _item_h           = _inv_h - _inv_m_y * 2;
    var _desc_x           = _item_x + _item_w + _inv_m_x;
    var _desc_y           = _item_y;
    var _desc_w           = _inv_w * .3 - _inv_m_x * 2;
    var _desc_h           = _item_h;
    var _cols             = ds_grid_width(global.inventario); 
    var _lins             = ds_grid_height(global.inventario); 
    var _grid_marge_x     = _item_w * .02;
    var _grid_marge_y     = _item_h * .02;
    var _grid_w           = (_item_w - _cols * _grid_marge_x) div _cols;
    var _grid_h           = (_item_h - _lins * _grid_marge_y) div _lins;
    var _mouse_x          = device_mouse_x_to_gui(0);
    var _mouse_y          = device_mouse_y_to_gui(0);

    //Desenhando o fundo do inventario
    draw_sprite_stretched(spr_inventario_fundo, 0, _inv_x, _inv_y, _inv_w, _inv_h);
    
    var _mouse_na_area = _mouse_x == clamp(_mouse_x, _item_x, _item_x + _item_w) &&
                         _mouse_y == clamp(_mouse_y, _item_y, _item_y + _item_h);
    
    //Usando o item quando eu apertar o botao direito do mouse se eu estiver na area correta
    if (_mouse_na_area) {
    	//usando item com o botao direito do mouse
        var _item_sel = global.inventario[# _sel_x, _sel_y]
        if (mouse_check_button_released(mb_right)) {
        	//Se existe um item nessa posicao
            if (_item_sel) {
            	_item_sel.usa_item();
                
                //Checando se esse item é consumivel
                if (_item_sel._tipo == item_tipo.consumiveis) {
                	//apagando o item
                    global.inventario[# _sel_x, _sel_y] = 0;
                }
            }
        }
        if (mouse_check_button_released(mb_left)) {
        	//Se eu cloquei com o botao esqeurdo eu qeuro poder mover o item
            _item_mouse = troca_item(_sel_x, _sel_y, _item_mouse);
            
        }
    } else { // Mouse nao esta na area do inventario
    	//Se eu cloquei fora dele e estou com item eu jogo fora o item
        if (_item_mouse && mouse_check_button_released(mb_left)) {
            //Checando quantas armas igauis eu tenho
            var _qtd_armas = conta_armas(global.arma_player);
            
            if (_item_mouse != global.arma_player or _qtd_armas > 0) {
            	var _novo_item = instance_create_layer(mouse_x, mouse_y, "Instances", obj_itens);
                //Avisando ao item, qual item ele é
                _novo_item.item = _item_mouse;
                //Apagando do inventario
                _item_mouse = 0;
            }
        	 
        }
    }
    
    var _equip_x = _inv_x + _inv_w / 2 - _grid_w/2;
    var _equip_y = _inv_y - _grid_h;
    //Desnehando a caixa do item equipado
    draw_sprite_stretched(spr_inventario_fundo, 0, _equip_x, _equip_y, _grid_w, _grid_h);
    //Desenhando o item na caixa de equipado
    if (global.arma_player) {
        var _equip_w = _grid_w * .5
        var _equip_h = _grid_h * .5
    	draw_sprite_stretched(global.arma_player.spr, 0, _equip_x + _equip_w/2, _equip_y + _equip_h/2, _equip_w, _equip_h);
    }
    //Desenhando os itens nos espcaos dos itens
    for(var i = 0; i < _lins; i++){
        for (var j = 0; j < _cols; j++) {
            //Garantir se esse codigo so vai rodar se eu estiver com mouse na area de selecao
            //Checando a posicao do mouse dentro do espaco do item
            //Criando o espaco inicial e levando em conta a margem dos itens
            if(_mouse_na_area){
                _sel_y = (_mouse_y - _item_y - (_grid_marge_y * i)) div _grid_h;
                _sel_x = (_mouse_x - _item_x - (_grid_marge_x * j)) div _grid_w;    
            }
            //Garantindo q o sel_x e o sel_y nao passem dos limites da minha grid
            _sel_x = clamp(_sel_x, 0, _cols-1);
            _sel_y = clamp(_sel_y, 0, _lins-1);
            
            //Levar a margemda  grid em conta, em relacao ao j e i
            var _x1 = _item_x + _grid_w * j + (_grid_marge_x * j) + _grid_marge_x;
            var _y1 = _item_y + _grid_h * i + (_grid_marge_y * i) + _grid_marge_y;
            
            //Checando se a caixa que eu estou ddesenhando agora, é da selecao atual
            var _selecionado = (_sel_x == j && _sel_y == i);
            
        	draw_sprite_stretched(spr_inventario_caixa, _selecionado, _x1, _y1, _grid_w, _grid_h);
            
            //Checando se na minah selecao atual tem item
            var _item_atual = encontra_item(j, i);
            //Se a sel atual contem algum valor entoa eu tenho algum item
            if (_item_atual) {
            	//Desenhar sprite do item
                var _item_atual_w = _grid_w * .5;
                var _item_atual_h = _grid_h * .5;
                var _item_atual_x = _x1 + _item_atual_w / 2;
                var _item_atual_y = _y1 + _item_atual_h / 2;
                
                draw_sprite_stretched(_item_atual.spr, 0, _item_atual_x, _item_atual_y, _item_atual_w, _item_atual_h);
            }
            
            //pegando o item que o cursor esta por cima
            var _sel_atual = encontra_item(_sel_x, _sel_y);
            
            //Se eu tenho algum item na selecao atual, eu desenho ele no espaco de descricao
            if (_sel_atual) {
                var _sel_atual_spr_w = sprite_get_width(_sel_atual.spr)
                var _sel_atual_w = _grid_w * .5;
                var _sel_atual_h = _grid_h * .5;
                
                //Ajustando a escala da sprite
                var _sel_atual_escala = _sel_atual_w / _sel_atual_spr_w;
                
                var _sel_atual_x = _desc_x + _desc_w/2;
                var _sel_atual_y = _desc_y + _sel_atual_h;
                var _efeito_x    = sin(2 * get_timer() / 1000000);
                
            	//Desnehando a sprite
                //draw_sprite_stretched(_sel_atual.spr, 0, _sel_atual_x, _sel_atual_y, _sel_atual_w * _efeito_x, _sel_atual_h);
                draw_sprite_ext(_sel_atual.spr, 0, _sel_atual_x, _sel_atual_y, _sel_atual_escala * _efeito_x, _sel_atual_escala, 0, c_white, 1);
                draw_set_font(fnt_Roboto);
                draw_set_halign(1);
                //Desenhando o texto
                //draw_text_ext(_sel_atual_x, _sel_atual_y + _sel_atual_h, _sel_atual.desc, 20, _desc_w);
                var _sep = string_height("I");
                //Desenhando a minha fonte em escala
                draw_set_color(c_black);
                draw_text_ext_transformed(_sel_atual_x + 1, (_sel_atual_y + _sel_atual_h) + 1, _sel_atual.desc, _sep, _desc_w * 3 , .3, .3, 0);
                draw_set_color(c_white);
                draw_text_ext_transformed(_sel_atual_x, (_sel_atual_y + _sel_atual_h), _sel_atual.desc, _sep, _desc_w * 3 , .3, .3, 0);
                
                draw_set_halign(-1);
                draw_set_font(-1);
            }
        }
        
         //Desenhando o item no mouse
        if (_item_mouse) {
        	draw_sprite_stretched(_item_mouse.spr, 0, _mouse_x, _mouse_y, _grid_w /2, _grid_h /2)
        }
    }
    
}