/*********************************************************/

/* Savoir combien de clients */

proc sql;
  select count(distinct ID) as nb_clients
  from results.questionnaire_projet;
quit;
/* Une seule réponse par client*/

/*********************************************************/

/* Distribution des reponses */

proc freq data=results.questionnaire_projet;
  table Q1 / out=freq_Q1 nocum;
  table Q3 / out=freq_Q3 nocum;
  table Q4 / out=freq_Q4 nocum;
  table Q5 / out=freq_Q5 nocum;
  table Q6 / out=freq_Q6 nocum;
  table Q7 / out=freq_Q7 nocum;
  table Q8 / out=freq_Q8 nocum;
  table Q9 / out=freq_Q9 nocum;
  table Q10 / out=freq_Q10 nocum;
  table Q13 / out=freq_Q13 nocum;
  table Q14 / out=freq_Q14 nocum;
  table Q16 / out=freq_Q16 nocum;
  table Q17 / out=freq_Q17 nocum;
  table Q18 / out=freq_Q18 nocum;
  table Q19 / out=freq_Q19 nocum;
  table Q21 / out=freq_Q21 nocum;
run;

/*********************************************************/

/* Moyenne de satisfaction gloable  */
proc means data=results.questionnaire_projet mean;
  var Q12;
  output out=moy_note mean=moyenne;
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

/* Étape : Appliquer le format pour Q17, Q18, Q19, Q21*/

proc format library=results;
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

data results.quest_complets;
  set results.quest_complets;
  format 
    Q17 $Q17_f. Q18 $Q18_f. Q19 $Q19_f. Q21 $Q21_f.;
run;

/*********************************************************/

/* Étape : Convertir les colonnes de type CHAR en NUMERIC pour les colonnes ordinales */

/* Étape : Convertir les colonnes de type CHAR en NUMERIC */
data results.quest_complets_updated;
    set results.quest_complets; /* La table d'origine */
    
    /* Convertir chaque variable spécifiée en NUMERIC */
    Q1_num = input(Q1, best32.); /* Convertir Q1 en numeric */
    Q3_num = input(Q3, best32.); /* Convertir Q3 en numeric */
    Q4_num = input(Q4, best32.); /* Convertir Q4 en numeric */
    Q5_num = input(Q5, best32.); /* Convertir Q5 en numeric */
    Q6_num = input(Q6, best32.); /* Convertir Q6 en numeric */
    Q7_num = input(Q7, best32.); /* Convertir Q7 en numeric */
    Q8_num = input(Q8, best32.); /* Convertir Q8 en numeric */
    Q9_num = input(Q9, best32.); /* Convertir Q9 en numeric */
    Q10_num = input(Q10, best32.); /* Convertir Q10 en numeric */
    Q12_num = input(Q12, best32.); /* Convertir Q12 en numeric */
    Q13_num = input(Q13, best32.); /* Convertir Q13 en numeric */
    Q14_num = input(Q14, best32.); /* Convertir Q14 en numeric */
    Q16_num = input(Q16, best32.); /* Convertir Q16 en numeric */
    
run;

/* Étape : Vérifier le résultat */
proc contents data=results.quest_complets_updated;
    title "Vérification des types des colonnes après conversion";
run;

proc print data=results.quest_complets_updated (obs=10);
    title "Aperçu des données converties en NUMERIC";
run;

/*********************************************************/

/* Étape : Étude la corrélation */
proc corr data=results.quest_complets_updated kendall nosimple 
          outp=results.correlation_matrix; /* Table des coefficients */
    var Q1_num 
        Q4_num 
        Q5_num 
        Q6_num 
        Q7_num 
        Q8_num 
        Q9_num 
        Q10_num 
        Q12_num 
        Q13_num 
        Q14_num 
        Q16_num;
run;

/* Étape : Exporter les deux matrices vers Excel */

/* Ouvrir le fichier Excel */
ods excel file = "F:\Sauvegarde\Documents\MOSEF 2024-2025\S1 - SAS et SQL\projet_questionnaire_1\results\correlation.xlsx";

