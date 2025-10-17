ds_grid_clear(global.inventario, 0);

//Definindo o tamanho do GUI
display_set_gui_size(512, 288);

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

desenha_inventario = function (){
    //variaveis para saber a selecao X e Y
    static _sel_x = 0, _sel_y = 0;
    
    //pegando as dimesoes da minha GUI
    var _gui_w            = display_get_gui_width();
    var _gui_h            = display_get_gui_height();
    var _sprite_w         = sprite_get_width(spr_inventario_fundo);
    var _sprite_h         = sprite_get_height(spr_inventario_fundo);
    var _inv_w            = _gui_w * .6;
    var _inv_h            = _gui_h * .6;
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
    
    //desenhando quadrado na parte do grid
    //draw_rectangle(_item_x , _item_y, _item_x + _item_w, _item_y + _item_h, true);
    
    //Desenhnado retangulo das infos
    //draw_rectangle(_desc_x,  _desc_y, _desc_x + _desc_w, _desc_y + _desc_h, true);
    
    var _mouse_na_area = _mouse_x == clamp(_mouse_x, _item_x, _item_x + _item_w) &&
                         _mouse_y == clamp(_mouse_y, _item_y, _item_y + _item_h);
    
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
        }
    }
    
}