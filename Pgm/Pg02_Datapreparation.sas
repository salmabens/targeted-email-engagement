/*********************************************************/

/* Étape : Vérifier le tableau */

proc contents data=donnees.reponses_quest_1; run;

/*********************************************************/

/* Étape : Utiliser la colonne "top_incomplet" pour vérifier les lignes incomplètes */

/* Étape 1 : Ajouter une colonne "top_incomplet" pour identifier si chaque ligne (ID) est complète */
data results.results_with_top_incomplet;
    set donnees.reponses_quest_1; /* Charger les données d'origine */

    /* Initialiser la variable "top_incomplet" à 0 (supposant que la ligne est complète) */
    top_incomplet = 0; /* 0 signifie qu'aucune valeur manquante n'a été trouvée */

    /* Initialiser la colonne "missing_columns" */
    length missing_columns $200; /* Longueur maximale de la liste des colonnes manquantes */
    missing_columns = ""; /* Commencer par une chaîne vide */

    /* Vérifier chaque colonne de Q1 à Q21 individuellement */
    if missing(Q1) or Q1 = "." or Q1 = " " then do;
        top_incomplet = 1;
        missing_columns = catx(", ", missing_columns, "Q1");
    end;
    if missing(Q2) or Q2 = "." or Q2 = " " then do;
        top_incomplet = 1;
        missing_columns = catx(", ", missing_columns, "Q2");
    end;
    if missing(Q3) or Q3 = "." or Q3 = " " then do;
        top_incomplet = 1;
        missing_columns = catx(", ", missing_columns, "Q3");
    end;
    if missing(Q4) or Q4 = "." or Q4 = " " then do;
        top_incomplet = 1;
        missing_columns = catx(", ", missing_columns, "Q4");
    end;
    if missing(Q5) or Q5 = "." or Q5 = " " then do;
        top_incomplet = 1;
        missing_columns = catx(", ", missing_columns, "Q5");
    end;
    if missing(Q6) or Q6 = "." or Q6 = " " then do;
        top_incomplet = 1;
        missing_columns = catx(", ", missing_columns, "Q6");
    end;
    if missing(Q7) or Q7 = "." or Q7 = " " then do;
        top_incomplet = 1;
        missing_columns = catx(", ", missing_columns, "Q7");
    end;
    if missing(Q8) or Q8 = "." or Q8 = " " then do;
        top_incomplet = 1;
        missing_columns = catx(", ", missing_columns, "Q8");
    end;
    if missing(Q9) or Q9 = "." or Q9 = " " then do;
        top_incomplet = 1;
        missing_columns = catx(", ", missing_columns, "Q9");
    end;
    if missing(Q10) or Q10 = "." or Q10 = " " then do;
        top_incomplet = 1;
        missing_columns = catx(", ", missing_columns, "Q10");
    end;
    if missing(Q11) or Q11 = "." or Q11 = " " then do;
        top_incomplet = 1;
        missing_columns = catx(", ", missing_columns, "Q11");
    end;
    if missing(Q12) or Q12 = "." or Q12 = " " then do;
        top_incomplet = 1;
        missing_columns = catx(", ", missing_columns, "Q12");
    end;
    if missing(Q13) or Q13 = "." or Q13 = " " then do;
        top_incomplet = 1;
        missing_columns = catx(", ", missing_columns, "Q13");
    end;
    if missing(Q14) or Q14 = "." or Q14 = " " then do;
        top_incomplet = 1;
        missing_columns = catx(", ", missing_columns, "Q14");
    end;
    if missing(Q15) or Q15 = "." or Q15 = " " then do;
        top_incomplet = 1;
        missing_columns = catx(", ", missing_columns, "Q15");
    end;
    if missing(Q16) or Q16 = "." or Q16 = " " then do;
        top_incomplet = 1;
        missing_columns = catx(", ", missing_columns, "Q16");
    end;
    if missing(Q17) or Q17 = "." or Q17 = " " then do;
        top_incomplet = 1;
        missing_columns = catx(", ", missing_columns, "Q17");
    end;
    if missing(Q18) or Q18 = "." or Q18 = " " then do;
        top_incomplet = 1;
        missing_columns = catx(", ", missing_columns, "Q18");
    end;
    if missing(Q19) or Q19 = "." or Q19 = " " then do;
        top_incomplet = 1;
        missing_columns = catx(", ", missing_columns, "Q19");
    end;
    if missing(Q20) or Q20 = "." or Q20 = " " then do;
        top_incomplet = 1;
        missing_columns = catx(", ", missing_columns, "Q20");
    end;
    if missing(Q21) or Q21 = "." or Q21 = " " then do;
        top_incomplet = 1;
        missing_columns = catx(", ", missing_columns, "Q21");
    end;

    /* Garder toutes les colonnes d'origine et ajouter "top_incomplet" et "missing_columns" */