/* Exporter la matrice des coefficients */
ods excel options (sheet_name = "Correlation_Coefficients");

proc print data = results.correlation_matrix noobs;
    where _TYPE_ = "CORR"; /* Garder uniquement les coefficients de corrélation */
    title "Matrice des coefficients de corrélation";
run;

/* Fermer le fichier Excel */
ods excel close;

/*********************************************************/

/* Étape 1 : Extraire les valeurs distinctes des colonnes Q2, Q11 et Q15 */
proc sql;
    /* Extraire les valeurs distinctes de la colonne Q2 */
    create table results.distinct_Q2 as 
    select distinct Q2
    from donnees.reponses_quest_1;
    
    /* Extraire les valeurs distinctes de la colonne Q11 */
    create table results.distinct_Q11 as 
    select distinct Q11
    from donnees.reponses_quest_1;
    
    /* Extraire les valeurs distinctes de la colonne Q15 */
    create table results.distinct_Q15 as 
    select distinct Q15
    from donnees.reponses_quest_1;
quit;

/* Étape 2 : Afficher les valeurs distinctes des colonnes */
proc print data=results.distinct_Q2 noobs;
    title "Valeurs distinctes de la colonne Q2";
run;

proc print data=results.distinct_Q11 noobs;
    title "Valeurs distinctes de la colonne Q11";
run;

proc print data=results.distinct_Q15 noobs;
    title "Valeurs distinctes de la colonne Q15";
run;

/*********************************************************/

/* Étape : Capturer des valeurs dans les résultats pour les questions Q2, Q11 et Q15*/ 

