/* AUTOR: WELLERSON PRENHOLATO DE JESUS
  CURSO: CIÊNCIA DA COMPUTAÇÃO
  DISCIPLINA: COMPUTAÇÃO GRÁFICA
  */

PImage img;  // Declarando uma variável do tipo PImage

void setup() {
  //size(400, 400);
  noStroke();
  rectMode(CENTER);
  img = loadImage("rosa.jpg");   // carregando uma imagem da pasta /data/
  surface.setSize(img.width, img.height); // defini o tamanho da tela
}

void draw() {

  image(img, 0, 0);  // desenha a imagem (PImage, x, y, [largura, altura]*)  *opcionais 
  color cor = img.get(mouseX, mouseY); // pega a cor do pixel na posição x, y
  float R = red(img.get(mouseX, mouseY)); // pega a quantidade de vermelho do pixel na posição x, y
  float G = green(img.get(mouseX, mouseY)); // pega a quantidade de verde do pixel na posição x, y
  float B = blue(img.get(mouseX, mouseY)); // pega a quantidade de azul do pixel na posição x, y
  fill(cor);                          // pede o preenchimento!
  ellipse(mouseX, mouseY, 60, 60); // desenha um círculo
  fill(255, 0, 0); // vermelho
  rect(mouseX, mouseY + 60, R, 20); 
  fill(0, 255, 0); // verde
  rect(mouseX, mouseY + 80, G, 20);
  fill(0, 0, 255); // azul
  rect(mouseX, mouseY + 100, B, 20);
}
