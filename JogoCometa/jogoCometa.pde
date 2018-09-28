///////////////////////////////////////////////////////////////////////////////////
/*  Avaliação da disciplina de Sistemas Multimídia.
    Professor: LEANDRO LESQUEVES COSTALONGA
    Aluno: Hadamo Egito.
    Ciência da Computação - UFES
*/
///////////////////////////////////////////////////////////////////////////////////
import processing.sound.*;
SoundFile laser, expl1, expl2, gmo, air, move, bgsound,bgsound2, spark;
ArrayList com;
PImage bg;
PImage nave;
player p;
laser l;
int recorde =0,pausa =2, fase, randomexp, velomaxcmt =5,maxcmt, oldmaxcmt;
boolean sobe, desce, avanca, recua, game = false, restartsomgmover = false;
///////////////////////////////////////////////////////////////////////////////////

void setup() {
  size(800, 400);
  nave = loadImage("nave.png");
  bg = loadImage("bg.png");
  bg.resize(800, 200);
  nave.resize(90, 40);
  laser = new SoundFile(this, "laser.mp3");
  expl1 = new SoundFile(this, "explosion1.mp3");
  expl2 = new SoundFile(this, "explosion2.mp3");
  air =  new SoundFile(this, "airlock.mp3");
  gmo = new SoundFile(this, "explosion3.mp3");
  spark = new SoundFile(this, "spark.mp3");
  bgsound =  new SoundFile(this, "bgsound.mp3");
  bgsound2 =  new SoundFile(this, "bgsound2.mp3");
  bgsound.loop();
  bgsound.amp(0.2);
  setupgame();
}
///////////////////////////////////////////////////////////////////////////////////
void setupgame() {
  p = new player();
  p.desenhaNave();
  com = new ArrayList();
  com.add(new cometa());
  l = new laser();
  maxcmt = 13;
  oldmaxcmt = maxcmt;
  velomaxcmt = 5;
  fase = 1;
}
///////////////////////////////////////////////////////////////////////////////////
void draw() {
  if (game==true) {
    gameon();
  } else {
    menu();
  }
}
///////////////////////////////////////////////////////////////////////////////////
void gameon() {
  background(#082F58);
  sky();
  if (pausa%2==0) {
    if (com.size()<maxcmt) { // impede que gere muito cometa
      com.add(new cometa());
    }
    for (int i = com.size() -1; i>=0; i--) {
      cometa c = (cometa) com.get(i);
      c.movecom();
      if (c.colisao()==1) {
        p.levardano();
        com.remove(i);
        maxcmt--;
        c.velo++;
      }
      if (c.colisao()==2) {
       // l = new laser();
        com.remove(i);
        p.setrecord();
        p.pontos+=c.lim/5;
        maxcmt--;
        c.curaplayer(p);
        if (c.lim >= 30) {
          expl1.play();
          expl1.amp(0.2);
        }
        if (c.lim < 30) {
          expl2.play();
          expl2.amp(0.2);
        }
      } 
      p.gameover();
    }
    l.move();
    p.move();
    placar();
    if (maxcmt ==0) {
      maxcmt = oldmaxcmt + 10;
      oldmaxcmt = maxcmt;
      velomaxcmt += oldmaxcmt/10 ;
      fase++;
    }
  } else {
    menupausa();
  }
}
///////////////////////////////////////////////////////////////////////////////////
void menu() {
  if (restartsomgmover) {
    bgsound2.stop();
    bgsound.loop();
    restartsomgmover = false;
  }
  background(#000000);
  sky();
  textSize(30);
  imageMode(CENTER);
  image(bg, width/2, height/2);
  fill(#FFFFFF);
  text("! APERTE S PARA COMEÇAR !  ", width/4, height/2);
  text("Recorde: "+recorde, width/2 - 82, height/2 + 60);
  textSize(10);
  text("ENTER para RESTART", width-470, height/2 + 80);
  text("MOVER = SETAS, V = ESCUDO, ESPAÇO = ATIRAR, P = PAUSE\n DICA: COMETAS COM AURA VERMELHA DÃO VIDA ", width-550, height/2 + 120);
}
///////////////////////////////////////////////////////////////////////////////////
void menupausa() {
  textSize(30);
  fill(#FFFFFF);
  text("! PAUSADO !  ", width/4, height/2);
  text("Aperte P para Voltar", width/2 -100, height/2 + 80);
}
///////////////////////////////////////////////////////////////////////////////////
void placar() {
  //p.barrahp();
  textSize(15);
  fill(#FFFFFF);
  text(" PONTOS: "+p.pontos, 5, 23);
  text(" HP "+p.life, 200, 23);
  text(" Fase " + fase, 550, 23);
  String shield;
  if (p.shield) {
    shield = " ON ";
  } else {
    shield = " OFF ";
  }
  text(" SHIELD "+shield, 300, 23);
  text(" Cometas: "+com.size(), 400, 23);
}
///////////////////////////////////////////////////////////////////////////////////
class player {
  PVector pos = new PVector(100, height/2);
  int life=15;
  boolean shield = false;
  int pontos =0;
  float velo = 8;
  void desenhaNave() {
    if (shield) {
      stroke(random(255), random(255), random(255));
      noFill();
      ellipse(pos.x, pos.y, nave.width+8, nave.height+8);
    } 
    image(nave, pos.x, pos.y); //tamanho da nave é 90x40
  }
  void atira() {
    if (shield == false) {
      l.salvapos(p.pos.x+60, p.pos.y+8);
    }
  }
  void escudo(boolean segura) {
    shield = segura;
  }
  void move() {
    if (sobe) {
      pos.y -= velo;
    }
    if (desce) {
      pos.y += velo;
    }
    if (avanca) {
      pos.x += velo;
    }
    if (recua) {
      pos.x -= velo;
    }
    pos.x = constrain(pos.x, 40, width -40 ); 
    pos.y = constrain(pos.y, 40, height - 10);
    desenhaNave();
  }
  void levardano() {
    if (shield == false) {
      life--;
    }
  }
  void setrecord() {
    recorde = pontos;
  }
  void gameover() {
    if (life<1) {
      setrecord();
      fase=0;
      pontos = 0;
      restartsomgmover = true;
      game = false;
    }
  }
}
///////////////////////////////////////////////////////////////////////////////////
class laser {
  PImage img;
  PVector pos; 
  float velo = 30;
  laser() {
    pos = new PVector(p.pos.x+60, p.pos.y+8);
    img = loadImage("laser.png");
  }
  void salvapos(float x, float y) {
    pos.x = x; 
    pos.y = y;
  }
  void move() {
    pos.x += velo;    
    image(img, pos.x, pos.y);
  }
}
///////////////////////////////////////////////////////////////////////////////////
class cometa {
  PImage img;
  PVector pos;
  float velo;
  boolean passou = false;
  int lim, curar, valorcura;
  cometa() {
    valorcura=0;
    curar = int(random(50));
    int i = floor(random(30));
    if (i>20) {
      img = loadImage("cometa.png");
      lim = 30;
    } else {
      img = loadImage("meteoro.png");
      lim=15;
    }
    pos = new PVector(random(800, 900), random(25, height));
    velo = random(1, velomaxcmt);
  }
  void curaplayer(player p) {
    p.life+= this.valorcura;
  }
  void movecom() {

    pos.x -= velo;
    if (pos.x < 0) {
      pos.x = random(800, 900);
      pos.y = random(25, height);
      curar=0;
    }
    image(img, pos.x, pos.y);
    if (curar>48) { //se curar for 25 vai vir um cometa com cura
      noFill();
      stroke(#FC0000);
      ellipse(pos.x, pos.y, img.width+8, img.height+8);
      this.valorcura = lim/15;
    }
  }
  int colisao() {
    // 1 = colisão nave com meteoro
    // 2 = colisão laser com meteoro
    float dfrentenave =dist(p.pos.x+80, p.pos.y+22, pos.x, pos.y);
    float dcimanave =dist(p.pos.x+60, p.pos.y, pos.x, pos.y);
    float dbaixonave =dist(p.pos.x+60, p.pos.y+34, pos.x, pos.y);
    float dtrasnave =dist(p.pos.x, p.pos.y+34, pos.x, pos.y);
    float dlaser = dist(l.pos.x+30, l.pos.y, pos.x, pos.y);
    if (dfrentenave<lim || dcimanave<lim||dbaixonave <lim ||dtrasnave <lim) {
      if (p.shield) {
        System.out.println("escudo on");
        spark.play();
        spark.amp(0.001);
        pos.y+= random(-1, 1);
        return 0;
      } else {
        System.out.println("bateu");
        gmo.play();
        gmo.amp(0.1);
        // explode();
        return 1;
      }
    }
    if (dlaser<lim) {
      System.out.println("acertou");
      //explode();
      return 2;
    }
    return 0;
  }
}
///////////////////////////////////////////////////////////////////////////////////
void sky() { // gera estrelas aleatórias dando a sensação de movimento
  fill(255, 255, 255);
  noStroke();
  ellipse(random(width), random(height), 2, 2);
  ellipse(random(width), random(height), 2, 2);
  ellipse(random(width), random(height), 2, 2);
}
///////////////////////////////////////////////////////////////////////////////////
//como keycode nao pode pegar dois valores ao mesmo tempo
//utilizei keyreleased junto com ele, e salvei como boolean as ações de movimento
//que serão verdadeiras enquanto a tecla estiver pressionada, assim podendo
//guardar mais de dois valores pro movimento das teclas
///////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////
void keyPressed () {
  if (key == CODED) {
    if (keyCode == UP ) {
      sobe = true;
    }
    if (keyCode == DOWN) {
      desce = true;
    }
    if (keyCode == RIGHT) {
      avanca = true;
    }
    if (keyCode == LEFT) {
      recua = true;
    }
  } else {
    if (key == 's' && !game) { //apertar S começa o jogo
      System.out.println("TESTE");
      air.play();
      air.amp(0.2);
      game = true;
      bgsound.stop();
      bgsound2.loop();
      bgsound2.amp(0.2);
      setupgame();
      delay(4000);
    }
    if (key == '\n' && game) { //apertar enter  reseta o jogo
      game = false;
      bgsound2.stop();
      bgsound.loop();
      bgsound.amp(0.2);
      pausa=2;
    }
    if (key == ' '  && game) { //apertar espaço  atira
      laser.play();
      laser.amp(0.2);
      p.atira();
    }
    if (key == 'p' && game) { //só pausa se jogo nao for resetado e apertar p
      pausa++;
    }
    if (key == 'v') { //apertar v ativa escudo
      p.escudo(true);
    }
    if (key == 67) { //apertar c cria cometas
      com.add(new cometa());
    }
  }
}
///////////////////////////////////////////////////////////////////////////////////
void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP ) {
      sobe = false;
    }
    if (keyCode == DOWN) {
      desce = false;
    }
    if (keyCode == RIGHT) {
      avanca = false;
    }
    if (keyCode == LEFT) {
      recua = false;
    }
  } else {
    if (key == 'v') { //apertar v desativa escudo
      p.escudo(false);
    }
  }
}
