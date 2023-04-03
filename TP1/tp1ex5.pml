int N=25;
mtype= {play,stop};

proctype player(chan c){
    int n;
    do
        :: c?play,n 
            ->      int i=0;
                    if 
                    :: n==2 -> 
                        if 
                        :: i=1;
                        :: i=2;
                        fi;
                    :: n>=3 ->
                        if 
                        :: i=1;
                        :: i=2;
                        :: i=3;
                        fi;
                    :: n==1 -> 
                        i=1;
                    :: else -> 
                        skip;
                    fi;
                    n=n-i;
                    if :: n<=0 -> c!stop,n; break;
                    :: else -> c!play,n;
                    fi;
        :: c?stop,n -> break;
    od;


}


init {

    chan c = [0] of {byte,int};

    run player(c);
    run player(c);
    
    c!play,N;

}