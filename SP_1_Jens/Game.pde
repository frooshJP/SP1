import java.util.Random;

class Game
{
  private Random rnd;
  private final int width;
  private final int height;
  private int[][] board;
  private Keys keys;
  public int player1Life;
  public int player2Life;
  private Dot player1;
  private Dot player2;
  private Dot[] enemies;
  public int player1Point;
  public int player2Point;
  private Dot[] victims;
  private Dot bane1;
  private Dot bane2;


  Game(int width, int height, int numberOfEnemies, int numberOfVictims)
  {
    if (width < 10 || height < 10)
    {
      throw new IllegalArgumentException("Width and height must be at least 10");
    }
    if (numberOfEnemies < 0)
    {
      throw new IllegalArgumentException("Number of enemies must be positive");
    } 
    if (numberOfVictims < 0)
    {
      throw new IllegalArgumentException("Number of victims must be positive");
    }
    this.rnd = new Random();
    this.board = new int[width][height];
    this.width = width;
    this.height = height;
    keys = new Keys();
    player1 = new Dot(0, 0, width-1, height-1);
    player2 = new Dot(width-1, height-1, width-1, height-1);
    bane1 = new Dot(width/2, height/2, width-1, height-1);
    bane2 = new Dot(width/2, height/2, width-1, height-1);
    enemies = new Dot[numberOfEnemies];
    for (int i = 0; i < numberOfEnemies; ++i)
    {
      enemies[i] = new Dot((int)random(width), (int)random(height), width-1, height-1);
    }
    victims = new Dot[numberOfVictims];
    for (int i = 0; i < numberOfVictims; ++i)
    {
      victims[i] = new Dot(width/2, height/2, width-1, height-1);
    }


    this.player1Life = 100;
    this.player1Point = 0;
    this.player2Life = 100;
    this.player2Point = 0;
  }

  public int getWidth()
  {
    return width;
  }

  public int getHeight()
  {
    return height;
  }

  public int getPlayer1Life()
  {
    return player1Life;
  }

  public int getPlayer2Life()
  {
    return player2Life;
  }

  public int getPlayer1Point()
  {
    return player1Point;
  }

  public int getPlayer2Point()
  {
    return player2Point;
  }
  // make collision detection for Draw() in order to generate text or graphics upon points gained / lives lost. 
  /*
  public int[] getEnemiesXY(int x, int y)
   {  
   return enemies(x,y);
   }
   */

  public void onKeyPressed(char ch)
  {
    keys.onKeyPressed(ch);
  }

  public void onKeyReleased(char ch)
  {
    keys.onKeyReleased(ch);
  }

  public void update()
  {
    updatePlayer1();
    updatePlayer2();
    updateEnemies();
    updateVictims();
    updateBane1();
    updateBane2();
    checkForCollisions();
    clearBoard();
    populateBoard();
  }



  public int[][] getBoard()
  {
    //ToDo: Defensive copy?
    return board;
  }

  private void clearBoard()
  {
    for (int y = 0; y < height; ++y)
    {
      for (int x = 0; x < width; ++x)
      {
        board[x][y]=0;
      }
    }
  }

  private void updatePlayer1()
  {
    //Update player1
    if (keys.wDown() && !keys.sDown())
    {
      player1.moveUp();
    }
    if (keys.aDown() && !keys.dDown())
    {
      player1.moveLeft();
    }
    if (keys.sDown() && !keys.wDown())
    {
      player1.moveDown();
    }
    if (keys.dDown() && !keys.aDown())
    {
      player1.moveRight();
    }
  }

  private void updatePlayer2()
  {
    //Update player2
    if (keys.upDown() && !keys.downDown())
    {
      player2.moveUp();
    }
    if (keys.leftDown() && !keys.rightDown())
    {
      player2.moveLeft();
    }
    if (keys.downDown() && !keys.upDown())
    {
      player2.moveDown();
    }
    if (keys.rightDown() && !keys.leftDown())
    {
      player2.moveRight();
    }
  }