/* Étape : Ajouter dynamiquement des colonnes avec des noms valides pour Q2, Q11 et Q15 */
data results.Quest_complets;
    set results.Quest_complets;

    /* Utiliser des noms de colonnes valides pour Q2 */
    length 
        site_marchand 8
        presse_actualite 8
        informatique 8
        jeux_loisirs 8
        documents_reference 8
        sante_medicale 8
        sciences 8
        sport 8
        reseaux_sociaux 8
        aucun_site 8;

    /* Vérifier et encoder les catégories pour Q2 */
    if index(upcase(Q2), upcase("Site marchand (e-commerce)")) > 0 then site_marchand = 1; else site_marchand = 0;
    if index(upcase(Q2), upcase("Presse, Actualité")) > 0 then presse_actualite = 1; else presse_actualite = 0;
    if index(upcase(Q2), upcase("Informatique")) > 0 then informatique = 1; else informatique = 0;
    if index(upcase(Q2), upcase("Jeux, Loisirs")) > 0 then jeux_loisirs = 1; else jeux_loisirs = 0;
    if index(upcase(Q2), upcase("Documents de référence (dictionnaire, archive…)")) > 0 then documents_reference = 1; else documents_reference = 0;
    if index(upcase(Q2), upcase("Santé, médicale")) > 0 then sante_medicale = 1; else sante_medicale = 0;
    if index(upcase(Q2), upcase("Sciences")) > 0 then sciences = 1; else sciences = 0;
    if index(upcase(Q2), upcase("Sport")) > 0 then sport = 1; else sport = 0;
    if index(upcase(Q2), upcase("Réseaux sociaux")) > 0 then reseaux_sociaux = 1; else reseaux_sociaux = 0;
    if index(upcase(Q2), upcase("Je ne visite aucun site en particulier")) > 0 then aucun_site = 1; else aucun_site = 0;

    /* Ajouter des labels pour afficher les noms complets */
    label 
        site_marchand = "Site marchand (e-commerce)"
        presse_actualite = "Presse, Actualité"
        informatique = "Informatique"
        jeux_loisirs = "Jeux, Loisirs"
        documents_reference = "Documents de référence (dictionnaire, archive...)"
        sante_medicale = "Santé, médicale"
        sciences = "Sciences"
        sport = "Sport"
        reseaux_sociaux = "Réseaux sociaux"
        aucun_site = "Je ne visite aucun site en particulier";

    /* Ajouter des colonnes dynamiques pour Q11 */
    length 
        recevoir_actualites 8
        offres_promotionnelles 8
        informe_produits 8
        suivre_actualite_forum 8
        par_curiosite 8
        conseils_expert 8
        idees_sorties 8
        petites_annonces 8;

    /* Vérifier et encoder les catégories pour Q11 */
    if index(upcase(Q11), upcase("Recevoir des actualités")) > 0 then recevoir_actualites = 1; else recevoir_actualites = 0;
    if index(upcase(Q11), upcase("Bénéficier d'offres promotionnelles")) > 0 then offres_promotionnelles = 1; else offres_promotionnelles = 0;
    if index(upcase(Q11), upcase("Etre informé sur les produits/marques")) > 0 then informe_produits = 1; else informe_produits = 0;
    if index(upcase(Q11), upcase("forum")) > 0 then suivre_actualite_forum = 1; else suivre_actualite_forum = 0;
    if index(upcase(Q11), upcase("Simplement par curiosité")) > 0 then par_curiosite = 1; else par_curiosite = 0;
    if index(upcase(Q11), upcase("Avoir accès aux conseils d’un expert")) > 0 then conseils_expert = 1; else conseils_expert = 0;
    if index(upcase(Q11), upcase("Recevoir des adresses près de chez moi, des idées de sorties")) > 0 then idees_sorties = 1; else idees_sorties = 0;
    if index(upcase(Q11), upcase("Recevoir des petites annonces")) > 0 then petites_annonces = 1; else petites_annonces = 0;

    /* Ajouter des labels pour afficher les noms complets de Q11 */
    label 
        recevoir_actualites = "Recevoir des actualités"
        offres_promotionnelles = "Bénéficier d'offres promotionnelles"
        informe_produits = "Etre informé sur les produits/marques"
        suivre_actualite_forum = "Suivre l'actualité d'un forum, d'un blog,…"
        par_curiosite = "Simplement par curiosité"
        conseils_expert = "Avoir accès aux conseils d’un expert"
        idees_sorties = "Recevoir des adresses près de chez moi, des idées de sorties"
        petites_annonces = "Recevoir des petites annonces";

    /* Ajouter des colonnes dynamiques pour Q15 */
    length 
        manque_de_temps 8
        liens_trop_lents 8
        liens_non_fonctionnels 8
        mise_en_forme_incorrecte 8
        images_bloquees 8
        email_spam 8
        aucun_probleme 8
        autres 8;

    /* Vérifier et encoder les catégories pour Q15 */
    if index(upcase(Q15), upcase("Le manque de temps")) > 0 then manque_de_temps = 1; else manque_de_temps = 0;
    if index(upcase(Q15), upcase("Les liens sont trop lents")) > 0 then liens_trop_lents = 1; else liens_trop_lents = 0;
    if index(upcase(Q15), upcase("Certains liens ne fonctionnent pas")) > 0 then liens_non_fonctionnels = 1; else liens_non_fonctionnels = 0;
    if index(upcase(Q15), upcase("La mise en forme ne s’affiche pas correctement")) > 0 then mise_en_forme_incorrecte = 1; else mise_en_forme_incorrecte = 0;
    if index(upcase(Q15), upcase("Les images sont bloquées")) > 0 then images_bloquees = 1; else images_bloquees = 0;
    if index(upcase(Q15), upcase("L’email est classé automatiquement comme spam.")) > 0 then email_spam = 1; else email_spam = 0;
    if index(upcase(Q15), upcase("Je n’ai pas rencontré de problème particulier")) > 0 then aucun_probleme = 1; else aucun_probleme = 0;
    if index(upcase(Q15), upcase("Autres")) > 0 then autres = 1; else autres = 0;

    /* Ajouter des labels pour afficher les noms complets de Q15 */
    label 
        manque_de_temps = "Le manque de temps"
        liens_trop_lents = "Les liens sont trop lents"
        liens_non_fonctionnels = "Certains liens ne fonctionnent pas"
        mise_en_forme_incorrecte = "La mise en forme ne s’affiche pas correctement"
        images_bloquees = "Les images sont bloquées"
        email_spam = "L’email est classé automatiquement comme spam."
        aucun_probleme = "Je n’ai pas rencontré de problème particulier"
        autres = "Autres";
