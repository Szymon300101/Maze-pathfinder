class Spot
{
  int x, y;
  float f, g, h;  //variables defining value of cell (sum, real dist. from start, straight line dist. to end)
  Spot parrent=null;
  ArrayList<Spot> nbrs = new ArrayList<Spot>();  //eighbors of cell
  boolean[] walls={true,true,true,true};
  boolean visited=false;
  
  Spot(int x,int y) //constructor
  {
    this.x=x;
    this.y=y;
    f=0;g=0;h=0;
  }
  
  void show(char mode) //drawing function
  {
    noStroke();
        //if(mode=='c')  
        //{
        //  fill(255,0,0);
        //  ellipse(this.x*gw+8,this.y*gh+8,8,8);
        //}
        //if(mode=='o')
        //{
        //  fill(0,255,0);
        //  ellipse(this.x*gw+8,this.y*gh+8,8,8);
        //}
        if(mode=='p') //showing cell as part of the path
        {
            fill(255);
            stroke(255);
            strokeWeight(5);
            if(parrent!=null)
            {
              if(parrent.x<x)
              {
                line(x*gw+(gw*0.5),y*gh+(gh*0.5),x*gw,y*gh+(gh*0.5));
                line(parrent.x*gw+(gw*0.5),parrent.y*gw+(gw*0.5),parrent.x*gw+gw,parrent.y*gh+(gh*0.5));
              }
              if(parrent.x>x)
              {
                line(x*gw+(gw*0.5),y*gh+(gh*0.5),x*gw+gw,y*gh+(gh*0.5));
                line(parrent.x*gw+(gw*0.5),parrent.y*gw+(gw*0.5),parrent.x*gw,parrent.y*gh+(gh*0.5));
              }
              if(parrent.y<y)
              {
                line(x*gw+(gw*0.5),y*gh+(gh*0.5),x*gw+(gw*0.5),y*gh);
                line(parrent.x*gw+(gw*0.5),parrent.y*gw+(gw*0.5),parrent.x*gw+(gw*0.5),parrent.y*gh+gh);
              }
              if(parrent.y>y)
              {
                line(x*gw+(gw*0.5),y*gh+(gh*0.5),x*gw+(gw*0.5),y*gh+gh);
                line(parrent.x*gw+(gw*0.5),parrent.y*gw+(gw*0.5),parrent.x*gw+(gw*0.5),parrent.y*gh);
              }
            }
            strokeWeight(1);
            
        }
        if(mode=='w') //showing cell as part of grid (walls)
        {
          stroke(255);
          if(walls[0])
            line(x*gw,y*gh,x*gw+gw,y*gh);
          if(walls[1])
            line(x*gw+gw,y*gh,x*gw+gw,y*gh+gh);
          //if(walls[2])
          //  line(x*gw,y*gh+gh,x*gw+gw,y*gh+gh);
          //if(walls[3])
          //  line(x*gw,y*gh+gh,x*gw,y*gh);
        }
  }
  
  //finding neighbors, witch aren't separated by wall (for pathfinding)
  void findN()
  {
    if(x>0)
    if(!walls[3] && !grid[x-1][y].walls[1])
      nbrs.add(grid[x-1][y]);
    if(x<gridX-1)
    if(!walls[1] && !grid[x+1][y].walls[3])
      nbrs.add(grid[x+1][y]);
    if(y>0)
    if(!walls[0] && !grid[x][y-1].walls[2])
      nbrs.add(grid[x][y-1]);
    if(y<gridY-1)
    if(!walls[2] && !grid[x][y+1].walls[0])
      nbrs.add(grid[x][y+1]);
  }
  
  //finding neigbors witch aren't visited yet (for generating maze)
  Spot neighbors()
   {
     ArrayList<Spot> N = new ArrayList<Spot>();
     
     if(y>0)
       if(!grid[x][y-1].visited)
         N.add(grid[x][y-1]);
     if(y<gridY-1)
       if(!grid[x][y+1].visited)
         N.add(grid[x][y+1]);
     if(x>0)
       if(!grid[x-1][y].visited)
         N.add(grid[x-1][y]);
     if(x<gridX-1)
       if(!grid[x+1][y].visited)
         N.add(grid[x+1][y]);
     if(N.size()>1)
       stack.add(this);
     if(N.size()>0)
       return N.get(floor(random(N.size())));
     else
       return null;
   }
}