  private void updateBane1()
  {
    int bx = player1.getX() - bane1.getX();
    int by = player1.getY() - bane1.getY();
    if (rnd.nextInt(3) < 2)
    {
      if (abs(bx) > abs(by))
      {
        if (bx > 0)
        {
          //player is to the right
          bane1.moveRight();
        } else
        {
          //player is to the left
          bane1.moveLeft();
        }
      } else if (by > 0)
      {
        //player is down
        bane1.moveDown();
      } else
      {
        //player is up
        bane1.moveUp();
      }
    } else
    {
      //we move randomly
      int move = rnd.nextInt(4);
      if (move == 0)
      {
        //Move right
        bane1.moveRight();
      } else if (move == 1)
      {
        //Move left
        bane1.moveLeft();
      } else if (move == 2)
      {
        //Move up
        bane1.moveUp();
      } else if (move == 3)
      {
        //Move down
        bane1.moveDown();
      }
    }
  }

  private void updateBane2()
  {
    int bx = player2.getX() - bane2.getX();
    int by = player2.getY() - bane2.getY();
    if (rnd.nextInt(3) < 2)
    {
      if (abs(bx) > abs(by))
      {
        if (bx > 0)
        {
          //player is to the right
          bane2.moveRight();
        } else
        {
          //player is to the left
          bane2.moveLeft();
        }
      } else if (by > 0)
      {
        //player is down
        bane2.moveDown();
      } else
      {
        //player is up
        bane2.moveUp();
      }
    } else
    {
      //we move randomly
      int move = rnd.nextInt(4);
      if (move == 0)
      {
        //Move right
        bane2.moveRight();
      } else if (move == 1)
      {
        //Move left
        bane2.moveLeft();
      } else if (move == 2)
      {
        //Move up
        bane2.moveUp();
      } else if (move == 3)
      {
        //Move down
        bane2.moveDown();
      }
    }
  }

  private void updateVictims()
  {
    for (int i = 0; i < victims.length; ++i)
    {
      if (victims[i] == null)     
        continue;
      {
        int cx = 0;
        int cy = 0;
        //should we flee or move randomly?
        //2 out 3 we will flee..
        if (rnd.nextInt(3) < 2)
        {
          // we flee .. but
          // which player is closest?
          if (dist(player1.getX(), player1.getY(), victims[i].getX(), victims[i].getY()) < dist(player2.getX(), player2.getY(), victims[i].getX(), victims[i].getY()))
          {
            cx += player1.getX() - victims[i].getX();
            cy += player1.getY() - victims[i].getY();
          } else
          {
            cx += player2.getX() - victims[i].getX();
            cy += player2.getY() - victims[i].getY();
          }  
          if (abs(cx) > abs(cy))
          {
            if (cx > 0)
            {
              //player is to the right
              victims[i].moveLeft();
            } else
            {
              //player is to the left
              victims[i].moveRight();
            }
          } else if (cy > 0)
          {
            //player is down
            victims[i].moveUp();
          } else
          {
            //player is up
            victims[i].moveDown();
          }
        } else
        {
          //we move randomly
          int moveV = rnd.nextInt(4);
          if (moveV == 0)
          {
            //Move right
            victims[i].moveRight();
          } else if (moveV == 1)
          {
            //Move left
            victims[i].moveLeft();
          } else if (moveV == 2)
          {
            //Move up
            victims[i].moveUp();
          } else if (moveV == 3)
          {
            //Move down
            victims[i].moveDown();
          }
        }
        cx = 0;
        cy = 0;
      }
    }
  }

