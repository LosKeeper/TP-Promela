#define true 1 
#define false 0 
#define Aturn false 
#define Bturn true 
bool x, y, t, sca, scb;

proctype A() {
	x = true; 
	t = Bturn; 
	(y == false || t == Aturn); 
	/* critical section */ 
	sca = true;
	x = false;
	sca = false; 
} 

proctype B() { 
	y = true; 
	t = Aturn; 
	(x == false || t == Bturn); 
	/* critical section */
	scb = true; 
	y = false;
	scb = false;
} 

proctype C() {
	assert(!(sca && scb));
}

init { 
	sca = false;
	scb = false;
    run A(); 
    run B();
    run C();
}