run;

/* Étape 2 : Afficher les résultats avec la colonne "top_incomplet" */
proc print data=results.results_with_top_incomplet;
    title "Tableau avec la colonne 'top_incomplet' (1 si incomplet, 0 sinon)";
run;

/* Étape 3 : Séparer les observations où top_incomplet = 0 */
data results.quest_complets; /* Table pour les lignes complètes */
    set results.results_with_top_incomplet;
    if top_incomplet = 0; 
run;

/* Étape 4 : Séparer les observations où top_incomplet = 1 */
data results.quest_incomplets; /* Table pour les lignes incomplètes */
    set results.results_with_top_incomplet;
    if top_incomplet = 1; 

/* Étape 5 : Afficher les résultats pour vérification */
/* Afficher la table top_incomplet = 0 */
proc print data=results.quest_complets;
    title "Tableau des lignes complètes (top_incomplet = 0)";
run;

/* Afficher la table top_incomplet = 1 */
proc print data=results.quest_incomplets;
    title "Tableau des lignes incomplètes (top_incomplet = 1)";
run;

/*********************************************************/

/* Étape : Compter le nombre de lignes pour chaque table */

/* Compter les lignes de la table results.quest_complets */
proc sql;
    select count(*) as nb_lignes
    from results.quest_complets;
    title "Nombre de lignes dans la table 'results.quest_complets'";
quit;

/* Compter les lignes de la table results.quest_incomplets */
proc sql;
    select count(*) as nb_lignes
    from results.quest_incomplets;
    title "Nombre de lignes dans la table 'results.quest_incomplets'";
quit;

/*********************************************************/

/* Questions déjà labellisées, labels ajoutés au cas où dans une autre table reservée*/

/* Ajout des labels aux questions*/
data results.quest_label;
set results.quest_complets;
label
q1="1- En matière d'Internet, vous vous considérez comme un utilisateur…?"
q2="2- Quel(s) type(s) de sites visitez-vous couramment ? ?"
q3="3- Considérez-vous que cette adresse soit votre adresse email principale ?"
q4="4- A quelle fréquence consultez-vous votre boîte email ?"
q5="5- D’une manière générale, combien d’emails publicitaires, newsletters, alerting, ou autres, recevez-vous ?"
q6="6- Quelle image avez-vous de Projet-one ?"
q7="7- A quelle fréquence profitez-vous des offres via le site Projet-one ?"
q8="8- Vous diriez que vous ouvrez les communications email de Projet-one :"
q9="9- Comment jugez-vous l’impact des communications email sur l’image que vous avez de Projet-one ?"
q10="10- Les communications email de Projet-one vous incitent-elles à aller sur le site :"
q11="11- Quelles sont les raisons principales qui vous ont incité à recevoir les communications email de Projet-one
?"
q12="12- De manière générale, quel est votre niveau de satisfaction concernant les communications email de
Projet-one ?"
q13="13- Que pensez-vous de la longueur des communications email de Projet-one ?"
q14="14- Par rapport à aujourd’hui, vous souhaiteriez recevoir des communications email de Projet-one…"
q15="15- Avez-vous rencontré récemment un ou plusieurs des obstacles suivants vis-à-vis des communications
email de Projet-one ?"
q16="16- Pensez-vous continuer à consulter les communications email de Projet-one à l’avenir ?"
q17="17- Vous êtes ?"
q18="18- Vous vivez..."
q19="19- Vous habitez..."
q20="20- Quel âge avez-vous ?"
q21="21- Quelle est votre profession ?";
run;

/*********************************************************/

/*Proc format pour afficher les valeurs correspondantes */

