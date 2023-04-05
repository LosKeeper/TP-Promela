// Author: Thomas DUMOND
// Le code passe le syntax check et donne un résultat correct
#define N 4

typedef tabcan {
    chan to[N] = [1] of {short}
};

tabcan from[N];

proctype electeur (short numproc; chan em1, em2, em3 ,rec1,rec2,rec3){
    bool elu;
    short num1, num2, num3;

    // Envoi du numéro du processus
    em1!numproc;
    em2!numproc;
    em3!numproc;

    // Réception des numéros des processus
    rec1?num1;
    rec2?num2;
    rec3?num3;

    // Détermination du processus élu
    if :: (numproc<num1 && numproc<num2 && numproc<num3) -> 
        elu = true;
    :: else ->
        elu = false;
    fi;

    // Assertions de vérification de l'unicité de l'élu
    assert(num1!=num2 && num1!=num3 && num2!=num3);

    // Assertions de vérification de l'élu
    if :: elu -> 
        assert(numproc<num1 && numproc<num2 && numproc<num3);
    :: else -> skip;
    fi;
}

init {
    atomic {
        run electeur(1,from[0].to[1],from[0].to[2],from[0].to[3],from[1].to[0],from[2].to[0],from[3].to[0]);
        run electeur(2,from[1].to[0],from[1].to[2],from[1].to[3],from[0].to[1],from[2].to[1],from[3].to[1]);
        run electeur(3,from[2].to[0],from[2].to[1],from[2].to[3],from[0].to[2],from[1].to[2],from[3].to[2]);
        run electeur(4,from[3].to[0],from[3].to[1],from[3].to[2],from[0].to[3],from[1].to[3],from[2].to[3]);
    }
}