#define PRIMAIRE 1
#define SECONDAIRE 2
#define CLIENT 3
int sum_role;

proctype affecte_role(chan in1, out1, in2, out2) {
    byte role,r1,r2,r3,fin;
    do
    :: if 
        :: r1=PRIMAIRE;
        :: r1=SECONDAIRE;
        :: r1=CLIENT;
        fi;
        out1!r1; out2!r1; in1?r2; in2?r3;
        if
        :: ((r1!=r2)&&(r1!=r3)&&(r2!=r3)) -> role=r1;
            sum_role = sum_role + role; out1!fin; out2!fin; break;
        :: else -> skip;
        fi;
    od;
    printf("Processus %d, role %d, sum_role %d\n",_pid,role,sum_role);
    ((in1?[fin])&&(in2?[fin])) -> assert (sum_role==6);
}


init {
    chan AtoB = [1] of {byte} ; 
    chan AtoC = [1] of {byte} ;
    chan BtoA = [1] of {byte} ; 
    chan BtoC = [1] of {byte} ;
    chan CtoA = [1] of {byte} ;
    chan CtoB = [1] of {byte} ;
    
 
    atomic {  
        run affecte_role(AtoB,BtoA,AtoC,CtoA);
        run affecte_role(BtoA,AtoB,BtoC,CtoB);
        run affecte_role(CtoA,AtoC,CtoB,BtoC);
}}