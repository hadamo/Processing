//Esse código inverte separadamente cada canal RGB de uma imagem
//Autor: Danielli dos Reis Costa
//Obs.; Para mais informações acesse meu repositorio: https://github.com/daniellic9/AtividadesCG

PImage novo;
PImage novo2;

void setup(){
  size(1470,555);
  novo = loadImage("novo.jpg");
  novo2 = loadImage("novo.jpg");
}

void draw(){
  loadPixels();

  novo2.loadPixels();
 for (int y = 0; y < novo.height; y++) {
    for (int x=0; x < novo.width; x++) {
      int loc = x + y*novo.width;
      color c = novo.pixels[loc];
      //inverter canal vermelho
      //color newcolor= color(255-red(c),green(c),blue(c));
      
      // inverter canal verde
      //color newcolor= color(red(c),255-green(c),blue(c));
      
      //inverter canal azul
      //color newcolor= color(red(c),green(c),255-blue(c));
      
      //inverter vermelho, verde e azul
      color newcolor= color(255-red(c),255-green(c),255-blue(c));
      novo2.pixels[loc]=newcolor;
   }}
 updatePixels();
    image(novo,0,0);
    image(novo2,735,0);
}
