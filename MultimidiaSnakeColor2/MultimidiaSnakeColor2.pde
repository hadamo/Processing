//Hádamo E.
PImage img;
PImage img2;
boolean start = false;
snake s; //cobra
PVector fruta; //vetor com coordenadas da fruta
int tam =15; //tamanho do lado dos quadrados
color c;
boolean figura = false;
int limite = 10; //tamanho para cada lvl
String imgname = "paisagem4.jpg";
void setup() {
  size(525, 525);
  PFont f = createFont("Arial", 30);
  textFont(f);
  img = loadImage(imgname);
  img2 = createImage(525, 525, RGB);
  img.resize(525, 525);
  img2 = img.get();
  s = new snake();
  s.atualizadir("l", "d", "d");
  frameRate(16);
  reposicionafruta();
}
void draw() {
  level();
  if (start) {
    s.perde();
    s.mover();
    s.redesenha();
    criafruta();
    if (s.comer(fruta)) {
      reposicionafruta();
      loadPixels();
      img.loadPixels();
      for (int i = 1; i < img.width; i++) {
        for (int j = 0; j < img.height; j++ ) {
          int loc = i+j*img.width;
          float r = red( img.pixels[loc]) ;
          float g = green(img.pixels[loc]); 
          float b = blue(img.pixels[loc]) ; 
          if (r>g && r>b) { 
            img.pixels[loc] = color(r*0.5, g*1.5, b*1.5);
          } 
          if (g>r && g>b) {
            img.pixels[loc] = color(r*1.5, g*0.5, b*1.5);
          }
          if (b>r && b>g) {
            img.pixels[loc] = color(r*1.5, g*1.5, b*0.5);
          }
          img.updatePixels();
        }
      }
    }
  } else {
    showmessage();
  }
}
void level() { // 
  if (floor(limite*0.1)%2==0) {
    tint(255, 100);
    padrao();
  } else {
    background(255);
    tint(255, 100);
    image(img, 0, 0);
  }
}

void padrao() {
  for (int i = 0; i<1000; i++) {
    float dots = map(s.x, 0, width, 5, 5*4);
    int x = int(random(width));
    int y = int(random(height));
    color a = img.get(int(x), int(y));
    fill(a, 120);
    noStroke();
    if (figura) {
      ellipse(x, y, dots, dots);
    } else {  
      rect(x, y, dots, dots);
    }
  }
}

void criafruta() {
  c = img2.get(int(fruta.x), int(fruta.y));
  fill(c);
  stroke(0);
  rect(fruta.x, fruta.y, tam, tam);
}

void reposicionafruta() {
  float col = floor(width/tam);
  float lin = floor(height/tam);
  fruta = new PVector(floor(random(col)), floor(random(lin)));
  fruta.mult(tam);
  figura = !figura;
}

void keyPressed() {

  if (key == CODED) {
    if (keyCode == UP ) {
      //s.dir(0, -1);
      s.dir("u");
    }
    if (keyCode == DOWN) {
      //s.dir(0, 1);
      s.dir("d");
    }
    if (keyCode == RIGHT) {
      //s.dir(1, 0);
      s.dir("r");
    }
    if (keyCode == LEFT) {
      //s.dir(-1, 0);
      s.dir("l");
    }
  } else {
    if (key == 's') {
      start= true;
    }
    if (key== 'p') {
      start=false;
    }
    if (key== 'c') {
      s.corpo++;
    }
    if (key== ' ') {
      s.reset();
      img = loadImage(imgname);
      img.resize(525, 525);
    }
  }
}

void showmessage() {
  fill(#2E2E2E);
  strokeWeight(30);
  text("CONTROLES:\n P = Pausa \n S = Start \n ESPAÇO = RESET \n Setas = Movimento\n Não bata na parede \n ou no próprio corpo", width/5, height / 4);
  strokeWeight(0);
}

class snake {
  float x;
  float y;
  float xvel=0;
  float yvel=0;
  int corpo =0;
  String[] direcao = new String[3];
  //arraylist de vetores com posiçoes dos blocos do corpo
  ArrayList<PVector> cauda = new ArrayList<PVector>();

  void dir(String d) {
    //void dir(float a, float b) {
    for (String c : direcao) {
      if (d==c) {
        sentido(d);
      }
    }
  }
  void sentido(String d) {
    if (d=="u") {
      xvel=0;
      yvel=-1;
      atualizadir("u", "l", "r");
    }    
    if (d=="d") {
      xvel=0;
      yvel=1;
      atualizadir("d", "l", "r");
    }    
    if (d=="r") {
      xvel=1;
      yvel=0;
      atualizadir("r", "u", "d");
    }    
    if (d=="l") {
      xvel=-1;
      yvel=0;
      atualizadir("l", "u", "d");
    }
  }
  void atualizadir(String a, String b, String c) {
    direcao[0]=a;
    direcao[1]=b;
    direcao[2]=c;
  }
  void mudafase() { //muda de fase cada vez que o tamanho aumenta 10 vezes
    if (corpo==limite) {
      limite+=10;
    }
  }

  boolean comer(PVector pos) {
    float d = dist(this.x, this.y, pos.x, pos.y);
    if (d<1) {
      this.corpo++;
      return true;
    } else {
      return false;
    }
  }

  void mover() {
    mudafase();
    //se já comeu fruta
    if (corpo>0) { 
      if (corpo == cauda.size() && !cauda.isEmpty()) {
        // cauda.set(i, cauda.get(i+1)); //faz o deslocamento do corpo da cobra
        cauda.remove(0); //remova o inicio da cauda
      }
      cauda.add(new PVector(this.x, this.y) ); //adiciona cauda
    }//adiciona novo bloco no corpo
    //desloca a cobra 
    x+=xvel*tam;
    y+=yvel*tam;
    //mantem coordenadas x e y dentro da janela
    this.x = constrain(x, 0, width-tam); 
    this.y = constrain(y, 0, height-tam);
  }

  void redesenha() {
    color c = img.get(int(this.x), int(this.y)); //pega cor da imagem na posiçao atual da cobra
    stroke(c);
    strokeWeight(2);
    fill(#02DE9A);
    for (PVector v : cauda) {
      rect(v.x, v.y, tam, tam); //desenha do corpo da cobra
    }
    rect(this.x, this.y, tam, tam); //desenha parte da frente
  }

  void perde() {
    for (int i = 0; i < cauda.size(); i++) {
      PVector pos = cauda.get(i);
      float d = dist(x, y, pos.x, pos.y); //se a distancia do corpo pra cabeça
      if (d < 1) {                     //for menor que 1
        reset();
      }
    }
  }
  void reset() {
    limite = 10;
    println("morreu "+"tamanho atingido = "+s.corpo); // ou bateu no proprio corpo ou passou
    corpo = 0;                      //da parede, entao recomeça.
    cauda.clear();
    start=false;
    saveFrame("resultado-######.jpg");
    println("imagem salva!");
  }
}