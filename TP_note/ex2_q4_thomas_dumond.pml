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
    bool sucre, oeuf;

    // Récupère le sucre et les oeufs sans ordre
    if 
    :: INGREDIENT?SUCRE -> sucre = true;
    :: INGREDIENT?OEUF -> oeuf = true;
    fi;

    if
    :: sucre && oeuf -> skip;
    :: else ->
        if
        :: INGREDIENT?SUCRE;
        :: INGREDIENT?OEUF;
        fi;
    fi;

    // Notifie le fournisseur qu'il a fini
    INFO!FIN_FARINE;
}

proctype patissierSucre () {
    bool farine, oeuf;

    // Récupère la farine et les oeufs sans ordre
    if
    :: INGREDIENT?FARINE-> farine = true;
    :: INGREDIENT?OEUF -> oeuf = true;
    fi;
    
    if
    :: farine && oeuf -> skip;
    :: else ->
        if
        :: INGREDIENT?FARINE;
        :: INGREDIENT?OEUF;
        fi;
    fi;

    // Notifie le fournisseur qu'il a fini
    INFO!FIN_SUCRE;
}

proctype patissierOeuf () {
    bool farine, sucre;

    // Récupère la farine et le sucre sans ordre
    if
    :: INGREDIENT?FARINE-> farine = true;
    :: INGREDIENT?SUCRE -> sucre = true; 
    fi;

    if
    :: farine && sucre -> skip;
    :: else ->
        if
        :: INGREDIENT?FARINE;
        :: INGREDIENT?SUCRE;
        fi;
    fi;

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

// Ici, le code est bloquant (avec la seed 1230) : 
// Le patissierSucre a fini son gateau
// Le patissierFarine a récupéré le sucre mais les oeufs
// Le patissierOeuf a récupéré la farine mais le sucre
// Chacun est donc bloqué car il lui manque une ressource et toutes les ressources nécessaires sont prises