#define p 0 
#define v 1 
chan sema = [0] of {bit}; 

int cpt = 0;

proctype dijkstra() { 
    do 
    :: sema!p ->
        sema?v;
    od 
} 

proctype user() { 
    do 
    :: sema?p ->    
        skip; /* critical section */   
        cpt++;
        cpt--; 
        sema!v;    
        skip; /* non critical section */ 
        
    od 
} 

proctype assertion() 
{
    assert(cpt<=1)
}

init{ 
    atomic { 
        run dijkstra();               
        run user(); 
        run user(); 
        run user();
        run assertion()
    } 
}