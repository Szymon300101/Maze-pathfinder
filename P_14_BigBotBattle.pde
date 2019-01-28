int gw,gh;
int gridX=30;    //num. of cols
int gridY=20;    //num. of rows
Spot[][] grid = new Spot[gridX][gridY];  //defining array of grid-cells

Spot current;
//GENERATOR variables
ArrayList<Spot> stack= new ArrayList<Spot>(); //stack of generated cells (Spots)
boolean gen=false;  //true->maze is generated and ready

//DESTROYER variables
Spot start,end;  //start and end cells of the maze
ArrayList<Spot> openSet= new ArrayList<Spot>();
ArrayList<Spot> closedSet= new ArrayList<Spot>();
ArrayList<Spot> path= new ArrayList<Spot>();  //currently choosen path
boolean ready=false;  //true->program is done

void setup()
{
  size(901,601);  //numbers are one pix. bigger, so all borders are visible
  frameRate(120);
  gw=(width-1)/gridX;  //width of cell
  gh=(height-1)/gridY; //heigth of cell
  
  for(int i=0;i<gridX;i++)
    for(int z=0;z<gridY;z++)
      grid[i][z]=new Spot(i,z);  //creating new cells (Spots)
      
  //GENERATOR setup
  current = grid[0][0];  //begining in top right
  stack.add(grid[0][0]);
  background(0);
  for(int i=0;i<gridX;i++)
    for(int z=0;z<gridY;z++)
        grid[i][z].show('w');  //showing grid (walls)
  
}

void draw()
{
  if(!gen)  //if maze is not genereated yet
  {
  current.visited=true;  //mark cell as visited
  Spot next = current.neighbors();  //find next cell neighboring to current, witch isn't visited yet
  if(next!=null)  //if it exists
    {
      wallR(current,next);  //remove a wall between current and next
      current=next;  //go to next
    }else //if it dosn't exist we need to go back a bit
    {
      current=stack.get(stack.size()-1);  //go to prevous cell in the stack
      stack.remove(stack.size()-1);  //remove this cell from the stack (we are here, so no need to keep it in the stack)
    }
    //refreshing changed maze (we deleted a wall)
      fill(0);
      noStroke();
      ellipse(current.x*gw,current.y*gh,gw*8,gh*8);  //hiding all walls around current position
      for(int i=0;i<gridX;i++)
        for(int z=0;z<gridY;z++)
          if(d(current,grid[i][z])<10) //if this i,z id close to current pos.
            grid[i][z].show('w');      //show walls
    if(current==grid[0][0])  //if we are back in the start, we know that all cells have been visited
    {
      background(0);
  for(int i=0;i<gridX;i++)
    for(int z=0;z<gridY;z++)
        grid[i][z].show('w');  //refresh all cells to be sure there are no errors
          
      gen=true; //mark maze as generated
      
      //begining pathfinding algorithm
      for(int i=0;i<gridX;i++)
        for(int z=0;z<gridY;z++)
          grid[i][z].findN();  //telling each Spot where are its neighbors
      
      start=grid[0][0];
      end=grid[gridX-1][gridY-1];
      openSet.add(start);
      current=start;
      save("pic_unsolved.jpg");  //saving current state of maze to file
    }
  }else      //IF MAZE IS GENERATED, A* is running
  {
    if(openSet.size()==0 || current==end)   //if we are at the end or we haven't more ways to go, finish program
    {
      ready=true;
      return;
    }
    //finding most valuable way to go from current position
    int winner=0;
      for(int i=0;i<openSet.size();i++)
      {
        if(openSet.get(i).f<openSet.get(winner).f)
          winner=i;
      }
      current=openSet.get(winner); //going to that place,
      delete(current,openSet);  //and marking it as closed
    closedSet.add(current);
    
    //writing currently choosen path
    Spot temp=current;
    path.clear();
    path.add(temp);  //add current cell
    while(temp!=grid[0][0])  //goes back the path to the begining
    {
      path.add(temp);
      temp=temp.parrent;
    }
    
    //sets value (g) and parrent of neighbors
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
       
       //calculates real value of cell
       nbr.h=d(nbr,end);
       nbr.f=nbr.h*4+nbr.g;  //this '*4' is little cheat, so is prefering going to the end more
      
    }
    
    if(openSet.size()==0 || current==end) ready=true;  //checking second time if we aren't done
    background(0);
    
    //painting generated earlier path
    for(int i=0;i<path.size();i++)
        path.get(i).show('p');
    start.show('p');
    if(ready) end.show('p');
        
    //painting grid again
    for(int i=0;i<gridX;i++)
      for(int z=0;z<gridY;z++)
        grid[i][z].show('w');
    if(ready) save("pic_solved.jpg");
  }
}

//function removing walls between given cells
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

//distance between cells
float d(Spot a,Spot b)
{
  return dist(a.x,a.y,b.x,b.y);
  //return abs(a.x-b.x)+abs(a.y-b.y);
}

//function deleting given object from the array
void delete(Spot spot, ArrayList<Spot> list)
{
  for(int i=0;i<list.size();i++)
  if(list.get(i)==spot)
  {
    list.remove(i);
    return;
  }
}