run;

/* Étape 3 : Afficher les résultats */
proc print data=results.Quest_complets (obs=50) label;
    var Q2 site_marchand presse_actualite informatique jeux_loisirs 
        documents_reference sante_medicale sciences sport reseaux_sociaux aucun_site;
    title "Résultat encodé pour les catégories de Q2";
run;

proc print data=results.Quest_complets (obs=50) label;
    var Q11 recevoir_actualites offres_promotionnelles informe_produits suivre_actualite_forum 
        par_curiosite conseils_expert idees_sorties petites_annonces;
    title "Résultat encodé pour les catégories de Q11";
run;

proc print data=results.Quest_complets (obs=50) label;
    var Q15 manque_de_temps liens_trop_lents liens_non_fonctionnels mise_en_forme_incorrecte
        images_bloquees email_spam aucun_probleme autres;
    title "Résultat encodé pour les catégories de Q15";
run;

/*********************************************************/

/* Étape : Analyse la relation entre les question Q2 et Q17*/ 

ods graphics off / reset width=2in height=2in; /* Définir la taille des graphiques */
*ods pdf file="Répartition de Q2 par Sexe (Q17).pdf"; /* Exporter les graphiques dans un fichier PDF */
ods layout gridded columns=3 advance=bygroup; /* Organiser 3 graphiques par ligne dans une disposition en grille */

/* Liste des variables à analyser */
%let variables = site_marchand presse_actualite informatique jeux_loisirs 
                 documents_reference sante_medicale sciences sport 
                 reseaux_sociaux aucun_site;

/* Macro pour créer automatiquement les graphiques */
%macro plot_interactions_q2_q17;
    %local i var;
    %do i = 1 %to %sysfunc(countw(&variables));
        %let var = %scan(&variables, &i);

        proc sgplot data=results.Quest_complets;
            vbar Q17 / response=&var group=Q17 stat=percent datalabel;
			styleattrs datacolors=(salmon lightblue);
            title "Répartition de &var (Q2) par Sexe (Q17)";
        run;
    %end;
%mend plot_interactions_q2_q17;

/* Appeler la macro pour générer les graphiques */
%plot_interactions_q2_q17;

ods layout end;
ods pdf close;

/*********************************************************/

/* Étape : Analyse la relation entre les question Q11 et Q17*/ 

ods graphics off / reset width=2in height=2in; /* Définir la taille des graphiques */
*ods pdf file="Répartition de Q11 par Sexe (Q17).pdf"; /* Exporter les graphiques dans un fichier PDF */
ods layout gridded columns=3 advance=bygroup; /* Organiser 3 graphiques par ligne dans une disposition en grille */

/* Liste des variables de Q11 à analyser */
%let variables = recevoir_actualites offres_promotionnelles informe_produits suivre_actualite_forum 
                 par_curiosite conseils_expert idees_sorties petites_annonces;

/* Macro pour créer automatiquement les graphiques */
%macro plot_interactions_q11_q17;
    %local i var;
    %do i = 1 %to %sysfunc(countw(&variables));
        %let var = %scan(&variables, &i);

        proc sgplot data=results.Quest_complets;
            vbar Q17 / response=&var group=Q17 stat=percent datalabel;
            styleattrs datacolors=(peachpuff lightsteelblue);
            title "Répartition de &var (Q11) par Sexe (Q17)";
        run;
    %end;
%mend plot_interactions_q11_q17;

/* Appeler la macro pour générer les graphiques */
%plot_interactions_q11_q17;

ods layout end;
ods pdf close;

/*********************************************************/

/* Étape : Analyse la relation entre les question Q2 et Q20*/ 