proc format library=donnees;
  value $Q1_f
    '1'="Débutant(e)"
    '2'="Initié(e)"
    '3'="Confirmé(e)"
    '4'="Expert(e)";
  value $Q3_f
    '1'="Oui, c’est ma seule adresse email"
    '2'="Oui, mais j’ai d’autres adresses email"
    '3'="Non, c’est une adresse secondaire";
  value $Q4_f
    '1'="Plusieurs fois par jour"
    '2'="Une fois par jour"
    '3'="Plusieurs fois par semaine"
	'4'="Une fois par semaine"
	'5'="Moins souvent";
  value $Q5_f
    '1'="Plusieurs par jour"
    '2'="Environ 1 par jour"
    '3'="Plusieurs par semaine mais moins de 1 par jours"
	'4'="Environ 1 par semaine"
	'5'="Moins de 1 par semaine";
  value $Q6_f
    '1'="Très bonne"
    '2'="Assez bonne"
    '3'="Assez mauvaise"
	'4'="Très mauvaise"
	'5'="Je ne connais pas";
  value $Q7_f
    '1'="Plus d’une fois par semaine"
    '2'="Environ une fois par semaine"
    '3'="Au moins une fois par mois"
	'4'="Environ tous les deux ou trois mois"
	'5'="Moins souvent"
	'6'="Jamais";
  value $Q8_f
    '1'="Systématiquement"
    '2'="Régulièrement"
    '3'="De temps en temps"
	'4'="Rarement"
	'5'="Jamais"
	'6'="Je ne les reçois pas";
  value $Q9_f
    '1'="Très important"
    '2'="Assez important"
    '3'="Peu important"
	'4'="Pas important du tout"
	'5'="Ne sait pas";
  value $Q10_f
    '1'="Moins souvent"
    '2'="Aussi souvent"
    '3'="Plus souvent"
	'4'="C’est votre façon principale d’y aller";
  value $Q13_f
    '1'="Beaucoup trop longue"
    '2'="Un peu trop longue"
    '3'="De la bonne longueur"
	'4'="Un peu trop courte"
	'5'="Beaucoup trop courte";
  value $Q14_f
    '1'="Beaucoup plus fréquemment"
    '2'="Un peu plus fréquemment"
    '3'="A la même fréquence"
	'4'="Un peu moins fréquemment"
	'5'="Beaucoup moins fréquemment";
  value $Q16_f
    '1'="Oui, sûrement"
    '2'="Oui, sans doute"
    '3'="Non, sans doute pas"
	'4'="Non, certainement pas";
  value $Q17_f
    'H' = "Homme"
	'F' = "Femme";
  value $Q18_f
    'PRP' = "Paris ou région parisienne"
	'PROV' = "Province";
  value $Q19_f
    '1'="En couple sans enfant"
    '2'="Seul(e) sans enfant"
    '3'="En couple avec enfant(s)"
	'4'="Seul(e) avec enfant(s)"
	'5'="Chez vos parents";
  value $Q21_f
    '1'="Agriculteur exploitant"
    '2'="Artisan, commerçant, chef d'entreprise"
    '3'="Cadre, cadre supérieur"
	'4'="Profession libérale"
	'5'="Profession Intermédiaire, contremaître, agent de maîtrise"
    '6'="Employé"
    '7'="Ouvrier"
	'8'="Etudiant"
	'9'="Retraité"
	'10'="Sans activité professionnelle";
Run;

options fmtsearch=(results work); 

/* Appliquer les formats*/

data results.questionnaire_projet;
  set results.quest_complets;
  format 
    Q1 $Q1_f. Q3 $Q3_f. Q4 $Q4_f. Q5 $Q5_f. Q6 $Q6_f.
    Q7 $Q7_f. Q8 $Q8_f. Q9 $Q9_f.
    Q10 $Q10_f. Q13 $Q13_f. Q14 $Q14_f. Q16 $Q16_f.
    Q17 $Q17_f. Q18 $Q18_f. Q19 $Q19_f. Q21 $Q21_f.;
run;

/*********************************************************/

/* Suppression colonne de traitement inutile*/

data results.questionnaire_final;
  set results.questionnaire_projet(drop=top_incomplet);
run;

/*********************************************************/

/* Exportation en csv*/

PROC EXPORT DATA= results.Questionnaire_final
  OUTFILE="C:\Users\s\Desktop\MOSEF\SaS\Projet\Resultats\export_questionnaire.csv" 
  DBMS=DLM LABEL REPLACE;
  DELIMITER='3B'x; 
  PUTNAMES=YES;
RUN;
