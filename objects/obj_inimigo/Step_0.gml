if (global.pause or instance_exists(obj_transicao)){
    exit;
}

//Controlando os estados do inimigo
muda_estado();
controla_estado();
controla_sprite();