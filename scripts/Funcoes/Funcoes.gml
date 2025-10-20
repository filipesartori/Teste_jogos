///@function desenha_sombra(sprite, escala, [alpha], [cor])
function desenha_sombra(_sprite, _escala,  _alpha = .2, _cor = c_white,){
    draw_sprite_ext(_sprite, 0, x, y, _escala, _escala, 0, _cor, _alpha);
}

function ajusta_depth(){
    depth = -y;
}

function cria_arma(_nome, _desc, _spr, _dano, _vel) constructor 
{
    //Criando o ID das armas
    static qtd_armas = 0;
    
    arma_id = qtd_armas++;
    nome    = _nome;
    desc    = _desc;
    spr     = _spr;
    dano    = _dano;
    vel     = _vel;
    
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
var _a = new cria_arma("Espadonha", "Uma espada feita de maconha", spr_espada, 3, 1);
var _b = new cria_arma("Machonha", "Um machado feito de maconha", spr_espada_2, 6, 0.5);
var _c = new cria_arma("Tridonha", "Um tridente feito de maconha", spr_espada_3, 2, 3);

//slavando minhas armas na lsita
ds_list_add(global.armas, _a, _b, _c);

//variaveis globais
global.debug = false;
global.pause = false;
global.inventario = ds_grid_create(4, 4);
