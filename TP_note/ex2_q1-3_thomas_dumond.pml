// Author: Thomas DUMOND
// Le code passe le syntax check mais ne donne pas forcement le resultat attendu, il ne fonctionne pas avec toutes les seeds.
mtype={FARINE,SUCRE,OEUF,FIN_FARINE,FIN_SUCRE,FIN_OEUF};

chan INGREDIENT = [3] of {byte};
chan INFO = [3] of {byte};

proctype fournisseur () {
    bool fin_farine, fin_sucre, fin_oeuf;
    bool fin;

    // Ajoute les 3 ingrédients
    INGREDIENT!FARINE;
    INGREDIENT!OEUF;
    INGREDIENT!SUCRE;

    // Attends qu'au moins un patissier ait fini et rajoute les ingrédients manquants tant que les 3 patissiers n'ont pas fini
    do 
    :: fin -> break;
    :: else ->
        if
        :: INFO?FIN_FARINE -> 
            INGREDIENT!SUCRE;
            INGREDIENT!OEUF;
            fin_farine = true;
        :: INFO?FIN_SUCRE ->
            INGREDIENT!FARINE;
            INGREDIENT!OEUF;
            fin_sucre = true;
        :: INFO?FIN_OEUF ->
            INGREDIENT!FARINE;
            INGREDIENT!SUCRE;
            fin_oeuf = true;
        :: fin_farine && fin_oeuf && fin_sucre -> fin = true;
        :: else -> skip;
        fi;
    od;

}

proctype patissierFarine () {
    // Récupère le sucre et les oeufs
    INGREDIENT?SUCRE;
    INGREDIENT?OEUF;

    // Notifie le fournisseur qu'il a fini
    INFO!FIN_FARINE;
}

proctype patissierSucre () {
    // Récupère la farine et les oeufs
    INGREDIENT?FARINE;
    INGREDIENT?OEUF;

    // Notifie le fournisseur qu'il a fini
    INFO!FIN_SUCRE;
}

proctype patissierOeuf () {
    // Récupère la farine et le sucre
    INGREDIENT?FARINE;
    INGREDIENT?SUCRE;

    // Notifie le fournisseur qu'il a fini
    INFO!FIN_OEUF;
}

init {
    atomic {
        run fournisseur();
        run patissierOeuf();
        run patissierFarine();
        run patissierSucre();
    }
}

// Le code ici n'est pas bloquant.
// Il le serait dans le cas où le patissierFarine récupère la ressource sucre puis le patissierSucre récupère la ressource oeuf et le patissierOeuf récupère la ressource farine.
// C'est le cas ou les ingrédients ne sont pas récupérés dans l'ordre par les patissiers.  
// Pour corriger cela, il faut veiller a ce que les patissiers recupèrent les ingrédients dans l'ordre : farine, sucre, oeufs, ce qui est le cas dans le code ci-dessus mais cela ne suiifit pas.