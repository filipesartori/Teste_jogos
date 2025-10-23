draw_self();

draw_set_font(fnt_Roboto_inicio);
draw_set_color(c_black);

var _marg = 10;
var _x = x + _marg;
var _y = y + _marg;

draw_text(_x, _y, "SAVE 0" + string(meu_save));

//Proximo texto deve variar em new game e continue
var _texto2 = meus_dados != false ? "CONTINUE" : "NEW GAME";

draw_text(_x, _y + 20, _texto2);

//Se os dados forem validos, ele deve escrever a vida total do player e a vida atual do player
if (meus_dados) {
	var _vida_total = meus_dados.player.max_vida;
    var _vida_atual = meus_dados.player.vida;
    draw_text(_x, _y + 50, "Hearts: " + string(_vida_total/2));
    draw_text(_x, _y + 70, "Life: " + string(_vida_atual/2));
}

draw_set_color(-1);
draw_set_font(-1);