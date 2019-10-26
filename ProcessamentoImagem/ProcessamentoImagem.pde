// importacao de bibliotecas
import boofcv.processing.*;
import boofcv.struct.image.*;

// imagem original - a ser processada
PImage img_original;


void setup() {
  size(768,512);
  //img_original = loadImage("lena.png");
  //img_original = loadImage("pokemon.png");
  //img_original = loadImage("bat.png");
  img_original = loadImage("lobo.png");
  //img_original.resize(768,512);
}

void draw() {
  // Declaração de variáveis  
  // imagens
  PImage img_escala_cinza , limiarizacao , img_alg_parte1, img_sem_ruido, img_or; 
  // auxiliar para processo de limiarizacao, salva o limiar da imagem
  double limiar; 
  // Objetos do tipo SimpleBinary
  SimpleBinary img_bin_ruidos, img_binaria;
  // Objeto do tipo SimpleGray 
  SimpleGray img_gray; 
  // auxiliares para calcular valor dos pixels da imagem original ( cor, posicao, diferenca de brilho )
  color pixel_after, pixel_ant; 
  int x, y, loc_after, loc_ant; //
  float diferenca_brilho;  
  
  // Carrega pixels
  img_alg_parte1 = img_original.get();
  img_original.loadPixels();
  img_alg_parte1.loadPixels();

  //Algoritmo parte 1
  for (x = 1; x < img_original.width; x++) {
    for (y = 0; y < img_original.height; y++ ) {
      // loop para percorrer os pixels da imagem, exceto os da primeira coluna, 
      // faz a o modulo da diferenca de brilho do pixel atual com o anterior
      // salva um novo pixel com cor( diferenca do brilho obtida )
      loc_ant = x + y * img_original.width;
      loc_after = ( x - 1 ) + y*img_original.width;
      pixel_ant = img_original.pixels[ loc_ant ];
      pixel_after = img_original.pixels[ loc_after ];
      diferenca_brilho = (abs(brightness(pixel_ant) - brightness(pixel_after)));
      img_alg_parte1.pixels[ loc_ant ] = color ( diferenca_brilho );
    }
  }
  // atualiza os pixels
  img_alg_parte1.updatePixels();

  // Converte a imagem para o tipo BoofCV
  img_gray = Boof.gray(img_alg_parte1,ImageDataType.U8);
  img_escala_cinza = img_gray.visualizeSign();
  
  // calcula limiar da imagem ( média da intensidade dos pixels )
  limiar = img_gray.mean();
  // faz-se a limiarização/binarização da imagem
  img_binaria = img_gray.threshold(limiar, true);
  limiarizacao = img_binaria.visualize();

  // remove ruido a partir da imagem obtida pela limiarização 
  img_sem_ruido = img_gray.threshold(limiar,true).removePointNoise().visualize();
  img_bin_ruidos = img_gray.threshold(limiar,true).removePointNoise();

  // aplica a operação OR entre as imagens limiarizada e sem ruidos
  img_or = img_gray.threshold(limiar,true).logicOr(img_bin_ruidos).visualize();


  // diminui a escala para visualização dos resultados
  scale(0.5);
  //  mostra as imagens
  image(img_original, 0, 0);
  image(img_alg_parte1, img_original.width, 0);
  image(img_escala_cinza, 2 * img_alg_parte1.width, 0);
  image(limiarizacao, 0, img_original.height);
  image(img_sem_ruido, limiarizacao.width, limiarizacao.height );
  image(img_or, 2* limiarizacao.width, limiarizacao.height );
  // caso queira salvar imagem
  if (( keyPressed == true ) && ( key == 's' || key == 'S')) save("imagem1.png");
}