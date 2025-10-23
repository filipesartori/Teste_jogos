//Usar as variaveis de movimento

ajusta_depth();

//Colisao horizontal
if (place_meeting(x + velh, y, obj_chao)) {
    //Pegando os dados do chao que eu vou bater
    var _chao = instance_place(x + velh, y, obj_chao);
    
    if (_chao) { // se o valor do chao for valido
    //Checando se estou indo pra esquerda ou direita
        if (velh > 0) { //Estou indo pra direita
            	//eu vou grudar na esquerda do chao
                x = _chao.bbox_left + (x - bbox_right);
            } else if (velh < 0) { //Estou indo pra esquerda
                //Vou grudar na direita do chao
            	x = _chao.bbox_right + (x - bbox_left);
            }
    }
    
    velh = 0;
}

x += velh;

//Colisao vertical
var _chao = instance_place(x, y + velv, obj_chao);
if(_chao) { // se o valor do chao for valido
    //Checando se estou descendo ou subindo
    if (velv > 0) { //descendo
    	y = _chao.bbox_top + (y - bbox_bottom);
    } else if (velv < 0) {
    	y = _chao.bbox_bottom + (y - bbox_top);
    }
    
    velv = 0;
}

y += velv;