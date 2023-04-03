int a;

proctype alea(){
	// retrun a random number between 0 and 1
	if ::true -> a = 0;
	::true -> a = 1;
	fi;
}


init{
	run alea();
}