  private void updateEnemies()
  {
    for (int i = 0; i < enemies.length; ++i)
    {
      int dx = 0;
      int dy = 0;

      //Should we follow or move randomly?
      //2 out of 3 we will follow..
      if (rnd.nextInt(3) < 2)
      {
        // we follow .. but
        // which player is closest?
        if (dist(player1.getX(), player1.getY(), enemies[i].getX(), enemies[i].getY()) < dist(player2.getX(), player2.getY(), enemies[i].getX(), enemies[i].getY()))
        {
          dx += player1.getX() - enemies[i].getX();
          dy += player1.getY() - enemies[i].getY();
        } else
        {
          dx += player2.getX() - enemies[i].getX();
          dy += player2.getY() - enemies[i].getY();
        }  
        if (abs(dx) > abs(dy))
        {
          if (dx > 0)
          {
            //Player is to the right
            enemies[i].moveRight();
          } else
          {
            //Player is to the left
            enemies[i].moveLeft();
          }
        } else if (dy > 0)
        {
          //Player is down
          enemies[i].moveDown();
        } else
        {//Player is up;
          enemies[i].moveUp();
        }
      } else
      {
        //We move randomly
        int move = rnd.nextInt(4);
        if (move == 0)
        {
          //Move right
          enemies[i].moveRight();
        } else if (move == 1)
        {
          //Move left
          enemies[i].moveLeft();
        } else if (move == 2)
        {
          //Move up
          enemies[i].moveUp();
        } else if (move == 3)
        {
          //Move down
          enemies[i].moveDown();
        }
      }
      dx = 0;
      dy = 0;
    }
  }

  private void populateBoard()
  {
    //Insert player
    board[player1.getX()][player1.getY()] = 1;
    board[player2.getX()][player2.getY()] = 4;
     //Insert bane 1 & 2
    board[bane1.getX()][bane1.getY()] = 6;
    board[bane2.getX()][bane2.getY()] = 7;
    //Insert enemies
    for (int i = 0; i < enemies.length; ++i)
    {
      board[enemies[i].getX()][enemies[i].getY()] = 2;
    }
    //Insert victims
    for (int i = 0; i < victims.length; ++i) 
    {
    if(victims[i] == null)
    continue;
      board[victims[i].getX()][victims[i].getY()] = 3;
    }
}

private void checkForCollisions()
{
  //Check enemy collisions
  for (int i = 0; i < enemies.length; ++i)
  {
    if (enemies[i].getX() == player1.getX() && enemies[i].getY() == player1.getY())
    {
      //We have a collision
      --player1Life;
    }
    if (enemies[i].getX() == player2.getX() && enemies[i].getY() == player2.getY())
    {
      //We have a collision
      --player2Life;
    }
  }
  //Check bane1 collisions
    if (bane1.getX() == player1.getX() && bane1.getY() == player1.getY())
    {
      //We have a collision
      --player1Life;
    }
    if (bane1.getX() == player2.getX() && bane1.getY() == player2.getY())
    {
      //We have a collision
      --player2Life;
    }
    
      //Check bane2 collisions
    if (bane2.getX() == player1.getX() && bane2.getY() == player1.getY())
    {
      //We have a collision
      --player1Life;
    }
    if (bane2.getX() == player2.getX() && bane2.getY() == player2.getY())
    {
      //We have a collision
      --player2Life;
    }
  
  //Check victims collisions
  for (int i = 0; i < enemies.length; ++i)
  {
   if(victims[i] == null)
   continue;
    if (victims[i].getX() == player1.getX() && victims[i].getY() == player1.getY())
    {
      //We have a collision
      ++player1Point;
    }
    if (victims[i].getX() == player2.getX() && victims[i].getY() == player2.getY())
    {
      //We have a collision
      ++player2Point;
    }
  }
  
/* 
  //check for victim - enemy collisions - idea was to create a new enemy and remove a victim when the two collided. never got it to work.
  for (int i = 0; i<enemies.length; ++i) {
    for (int j = 0; j<victims.length; ++j) {
      if(victims[j] == null)
      continue;
      if (enemies[i].getX() == victims[j].getX() && enemies[i].getY() == victims[j].getY()) {
        //we have a collision
        Dot newEnemy = new Dot(victims[j].getX(), victims[j].getY(), width-1, height-1);
        expand(enemies,enemies.length+1);
        enemies[enemies.length + 1] = newEnemy;
        victims[j] = null;
      }
    }
  }
  */
}
}
