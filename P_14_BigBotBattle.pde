int gw,gh;
int gridX=60;
int gridY=40;
Spot[][] grid = new Spot[gridX][gridY];

Spot current;
//GENERATOR
ArrayList<Spot> stack= new ArrayList<Spot>();
boolean gen=false;

//DESTROYER
Spot start,end;
ArrayList<Spot> openSet= new ArrayList<Spot>();
ArrayList<Spot> closedSet= new ArrayList<Spot>();
ArrayList<Spot> path= new ArrayList<Spot>();
boolean ready=false;

void setup()
{
  size(901,601);
  frameRate(120);
  gw=(width-1)/gridX;
  gh=(height-1)/gridY;
  
  for(int i=0;i<gridX;i++)
    for(int z=0;z<gridY;z++)
      grid[i][z]=new Spot(i,z);
      
  //GENERATOR
  current = grid[0][0];
  stack.add(grid[0][0]);
  background(0);
  for(int i=0;i<gridX;i++)
    for(int z=0;z<gridY;z++)
        grid[i][z].show('w');
  
}

void draw()
{
  if(!gen)
  {
  //background(0);
  current.visited=true;
  //current.show('r');
  Spot next = current.neighbors();
  if(next!=null)
    {
      wallR(current,next);
      current=next;
    }else
    {
      current=stack.get(stack.size()-1);
      stack.remove(stack.size()-1);
    }
      fill(0);
      noStroke();
      ellipse(current.x*gw,current.y*gh,gw*8,gh*8);
      for(int i=0;i<gridX;i++)
        for(int z=0;z<gridY;z++)
          if(d(current,grid[i][z])<10)
            grid[i][z].show('w');
    if(current==grid[0][0]) 
    {
      background(0);
  for(int i=0;i<gridX;i++)
    for(int z=0;z<gridY;z++)
        grid[i][z].show('w');
          
      gen=true;
      
      for(int i=0;i<gridX;i++)
        for(int z=0;z<gridY;z++)
          grid[i][z].findN();
      
      start=grid[0][0];
      end=grid[gridX-1][gridY-1];
      openSet.add(start);
      current=start;
      save("pic_unsolved.jpg");
    }
  }else//=================================================================================================//
  {
    if(openSet.size()==0 || current==end) 
    {
      ready=true;
      return;
    }
    int winner=0;
      for(int i=0;i<openSet.size();i++)
      {
        if(openSet.get(i).f<openSet.get(winner).f)
          winner=i;
      }
      current=openSet.get(winner);
      delete(current,openSet);
    closedSet.add(current);
    
    Spot temp=current;
    path.clear();
    path.add(temp);
    while(temp!=grid[0][0])
    {
      path.add(temp);
      temp=temp.parrent;
    }
    
    
    for(int i=0;i<current.nbrs.size();i++)
    {
      Spot nbr=current.nbrs.get(i);
      float tempG;
      if(!(closedSet.indexOf(nbr)>=0))
      {
        tempG=current.g+1;
        if(openSet.indexOf(nbr)>=0)
        {
            if(tempG<nbr.g)
            {
              nbr.parrent=current;
              nbr.g=tempG;
            }
        }else
        {
            openSet.add(nbr);
            nbr.g=tempG;
            nbr.parrent=current;
        }
      }
      
     nbr.h=d(nbr,end);
      nbr.f=nbr.h*4+nbr.g;
      
    }
    
    if(openSet.size()==0 || current==end) ready=true;
    
    if(frameCount%1==0 || ready)
    {
    background(0);
    //for(int i=0;i<closedSet.size();i++)
    //  closedSet.get(i).show('c');
        
    //for(int i=0;i<openSet.size();i++)
    //  openSet.get(i).show('o');
    
    for(int i=0;i<path.size();i++)
        path.get(i).show('p');
    start.show('p');
    if(ready) end.show('p');
        
    for(int i=0;i<gridX;i++)
      for(int z=0;z<gridY;z++)
        grid[i][z].show('w');
    if(ready) save("pic_solved.jpg");
    }
  }
}


void wallR(Spot current, Spot next)
{
 if(next.x<current.x)
  {
    next.walls[1]=false;
    current.walls[3]=false;
  }
  else if(next.x>current.x)
  {
    next.walls[3]=false;
    current.walls[1]=false;
  }
  else if(next.y<current.y)
  {
    next.walls[2]=false;
    current.walls[0]=false;
  }
  else if(next.y>current.y)
  {
    next.walls[0]=false;
    current.walls[2]=false;
  } 
}

float d(Spot a,Spot b)
{
  return dist(a.x,a.y,b.x,b.y);
  //return abs(a.x-b.x)+abs(a.y-b.y);
}

void delete(Spot spot, ArrayList<Spot> list)
{
  for(int i=0;i<list.size();i++)
  if(list.get(i)==spot)
  {
    list.remove(i);
    return;
  }
}
