/**
 * Array 2D. 
 * 
 * Demonstrates the syntax for creating a two-dimensional (2D) array.
 * Values in a 2D array are accessed through two index values.  
 * 2D arrays are useful for storing images. In this example, each dot 
 * is colored in relation to its distance from the center of the image. 
 */
 
import java.util.Random;

Game game = new Game(30, 19, 5, 5);
PFont font;

public void settings() {
  fullScreen();
}

void setup()
{
  frameRate(10);
  font = createFont("Arial", 16, true);
  textFont(font, 16);
}

void keyReleased()
{
  game.onKeyReleased(key);
}

void keyPressed()
{
  game.onKeyPressed(key);
}

void draw()
{
  game.update();
  background(0); //Black
  // This embedded loop skips over values in the arrays based on
  // the spacer variable, so there are more values in the array
  // than are drawn here. Change the value of the spacer variable
  // to change the density of the points
  int[][] board = game.getBoard();
  for (int y = 0; y < game.getHeight(); y++)
  {
    for (int x = 0; x < game.getWidth(); x++)
    {
      if(board[x][y] == 0)
      {
        fill(0,0,0);
      }
      else if(board[x][y] == 1)
      {
        fill(255,255,255);
      }
      else if(board[x][y] == 2)
      {
        fill(255,40,255);
      }
      else if(board[x][y] == 3)
      {
        fill(4,255,255);
      }
      else if(board[x][y] == 4)
      {
        fill(130);
      }
      else if(board[x][y] == 5)
      {
        fill(0,255,255);
      }
      else if(board[x][y] == 6)
      {
        fill(255,40,255);
      }
      else if(board[x][y] == 7)
      {
        fill(255,40,255);
      }
      stroke(100,100,100);
      strokeWeight(2);
      rect(x*width/30, (height/21)+y*height/21, width/30, height/21);
    }
  }
  fill(255);
  textSize(30);
  text("Player 1 Lives: "+game.getPlayer1Life(), 25,25);
  text("Player 1 Points: "+game.getPlayer1Point(), 25,50);
  text("Player 2 Lives: "+game.getPlayer2Life(), width-275,25);
  text("Player 2 Points: "+game.getPlayer2Point(), width-275,50);
 
  if(game.getPlayer1Point() >= 30){
  fill(255);
  textSize(100);
  text("Player 1 Wins!", width/6,height/2);
  stop();
  }
  
  if(game.getPlayer2Point() >= 30){
  fill(130);
  textSize(100);
  text("Player 2 Wins!", width/2,height/2);
  stop();
  }
  
  if(game.getPlayer1Life() <= 0){
  fill(130);
  textSize(100);
  text("Player 2 Wins!", width/2,height/2);
  stop();
  }
  
  if(game.getPlayer2Life() <= 0){
  fill(255);
  textSize(100);
  text("Player 1 Wins!", width/6,height/2);
  stop();
  }
  
  //make collision detection for Draw() in order to generate text or graphics upon points gained / lives lost. 
  /*
   for(int i = 0; i < game.getEnemies().length; ++i)
    {
      if(enemies[i].getX() == player1.getX() && enemies[i].getY() == player1.getY())
      {
        //We have a collision
        --player1Life;
         
      }
      if(enemies[i].getX() == player2.getX() && enemies[i].getY() == player2.getY())
      {
        //We have a collision
        --player2Life;
        
      }
    }
    //Check victims collisions
    for(int i = 0; i < enemies.length; ++i)
    {
      if(victims[i].getX() == player1.getX() && victims[i].getY() == player1.getY())
      {
        //We have a collision
        ++player1Point;
        
      }
       if(victims[i].getX() == player2.getX() && victims[i].getY() == player2.getY())
      {
        //We have a collision
        ++player2Point;
      }
    }
    */
}
