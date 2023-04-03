byte a;
chan c1 = [0] of {byte};
int byteNb=5;

proctype alea(chan c){
	byte r;
	byte res=0;

	do 
		:: byteNb > 0 -> 
			if 
			:: r=0;
			:: r=1;
			fi
			res = res * 2 + r;
			byteNb=byteNb-1;

		:: else -> break;
	od

	c!res;
}


init{
	run alea(c1); 
	c1?a; 
	printf("Rand = %d\n",a);
}
