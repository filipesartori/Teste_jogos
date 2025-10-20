///@function desenha_sombra(sprite, escala, [alpha], [cor])
function desenha_sombra(_sprite, _escala,  _alpha = .2, _cor = c_white,){
    draw_sprite_ext(_sprite, 0, x, y, _escala, _escala, 0, _cor, _alpha);
}

function ajusta_depth(){
    depth = -y;
}

function cria_arma(_nome, _desc, _spr, _dano, _vel, _esp) constructor 
{
    //Criando o ID das armas
    static qtd_armas = 0;
    
    arma_id = qtd_armas++;
    nome    = _nome;
    desc    = _desc;
    spr     = _spr;
    dano    = _dano;
    vel     = _vel;
    esp     = _esp;
    
    usa_item = function (){
        //equipando minha arma
        global.arma_player = global.armas[| arma_id];
    }
    
    pega_item = function (){
        var _cols = ds_grid_width(global.inventario);
        var _lins = ds_grid_height(global.inventario);
        //Checar se tem espaco vazio no inventario
        for (var i = 0; i < _lins; i++) {
        	for (var j = 0; j < _cols; j++) {
            	//Se o slot atual ta vazio eu entro nele
                var _atual = global.inventario[# j, i]
                if (!_atual) {
                	//Eu vou apra estes slot, pois ele vai estar vazio
                    global.inventario[# j, i] = global.armas[| arma_id];
                    
                    //Consegui me equipar eu aviso que deu certo
                    return true;
                }
            }
        }
        
        //Terminou o laco e nao encontrou um slot retorno falso
        return false;
        
    }
}

enum armas 
{
    espadonha,
    machonha,
    tridonha
}

//Criando a minha lista de armas
global.armas = ds_list_create();
global.arma_player = noone;

//Criando as armas
var _a = new cria_arma("Espadonha", "Uma espada feita de maconha", spr_espada, 3, 1, espadonha_atk);
var _b = new cria_arma("Machonha", "Um machado feito de maconha", spr_espada_2, 6, 0.5, machonha_atk);
var _c = new cria_arma("Tridonha", "Um tridente feito de maconha", spr_espada_3, 2, 3, tridonha_atk);

//slavando minhas armas na lsita
ds_list_add(global.armas, _a, _b, _c);

//Criando o ataque especial da espadonha
function espadonha_atk () {
    if (instance_exists(obj_player)) {
    	with (obj_player) {
            //Pegando minha sequencia e modificando para ela olhar para a direcao correta
            var _nova_seq = ajusta_sp_seq([sprite, sprites[2, face]], sq_ataque_1);
            
        	//Criando a layer da sequencia
            var _layer = layer_create(depth, "ataque_especial");
            
            //Criando a minha sequencia
            var _seq = layer_sequence_create(_layer, x, y, _nova_seq);
            
            //Devolvo a sequencia criada apra quem chamou a funcao
            return _seq;
        }
    }
    
    return false;
}

function tridonha_atk(){
    if (instance_exists(obj_player)) {
    	with (obj_player) {
        	//Pegando e modificando a sequencia
            var _nova_seq = ajusta_sp_seq([sprites[2, face]], sq_ataque_2);
            
            //Criando a layer da sequencia e a sequencia
            var _layer = layer_create(depth, "ataque_especial");
            var _seq = layer_sequence_create(_layer, x, y, _nova_seq);
            
            //Fazendo a sequencia olhar pro lado certo
            layer_sequence_xscale(_seq, xscale);
            
            //Criar o projetil
            var _tiro = instance_create_depth(x, y - sprite_height/2, depth, obj_projetil);
            _tiro.image_speed = 0;
            _tiro.speed = 5;
            _tiro.direction = face * 90;
            _tiro.image_angle = face * 90 - 45;
            
            return _seq;
        }
    }
    
    return false;
}

function machonha_atk(){
    if (instance_exists(obj_player)) {
    	with (obj_player) {
        	var _layer = layer_create(-10000, "ataque_especial");
            var _seq = layer_sequence_create(_layer, x, y, sq_ataque_3);
            
            return _seq;
        }
    }
    return false;
}

//Funcao para ajustar as sprites na sequencia
function ajusta_sp_seq(_sprites, _sq){
    //pegando a sequencia
    var _nova_seq = sequence_get(_sq);
    
    //Checando o tamanho do array
    var _qtd = array_length(_sprites)
    
    //Indo da track 0 até a track equivalente a do array
    for (var i = 0; i < _qtd; i++) {
    	//Pegando valor atual do array
        var _atual = _sprites[i]
        
        //Só vou mexer na track que tem um valor
        if (_atual) { 
            _nova_seq.tracks[i].keyframes[0].channels[0].spriteIndex = _atual;
        }
    }
    //Retornando a sequencia modificada
    return _nova_seq
}

function screenshake(){
    var _shake = fx_create("_filter_screenshake");
    
    //Criando a layer dele
    var _layer = layer_create(-10000, "shake")
    
    layer_set_fx(_layer, _shake);
}

function termina_shake(){
    layer_destroy("shake");
}

//variaveis globais
global.debug = false;
global.pause = false;
global.inventario = ds_grid_create(4, 4);