ods graphics / reset width=6in height=6in; /* Définir la taille des graphiques */
*ods pdf file="Répartition_Q20_Q2.pdf"; /* Exporter les graphiques dans un fichier PDF */
ods layout gridded columns=3 advance=bygroup; /* Organiser 3 graphiques par ligne dans une disposition en grille */

/* Liste des variables à analyser */
%let variables = site_marchand presse_actualite informatique jeux_loisirs 
                 documents_reference sante_medicale sciences sport 
                 reseaux_sociaux aucun_site;

/* Macro pour créer automatiquement les graphiques */
%macro plot_interactions_q20_q2;
    %local i var;
    %do i = 1 %to %sysfunc(countw(&variables));
        %let var = %scan(&variables, &i);

        proc sgplot data=results.Quest_complets;
            vbar Q20 / response=&var group=Q20 stat=percent datalabel;
			styleattrs datacolors=(lightblue coral); /* Définir des couleurs douces */
            title "Répartition de &var (Q2) par Tranche d'âge (Q20)";
        run;
    %end;
%mend plot_interactions_q20_q2;

/* Appeler la macro pour générer les graphiques */
%plot_interactions_q20_q2;

ods layout end;
ods pdf close;

/*********************************************************/

/* Étape : Analyse la relation entre les question Q11 et Q20*/ 

ods graphics / reset width=6in height=6in; /* Définir la taille des graphiques */
*ods pdf file="Répartition de Q11 par Tranche d'âge (Q20).pdf"; /* Exporter les graphiques dans un fichier PDF */
ods layout gridded columns=3 advance=bygroup; /* Organiser 3 graphiques par ligne dans une disposition en grille */

/* Liste des variables de Q11 à analyser */
%let variables = recevoir_actualites offres_promotionnelles informe_produits suivre_actualite_forum 
                 par_curiosite conseils_expert idees_sorties petites_annonces;

/* Macro pour créer automatiquement les graphiques */
%macro plot_interactions_q20_q11;
    %local i var;
    %do i = 1 %to %sysfunc(countw(&variables));
        %let var = %scan(&variables, &i);

        proc sgplot data=results.Quest_complets;
            vbar Q20 / response=&var group=Q20 stat=percent datalabel;
            styleattrs datacolors=(palegoldenrod powderblue); /* Palette de couleurs */
            title "Répartition de &var (Q11) par Tranche d'âge (Q20)";
        run;
    %end;
%mend plot_interactions_q20_q11;

/* Appeler la macro pour générer les graphiques */
%plot_interactions_q20_q11;

ods layout end;
ods pdf close;

/*********************************************************/

/* Étape : Analyse la relation entre les question Q18 et Q2*/ 

ods graphics off / reset width=2in height=2in; /* Définir la taille des graphiques */
*ods pdf file="Répartition de Q2 par Lieu de résidence (Q18).pdf"; /* Exporter les graphiques dans un fichier PDF */
ods layout gridded columns=3 advance=bygroup; /* Organiser 3 graphiques par ligne dans une disposition en grille */

/* Liste des variables à analyser */
%let variables = site_marchand presse_actualite informatique jeux_loisirs 
                 documents_reference sante_medicale sciences sport 
                 reseaux_sociaux aucun_site;

/* Macro pour créer automatiquement les graphiques */
%macro plot_interactions_q2_q18;
    %local i var;
    %do i = 1 %to %sysfunc(countw(&variables));
        %let var = %scan(&variables, &i);

        proc sgplot data=results.Quest_complets;
            vbar Q18 / response=&var group=Q18 stat=percent datalabel;
			styleattrs datacolors=("PaleTurquoise" "LightCoral");
            title "Répartition de &var (Q2) par Lieu de résidence (Q18)";
        run;
    %end;
%mend plot_interactions_q2_q18;

/* Appeler la macro pour générer les graphiques */
%plot_interactions_q2_q18;

ods layout end;
ods pdf close;

/*********************************************************/

/* Étape : Analyse la relation entre les question Q18 et Q11 */ 

