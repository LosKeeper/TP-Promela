// QA
// mtype={chocolat,bonbon,euro1,cents50};

// chan argent_channel = [1] of {mtype};
// chan sucrerie_channel = [1] of {mtype};

// proctype distributeur() {
//     do
//     :: argent_channel!euro1 -> sucrerie_channel?bonbon;
//     :: argent_channel!cents50 -> sucrerie_channel?chocolat;
//     od
// }

// proctype client() {
//     do
//     :: argent_channel?euro1 -> sucrerie_channel!bonbon;
//     :: argent_channel?cents50 -> sucrerie_channel!chocolat;
//     od

// }

// init { atomic { run client(); run distributeur(); } }

// QB
mtype={chocolat,bonbon};
int budget_cents = 500;
int distributeur_cents = 0;
chan argent_channel = [1] of {int};
chan sucrerie_channel = [1] of {mtype};

proctype distributeur() {
    int chocolats=10;
    int bonbons=5;
    assert (budget_cents+distributeur_cents == 500);

end1:
    do
    :: ((chocolat > 0) && (argent_channel?[50])) ->
        argent_channel?50;
        distributeur_cents = distributeur_cents + 50;
        budget_cents = budget_cents - 50;
        sucrerie_channel!chocolat;
        chocolats = chocolats - 1;
        assert (budget_cents+distributeur_cents == 500);
    :: ((bonbons > 0) && (argent_channel?[100])) ->
        argent_channel?100;
        distributeur_cents = distributeur_cents + 100;
        budget_cents = budget_cents - 100;
        sucrerie_channel!bonbon;
        bonbons = bonbons - 1;
        assert (budget_cents+distributeur_cents == 500);  
    ::((bonbons==0) && (chocolats==0)) -> break   
    od
}

proctype client() {
end0:
    do
    :: budget_cents > 50 -> argent_channel!50 -> sucrerie_channel?chocolat;
    :: budget_cents > 100 -> argent_channel!100 -> sucrerie_channel?bonbon;
    :: budget_cents < 50 -> break;
    od
}

init { atomic { run client(); run distributeur(); } }
