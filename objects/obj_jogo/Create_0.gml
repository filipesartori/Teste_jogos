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