ods graphics / reset width=6in height=6in; /* Définir la taille des graphiques */
*ods pdf file="Répartition de Q11 par Lieu de résidence (Q18).pdf"; /* Exporter les graphiques dans un fichier PDF */
ods layout gridded columns=3 advance=bygroup; /* Organiser 3 graphiques par ligne dans une disposition en grille */

/* Liste des variables de Q11 à analyser */
%let variables = recevoir_actualites offres_promotionnelles informe_produits suivre_actualite_forum 
                 par_curiosite conseils_expert idees_sorties petites_annonces;

/* Macro pour créer automatiquement les graphiques */
%macro plot_interactions_q11_q18;
    %local i var;
    %do i = 1 %to %sysfunc(countw(&variables));
        %let var = %scan(&variables, &i);

        proc sgplot data=results.Quest_complets;
            vbar Q18 / response=&var group=Q18 stat=percent datalabel;
            styleattrs datacolors=(palegoldenrod powderblue); /* Palette de couleurs */
            title "Répartition de &var (Q11) par Lieu de résidence (Q18)";
        run;
    %end;
%mend plot_interactions_q11_q18;

/* Appeler la macro pour générer les graphiques */
%plot_interactions_q11_q18;

ods layout end;
ods pdf close;

/*********************************************************/

/* Étape : Analyse la relation entre les question Q19 et Q2 */ 

ods graphics off / reset width=2in height=2in; /* Définir la taille des graphiques */
*ods pdf file="Répartition de Q2 par Situation familiale (Q19).pdf"; /* Exporter les graphiques dans un fichier PDF */
ods layout gridded columns=3 advance=bygroup; /* Organiser 3 graphiques par ligne dans une disposition en grille */

/* Liste des variables à analyser */
%let variables = site_marchand presse_actualite informatique jeux_loisirs 
                 documents_reference sante_medicale sciences sport 
                 reseaux_sociaux aucun_site;

/* Macro pour créer automatiquement les graphiques */
%macro plot_interactions_q2_q19;
    %local i var;
    %do i = 1 %to %sysfunc(countw(&variables));
        %let var = %scan(&variables, &i);

        proc sgplot data=results.Quest_complets;
            vbar Q19 / response=&var group=Q19 stat=percent datalabel;
            styleattrs datacolors=("LightSlateGray" "RosyBrown");
            title "Répartition de &var (Q2) par Situation familiale (Q19)";
        run;
    %end;
%mend plot_interactions_q2_q19;

/* Appeler la macro pour générer les graphiques */
%plot_interactions_q2_q19;

ods layout end;
ods pdf close;

/*********************************************************/

/* Étape : Analyse la relation entre les question Q19 et Q11 */ 

ods graphics / reset width=6in height=6in; /* Définir la taille des graphiques */
*ods pdf file="Répartition de Q11 par Situation familiale (Q19).pdf"; /* Exporter les graphiques dans un fichier PDF */
ods layout gridded columns=3 advance=bygroup; /* Organiser 3 graphiques par ligne dans une disposition en grille */

/* Liste des variables de Q11 à analyser */
%let variables = recevoir_actualites offres_promotionnelles informe_produits suivre_actualite_forum 
                 par_curiosite conseils_expert idees_sorties petites_annonces;

/* Macro pour créer automatiquement les graphiques */
%macro plot_interactions_q11_q19;
    %local i var;
    %do i = 1 %to %sysfunc(countw(&variables));
        %let var = %scan(&variables, &i);

        proc sgplot data=results.Quest_complets;
            vbar Q19 / response=&var group=Q19 stat=percent datalabel;
            styleattrs datacolors=("LightGoldenrodYellow" "PaleGreen"); /* Palette de couleurs */
            title "Répartition de &var (Q11) par Situation familiale (Q19)";
        run;
    %end;
%mend plot_interactions_q11_q19;

/* Appeler la macro pour générer les graphiques */
%plot_interactions_q11_q19;

ods layout end;
ods pdf close;

/*********************************************************/


