# 📋 Product Owner Document — Stock Index Return Prediction

> **Projet :** Prédiction du rendement futur d'indices boursiers avec régression linéaire multiple, descente de gradient et déploiement MLOps
>
> **Product Owner :** [Mouhamadou Lamine SOW]
>
> **Date de création :** 02 juillet 2026
>
> **Version :** 1.0
>
> **Contexte :** Projet portfolio étudiant — développeur solo

---

## 🎯 Vision Produit

Développer un outil d'aide à la décision pour une banque d'investissement, capable de prédire le rendement futur d'indices boursiers mondiaux à partir de variables financières historiques. La solution repose sur un modèle de régression linéaire multiple optimisé par descente de gradient, exposé via une API et une interface web accessible aux analystes financiers.

---

## 👤 Personas

| Persona | Description | Besoin principal |
|---------|-------------|------------------|
| **Analyste financier** | Professionnel de la banque d'investissement qui évalue les marchés | Obtenir rapidement une prédiction de rendement pour orienter ses décisions |
| **Gestionnaire de portefeuille** | Décideur qui alloue le capital sur différents marchés | Comparer les rendements prédits entre plusieurs indices pour optimiser l'allocation |
| **Data Scientist interne** | Profil technique qui audite et améliore les modèles | Comprendre la méthodologie, évaluer la performance, réentraîner le modèle |
| **Recruteur / Évaluateur** *(contexte portfolio)* | Personne qui évalue les compétences du candidat | Voir un projet complet, structuré, fonctionnel et déployé |

---

## 🧩 Découpage en Modules

Le projet est structuré en **5 modules** suivant le pipeline MLOps :

```
Module 1: Data Ingestion & Preprocessing
         ↓
Module 2: Feature Engineering
         ↓
Module 3: Model Training & Optimization
         ↓
Module 4: Prediction API
         ↓
Module 5: Web Interface
```

---

---

# Module 1 — Data Ingestion & Preprocessing

## 1. Nom du module

**Data Ingestion & Preprocessing**

## 2. Objectif du module

Collecter le dataset financier depuis Hugging Face, le nettoyer, le transformer et le préparer pour la phase de feature engineering et d'entraînement du modèle.

## 3. Problème métier ou utilisateur résolu

Les données financières brutes contiennent des valeurs manquantes, des types incohérents, des doublons et des séries temporelles non alignées. Sans nettoyage, le modèle produira des prédictions erronées ou ne pourra pas être entraîné du tout. Ce module garantit la **fiabilité et la qualité des données en entrée** du pipeline.

## 4. Utilisateurs concernés

| Persona | Interaction |
|---------|-------------|
| Data Scientist interne | Utilise directement les scripts de preprocessing, peut les adapter |
| Recruteur / Évaluateur | Évalue la rigueur du traitement de données |

## 5. Notre approche produit

- Automatiser entièrement le pipeline de collecte et nettoyage via des scripts Python reproductibles
- Stocker les données brutes séparément des données nettoyées (`data/raw/` vs `data/processed/`)
- Documenter chaque transformation appliquée pour assurer la traçabilité
- Utiliser la librairie `datasets` de Hugging Face pour un chargement standardisé
- Filtrer le dataset pour travailler sur un ou plusieurs indices spécifiques (ex: S&P 500, CAC 40)

## 6. Fonctionnalités principales

| ID | Fonctionnalité | Description |
|----|----------------|-------------|
| F1.1 | Chargement du dataset | Téléchargement automatique depuis Hugging Face via la librairie `datasets` |
| F1.2 | Exploration initiale | Affichage des statistiques descriptives, types, dimensions, valeurs uniques |
| F1.3 | Nettoyage des données | Suppression des doublons, gestion des valeurs manquantes (suppression ou imputation), conversion des types |
| F1.4 | Filtrage par indice | Possibilité de sélectionner un ou plusieurs indices boursiers (colonne `Name` ou `Symbol`) |
| F1.5 | Tri chronologique | Tri des données par date pour respecter l'ordre temporel des séries |
| F1.6 | Sauvegarde des données nettoyées | Export en CSV dans `data/processed/` |

## 7. User Stories

| ID | User Story | Priorité |
|----|------------|----------|
| US1.1 | **En tant que** Data Scientist, **je veux** charger automatiquement le dataset depuis Hugging Face **afin de** ne pas dépendre d'un téléchargement manuel | Must Have |
| US1.2 | **En tant que** Data Scientist, **je veux** voir les statistiques descriptives du dataset brut **afin de** comprendre la distribution et la qualité des données | Must Have |
| US1.3 | **En tant que** Data Scientist, **je veux** que les valeurs manquantes soient gérées automatiquement **afin de** ne pas avoir d'erreurs lors de l'entraînement | Must Have |
| US1.4 | **En tant que** Data Scientist, **je veux** filtrer les données par indice boursier **afin de** construire un modèle spécifique à un marché | Should Have |
| US1.5 | **En tant que** Data Scientist, **je veux** que les données nettoyées soient sauvegardées dans un fichier séparé **afin de** ne pas relancer le preprocessing à chaque fois | Must Have |
| US1.6 | **En tant que** évaluateur, **je veux** voir un notebook d'exploration clair et commenté **afin de** juger la rigueur du candidat | Should Have |

## 8. Critères d'acceptation

| ID | Critère |
|----|---------|
| CA1.1 | Le dataset est chargé avec succès depuis Hugging Face sans intervention manuelle |
| CA1.2 | Le dataset nettoyé ne contient aucune valeur manquante (NaN) dans les colonnes utilisées |
| CA1.3 | Le dataset nettoyé ne contient aucun doublon |
| CA1.4 | La colonne `Date` est au format datetime et les données sont triées chronologiquement |
| CA1.5 | Les colonnes numériques (`Open`, `High`, `Low`, `Close`, `Adj Close`, `Volume`) sont de type float64 ou int64 |
| CA1.6 | Un fichier CSV nettoyé est généré dans `data/processed/` |
| CA1.7 | Le script `src/preprocessing.py` peut être exécuté de manière autonome (hors notebook) |

## 9. Priorité

> **Must Have** — Sans données propres, aucun module suivant ne peut fonctionner.

## 10. Dépendances avec les autres modules

| Direction | Module | Nature de la dépendance |
|-----------|--------|------------------------|
| ➡️ Fournit à | Module 2 (Feature Engineering) | Fournit le dataset nettoyé en entrée |
| ➡️ Fournit à | Module 3 (Training) | Le format et la qualité des données impactent directement la performance du modèle |

## 11. Risques ou points d'attention

| Risque | Impact | Mitigation |
|--------|--------|------------|
| Dataset Hugging Face indisponible ou modifié | Bloquant — impossible de charger les données | Prévoir un fallback avec un fichier CSV local versionné |
| Volume de données trop important pour un traitement local | Performance — temps de calcul long | Filtrer sur un sous-ensemble d'indices et une fenêtre temporelle |
| Valeurs aberrantes non détectées | Qualité — biais dans le modèle | Ajouter une étape de détection d'outliers (IQR ou z-score) |
| Fuites temporelles (data leakage) | Fiabilité — surévaluation des performances | S'assurer que le split train/test respecte l'ordre chronologique |

## 12. Livrables attendus

| Livrable | Format | Emplacement |
|----------|--------|-------------|
| Script de preprocessing | Python (.py) | `src/preprocessing.py` |
| Notebook d'exploration | Jupyter (.ipynb) | `notebooks/exploration_and_training.ipynb` |
| Dataset nettoyé | CSV | `data/processed/cleaned_data.csv` |
| Documentation du preprocessing | Section dans README | `README.md` |

## 13. Indicateurs de succès / KPIs

| KPI | Cible |
|-----|-------|
| Taux de complétude des données | 100% (aucun NaN dans les colonnes utilisées) |
| Nombre de doublons restants | 0 |
| Temps d'exécution du preprocessing | < 30 secondes |
| Reproductibilité | Le script produit le même output à chaque exécution sur les mêmes données |

## 14. Questions à clarifier avant développement

- [ ] Quels indices boursiers spécifiques doivent être inclus dans le MVP ? (S&P 500 uniquement ? Plusieurs indices ?)
- [ ] Quelle stratégie pour les valeurs manquantes : suppression des lignes ou imputation (moyenne, forward-fill) ?
- [ ] Faut-il limiter la période temporelle (ex: uniquement les 5 dernières années) ?
- [ ] Les données `Adj Close` et `Close` sont-elles toutes deux nécessaires, ou peut-on n'en garder qu'une ?

---

---

# Module 2 — Feature Engineering

## 1. Nom du module

**Feature Engineering**

## 2. Objectif du module

Construire les variables explicatives (features) à partir des données nettoyées, afin de fournir au modèle de régression des indicateurs financiers pertinents pour la prédiction du rendement futur.

## 3. Problème métier ou utilisateur résolu

Les données brutes (prix, volume) ne sont pas directement exploitables par un modèle de régression pour prédire le rendement futur. Il faut **transformer ces données en indicateurs financiers significatifs** (rendement courant, volatilité, moyennes mobiles, spreads) qui capturent les dynamiques de marché.

## 4. Utilisateurs concernés

| Persona | Interaction |
|---------|-------------|
| Data Scientist interne | Crée et ajuste les features, analyse leur pertinence |
| Analyste financier | Comprend la signification financière des variables choisies |
| Recruteur / Évaluateur | Évalue la pertinence et la créativité du feature engineering |

## 5. Notre approche produit

- Créer un module Python dédié (`src/features.py`) réutilisable et paramétrable
- Chaque feature est une fonction indépendante, testable isolément
- Documenter la justification financière de chaque variable
- Calculer la variable cible (`future_return`) dans ce même module
- Permettre le paramétrage (fenêtre de volatilité, périodes des moyennes mobiles)

## 6. Fonctionnalités principales

| ID | Fonctionnalité | Description |
|----|----------------|-------------|
| F2.1 | Calcul du rendement courant (`return_t`) | `(Close_t - Close_{t-1}) / Close_{t-1}` |
| F2.2 | Calcul du rendement futur (`future_return`) | `(Close_{t+1} - Close_t) / Close_t` — variable cible |
| F2.3 | Calcul du spread High-Low | `High - Low` pour mesurer la volatilité intra-journalière |
| F2.4 | Calcul du spread Open-Close | `Open - Close` pour mesurer la direction du marché |
| F2.5 | Calcul de la volatilité historique | Écart-type glissant du rendement sur N jours |
| F2.6 | Moyenne mobile courte | Moyenne glissante du prix de clôture sur N jours (ex: 5 jours) |
| F2.7 | Moyenne mobile longue | Moyenne glissante du prix de clôture sur M jours (ex: 20 jours) |
| F2.8 | Suppression des lignes NaN résultantes | Les calculs glissants créent des NaN en début de série |
| F2.9 | Normalisation / Standardisation | Mise à l'échelle des features pour la descente de gradient |

## 7. User Stories

| ID | User Story | Priorité |
|----|------------|----------|
| US2.1 | **En tant que** Data Scientist, **je veux** calculer automatiquement les rendements courant et futur **afin de** disposer de la variable cible et du feature principal | Must Have |
| US2.2 | **En tant que** Data Scientist, **je veux** générer les spreads High-Low et Open-Close **afin de** capturer la volatilité et la direction du marché | Must Have |
| US2.3 | **En tant que** Data Scientist, **je veux** calculer la volatilité historique sur une fenêtre paramétrable **afin de** mesurer le risque récent | Must Have |
| US2.4 | **En tant que** Data Scientist, **je veux** créer des moyennes mobiles courte et longue **afin de** capturer les tendances de prix | Should Have |
| US2.5 | **En tant que** Data Scientist, **je veux** normaliser les features **afin de** garantir une convergence rapide de la descente de gradient | Must Have |
| US2.6 | **En tant que** Data Scientist, **je veux** pouvoir paramétrer les fenêtres de calcul (volatilité, moyennes mobiles) **afin de** tester différentes configurations | Could Have |
| US2.7 | **En tant que** analyste financier, **je veux** comprendre la signification de chaque feature **afin de** valider la pertinence du modèle | Should Have |

## 8. Critères d'acceptation

| ID | Critère |
|----|---------|
| CA2.1 | Les colonnes `return_t` et `future_return` sont correctement calculées et vérifiables manuellement sur quelques exemples |
| CA2.2 | Les spreads `high_low_spread` et `open_close_spread` correspondent bien aux différences attendues |
| CA2.3 | La volatilité est calculée comme l'écart-type glissant sur la fenêtre spécifiée |
| CA2.4 | Les moyennes mobiles sont calculées sur les fenêtres courte (ex: 5j) et longue (ex: 20j) |
| CA2.5 | Toutes les lignes contenant des NaN (dus aux calculs glissants) sont supprimées |
| CA2.6 | Les features sont normalisées (moyenne ≈ 0, écart-type ≈ 1) ou min-max scalées |
| CA2.7 | Le module `src/features.py` est importable et utilisable indépendamment du notebook |
| CA2.8 | Les paramètres de normalisation (mean, std ou min, max) sont sauvegardés pour le déploiement |

## 9. Priorité

> **Must Have** — Les features sont l'input direct du modèle. Sans elles, pas de prédiction.

## 10. Dépendances avec les autres modules

| Direction | Module | Nature de la dépendance |
|-----------|--------|------------------------|
| ⬅️ Dépend de | Module 1 (Preprocessing) | Nécessite le dataset nettoyé en entrée |
| ➡️ Fournit à | Module 3 (Training) | Fournit la matrice de features X et le vecteur cible y |
| ➡️ Fournit à | Module 4 (API) | Les mêmes transformations doivent être appliquées aux inputs de l'API |

## 11. Risques ou points d'attention

| Risque | Impact | Mitigation |
|--------|--------|------------|
| Fuite de données (data leakage) | Fiabilité — le future_return utilise le prix futur, il ne doit jamais être un feature | Séparer clairement X (features) et y (cible) |
| Fenêtres glissantes trop larges | Perte de données — trop de lignes supprimées en début de série | Choisir des fenêtres raisonnables (5j, 20j) |
| Normalisation non sauvegardée | Bug en production — l'API ne peut pas normaliser les inputs | Sauvegarder les paramètres de normalisation (pickle/json) |
| Multi-colinéarité entre features | Modèle instable — coefficients aberrants | Analyser la matrice de corrélation, envisager une sélection de features |

## 12. Livrables attendus

| Livrable | Format | Emplacement |
|----------|--------|-------------|
| Script de feature engineering | Python (.py) | `src/features.py` |
| Paramètres de normalisation | Pickle ou JSON | `models/scaler_params.pkl` |
| Matrice de corrélation (visualisation) | Image PNG | `notebooks/` ou `reports/` |
| Documentation des features | Section dans README ou docstrings | `README.md` / `src/features.py` |

## 13. Indicateurs de succès / KPIs

| KPI | Cible |
|-----|-------|
| Nombre de features générées | ≥ 7 variables explicatives |
| Taux de NaN après feature engineering | 0% |
| Corrélation max entre features | < 0.95 (éviter la multi-colinéarité parfaite) |
| Features normalisées | Moyenne ≈ 0, Std ≈ 1 (si standardisation) |

## 14. Questions à clarifier avant développement

- [ ] Quelle fenêtre utiliser pour la volatilité historique ? (5 jours ? 10 jours ? 20 jours ?)
- [ ] Quelles périodes pour les moyennes mobiles courte et longue ? (5j/20j ? 7j/30j ?)
- [ ] Faut-il inclure le volume brut ou le normaliser ?
- [ ] Faut-il ajouter des features supplémentaires comme le RSI ou le MACD (optionnel, Could Have) ?
- [ ] Standardisation (Z-score) ou normalisation Min-Max ? (Z-score recommandé pour la descente de gradient)

---

---

# Module 3 — Model Training & Optimization

## 1. Nom du module

**Model Training & Optimization (Gradient Descent)**

## 2. Objectif du module

Entraîner un modèle de régression linéaire multiple en implémentant la descente de gradient depuis zéro (from scratch), évaluer ses performances, et sauvegarder le modèle entraîné pour le déploiement.

## 3. Problème métier ou utilisateur résolu

La banque d'investissement a besoin d'un **modèle quantitatif fiable** pour remplacer les méthodes d'analyse traditionnelles qui ont échoué. Ce module résout le problème central : **produire un modèle entraîné capable de prédire le rendement futur** avec des métriques de performance mesurables et transparentes.

## 4. Utilisateurs concernés

| Persona | Interaction |
|---------|-------------|
| Data Scientist interne | Développe, entraîne, évalue et itère sur le modèle |
| Gestionnaire de portefeuille | Interprète les résultats et les métriques de performance |
| Recruteur / Évaluateur | Évalue la compréhension algorithmique (gradient descent from scratch) |

## 5. Notre approche produit

- **Implémenter la descente de gradient from scratch** avec NumPy (pas uniquement sklearn) — c'est le cœur pédagogique et technique du projet
- Proposer aussi une comparaison avec sklearn `LinearRegression` pour valider les résultats
- Split temporel (pas random) pour respecter la nature des séries temporelles
- Visualiser la convergence de la loss pendant l'entraînement
- Sauvegarder le modèle (coefficients + biais) pour le déploiement

## 6. Fonctionnalités principales

| ID | Fonctionnalité | Description |
|----|----------------|-------------|
| F3.1 | Split train/test temporel | Division 80/20 en respectant l'ordre chronologique (pas de shuffle) |
| F3.2 | Implémentation de la descente de gradient | Calcul itératif des gradients, mise à jour des poids, minimisation du MSE |
| F3.3 | Hyperparamètres configurables | Learning rate, nombre d'itérations, tolérance de convergence |
| F3.4 | Courbe de convergence | Visualisation de la loss (MSE) au fil des itérations |
| F3.5 | Évaluation du modèle | Calcul de MSE, RMSE et R² sur le jeu de test |
| F3.6 | Comparaison avec sklearn | Entraîner un modèle sklearn pour valider la cohérence des résultats |
| F3.7 | Sauvegarde du modèle | Export des coefficients (weights), du biais et des paramètres de normalisation |
| F3.8 | Visualisation des prédictions | Graphique comparant les valeurs réelles vs prédites |

## 7. User Stories

| ID | User Story | Priorité |
|----|------------|----------|
| US3.1 | **En tant que** Data Scientist, **je veux** diviser les données en train/test chronologiquement **afin de** simuler un scénario réaliste de prédiction | Must Have |
| US3.2 | **En tant que** Data Scientist, **je veux** implémenter la descente de gradient from scratch **afin de** démontrer ma compréhension de l'algorithme d'optimisation | Must Have |
| US3.3 | **En tant que** Data Scientist, **je veux** configurer le learning rate et le nombre d'itérations **afin de** trouver le meilleur compromis vitesse/précision | Must Have |
| US3.4 | **En tant que** Data Scientist, **je veux** visualiser la courbe de convergence **afin de** vérifier que le modèle converge correctement | Must Have |
| US3.5 | **En tant que** Data Scientist, **je veux** évaluer le modèle avec MSE, RMSE et R² **afin de** mesurer objectivement ses performances | Must Have |
| US3.6 | **En tant que** Data Scientist, **je veux** comparer mes résultats avec sklearn **afin de** valider que mon implémentation est correcte | Should Have |
| US3.7 | **En tant que** Data Scientist, **je veux** sauvegarder le modèle entraîné **afin de** le réutiliser dans l'API sans ré-entraîner | Must Have |
| US3.8 | **En tant que** gestionnaire, **je veux** voir un graphique prédictions vs réalité **afin de** évaluer visuellement la qualité du modèle | Should Have |

## 8. Critères d'acceptation

| ID | Critère |
|----|---------|
| CA3.1 | Le split train/test est chronologique (les dates du test set sont postérieures au train set) |
| CA3.2 | La descente de gradient est implémentée sans utiliser `sklearn.linear_model` pour l'entraînement |
| CA3.3 | La courbe de convergence montre une diminution progressive de la loss |
| CA3.4 | Le MSE, RMSE et R² sont calculés sur le jeu de test et affichés clairement |
| CA3.5 | Les résultats sont cohérents avec ceux obtenus via sklearn (écart < 5% sur les métriques) |
| CA3.6 | Le modèle est sauvegardé dans un fichier (`models/trained_model.pkl`) contenant les weights et le bias |
| CA3.7 | Le script `src/train.py` peut être exécuté de manière autonome |
| CA3.8 | Le script `src/evaluate.py` charge le modèle sauvegardé et produit les métriques |

## 9. Priorité

> **Must Have** — C'est le cœur du projet. Sans modèle entraîné, pas de prédiction, pas d'API, pas de valeur.

## 10. Dépendances avec les autres modules

| Direction | Module | Nature de la dépendance |
|-----------|--------|------------------------|
| ⬅️ Dépend de | Module 2 (Feature Engineering) | Nécessite la matrice X et le vecteur y |
| ➡️ Fournit à | Module 4 (API) | Fournit le modèle sauvegardé (weights + bias) |
| ➡️ Fournit à | Module 5 (Frontend) | Les métriques de performance peuvent être affichées dans l'interface |

## 11. Risques ou points d'attention

| Risque | Impact | Mitigation |
|--------|--------|------------|
| Learning rate trop élevé | La loss diverge au lieu de converger | Implémenter un early stopping ou tester plusieurs valeurs (0.01, 0.001, 0.0001) |
| Learning rate trop faible | Convergence extrêmement lente | Fixer un nombre max d'itérations raisonnable (ex: 10 000) |
| Overfitting sur le train set | Bonnes métriques train, mauvaises métriques test | Comparer systématiquement les métriques train vs test |
| R² très faible ou négatif | Le modèle n'a pas de pouvoir prédictif | Revoir les features, tester d'autres approches — documenter l'analyse même si le résultat est mauvais |
| Gradient explosion avec features non normalisées | La descente de gradient échoue | S'assurer que le Module 2 normalise correctement les données |

## 12. Livrables attendus

| Livrable | Format | Emplacement |
|----------|--------|-------------|
| Script d'entraînement | Python (.py) | `src/train.py` |
| Script d'évaluation | Python (.py) | `src/evaluate.py` |
| Modèle sauvegardé | Pickle (.pkl) | `models/trained_model.pkl` |
| Courbe de convergence | Image PNG | `notebooks/` ou `reports/` |
| Graphique prédictions vs réalité | Image PNG | `notebooks/` ou `reports/` |
| Notebook d'entraînement commenté | Jupyter (.ipynb) | `notebooks/exploration_and_training.ipynb` |

## 13. Indicateurs de succès / KPIs

| KPI | Cible | Commentaire |
|-----|-------|-------------|
| MSE (test set) | Le plus bas possible | Mesure l'erreur quadratique moyenne |
| RMSE (test set) | Le plus bas possible | Interprétable dans l'unité de la cible |
| R² (test set) | > 0 (idéalement > 0.1) | R² de 0.1 = le modèle explique 10% de la variance — honnête pour des rendements financiers |
| Convergence | Loss diminue sur ≥ 90% des itérations | Vérifie la stabilité de l'entraînement |
| Cohérence sklearn | Écart < 5% entre les métriques GD et sklearn | Valide l'implémentation |

> **Note :** Prédire les rendements boursiers est notoirement difficile. Un R² faible n'est pas un échec — c'est un résultat honnête. L'important pour le portfolio est de **démontrer la méthodologie et l'analyse critique**.

## 14. Questions à clarifier avant développement

- [ ] Quel learning rate initial utiliser ? (recommandé : tester 0.01, 0.001, 0.0001)
- [ ] Combien d'itérations maximum pour la descente de gradient ? (recommandé : 1000 à 10 000)
- [ ] Faut-il implémenter un early stopping basé sur la tolérance ? (recommandé : oui)
- [ ] Ratio du split train/test ? (recommandé : 80/20 chronologique)
- [ ] Faut-il implémenter un batch gradient descent, stochastic, ou mini-batch ? (recommandé : batch pour la simplicité du MVP)
- [ ] Faut-il ajouter une régularisation (L1/L2) ? (Could Have — pas nécessaire pour le MVP)

---

---

# Module 4 — Prediction API

## 1. Nom du module

**Prediction API (FastAPI)**

## 2. Objectif du module

Exposer le modèle entraîné via une API REST légère construite avec FastAPI, permettant de recevoir des indicateurs financiers en entrée et de retourner une prédiction de rendement futur.

## 3. Problème métier ou utilisateur résolu

Le modèle entraîné est enfermé dans un notebook ou un script Python. Pour qu'il soit **utilisable par des non-techniciens** (analystes, gestionnaires), il faut le rendre accessible via un point d'accès standardisé (API). Ce module transforme le modèle en **service consommable** par n'importe quelle application.

## 4. Utilisateurs concernés

| Persona | Interaction |
|---------|-------------|
| Analyste financier | Consomme l'API via l'interface web pour obtenir des prédictions |
| Gestionnaire de portefeuille | Utilise les prédictions pour orienter ses décisions |
| Data Scientist interne | Intègre l'API dans d'autres outils ou pipelines |
| Recruteur / Évaluateur | Évalue la capacité à déployer un modèle (compétence MLOps) |

## 5. Notre approche produit

- Utiliser **FastAPI** pour sa simplicité, sa documentation auto-générée (Swagger/OpenAPI) et ses performances
- Charger le modèle au démarrage de l'API (pas à chaque requête)
- Appliquer les mêmes transformations de normalisation que pendant l'entraînement
- Retourner non seulement la prédiction brute, mais aussi une **interprétation** (positif/négatif) et un **niveau de risque**
- Préparer le déploiement sur Render ou Railway

## 6. Fonctionnalités principales

| ID | Fonctionnalité | Description |
|----|----------------|-------------|
| F4.1 | Endpoint de prédiction (`POST /predict`) | Reçoit les features en JSON, retourne la prédiction |
| F4.2 | Validation des entrées | Validation automatique via Pydantic (types, ranges) |
| F4.3 | Chargement du modèle au démarrage | Le modèle est chargé en mémoire une seule fois |
| F4.4 | Normalisation des inputs | Application des mêmes paramètres de normalisation que l'entraînement |
| F4.5 | Interprétation du résultat | Ajout d'un message : "Hausse attendue" / "Baisse attendue" |
| F4.6 | Niveau de risque (optionnel) | Classification simple : Faible / Modéré / Élevé basée sur la magnitude |
| F4.7 | Endpoint de santé (`GET /health`) | Vérification que l'API est opérationnelle |
| F4.8 | Documentation auto-générée | Swagger UI accessible à `/docs` |
| F4.9 | CORS configuré | Permettre les requêtes cross-origin depuis le frontend |

## 7. User Stories

| ID | User Story | Priorité |
|----|------------|----------|
| US4.1 | **En tant que** analyste financier, **je veux** envoyer des indicateurs financiers à l'API **afin de** recevoir une prédiction de rendement futur | Must Have |
| US4.2 | **En tant que** développeur, **je veux** que les entrées soient validées automatiquement **afin de** éviter les erreurs de type ou de format | Must Have |
| US4.3 | **En tant que** analyste financier, **je veux** recevoir une interprétation en langage clair (hausse/baisse) **afin de** comprendre la prédiction sans expertise technique | Should Have |
| US4.4 | **En tant que** gestionnaire, **je veux** voir un niveau de risque associé **afin de** ajuster ma confiance dans la prédiction | Could Have |
| US4.5 | **En tant que** développeur front-end, **je veux** que l'API ait le CORS configuré **afin de** pouvoir faire des appels depuis le navigateur | Must Have |
| US4.6 | **En tant que** DevOps, **je veux** un endpoint `/health` **afin de** monitorer la disponibilité de l'API | Should Have |
| US4.7 | **En tant que** évaluateur, **je veux** accéder à la documentation Swagger **afin de** tester l'API sans code | Should Have |

## 8. Critères d'acceptation

| ID | Critère |
|----|---------|
| CA4.1 | L'endpoint `POST /predict` accepte un JSON avec les 7 features et retourne une prédiction |
| CA4.2 | L'API retourne une erreur 422 avec un message clair si les entrées sont invalides |
| CA4.3 | La prédiction retournée est cohérente avec celle obtenue dans le notebook pour les mêmes inputs |
| CA4.4 | Le CORS est configuré pour accepter les requêtes depuis `localhost` et le domaine du frontend déployé |
| CA4.5 | L'endpoint `GET /health` retourne un status 200 avec `{"status": "ok"}` |
| CA4.6 | La documentation Swagger est accessible à `/docs` et permet de tester l'endpoint |
| CA4.7 | Le temps de réponse pour une prédiction est < 200ms |
| CA4.8 | L'API démarre sans erreur avec `uvicorn api.main:app` |

## 9. Priorité

> **Must Have** — L'API est la couche qui rend le modèle utilisable dans un contexte réel et démontre les compétences MLOps.

## 10. Dépendances avec les autres modules

| Direction | Module | Nature de la dépendance |
|-----------|--------|------------------------|
| ⬅️ Dépend de | Module 3 (Training) | Nécessite le modèle sauvegardé (`trained_model.pkl`) |
| ⬅️ Dépend de | Module 2 (Feature Engineering) | Nécessite les paramètres de normalisation |
| ➡️ Fournit à | Module 5 (Frontend) | Le frontend consomme l'API pour afficher les prédictions |

## 11. Risques ou points d'attention

| Risque | Impact | Mitigation |
|--------|--------|------------|
| Modèle non trouvé au démarrage | Bloquant — l'API ne peut pas démarrer | Vérifier l'existence du fichier au démarrage, message d'erreur clair |
| Normalisation incohérente | Bug — prédictions absurdes | Charger les mêmes paramètres de normalisation que l'entraînement |
| CORS mal configuré | Bug — le frontend ne peut pas appeler l'API | Tester le CORS avec une requête depuis le navigateur |
| Déploiement gratuit instable (Render free tier) | UX — temps de démarrage long (cold start ~30s) | Documenter le cold start, utiliser un spinner côté front |

## 12. Livrables attendus

| Livrable | Format | Emplacement |
|----------|--------|-------------|
| Code de l'API | Python (.py) | `api/main.py` |
| Script de prédiction | Python (.py) | `src/predict.py` |
| Configuration CORS | Dans `api/main.py` | — |
| Documentation API (auto-générée) | Swagger UI | `/docs` |
| Instructions de déploiement | Section dans README | `README.md` |

## 13. Indicateurs de succès / KPIs

| KPI | Cible |
|-----|-------|
| Temps de réponse moyen | < 200ms |
| Taux de succès des requêtes valides | 100% |
| Validation Pydantic | Toutes les entrées invalides retournent un 422 |
| Documentation Swagger | Accessible et fonctionnelle |
| Déploiement | API accessible via une URL publique |

## 14. Questions à clarifier avant développement

- [ ] Format exact du JSON d'entrée ? (noms des champs, types attendus)
- [ ] L'API doit-elle accepter des prédictions pour plusieurs indices ou un seul ?
- [ ] Faut-il stocker un historique des prédictions (logging) ? (Could Have)
- [ ] Quel hébergement pour le MVP : Render free tier ou Railway ?
- [ ] Faut-il une authentification (API key) ? (non recommandé pour le MVP)

---

---

# Module 5 — Web Interface (Frontend)

## 1. Nom du module

**Web Interface (Frontend)**

## 2. Objectif du module

Créer une interface web simple, moderne et intuitive permettant aux utilisateurs de saisir des indicateurs financiers, d'envoyer une requête à l'API de prédiction et de visualiser le résultat de manière claire.

## 3. Problème métier ou utilisateur résolu

L'API seule n'est pas accessible aux utilisateurs non-techniques. Les analystes financiers ont besoin d'une **interface visuelle** pour interagir avec le modèle sans écrire de code ni utiliser Swagger. Ce module rend la solution **démontrable et utilisable** par n'importe qui.

## 4. Utilisateurs concernés

| Persona | Interaction |
|---------|-------------|
| Analyste financier | Saisit les indicateurs et consulte la prédiction |
| Gestionnaire de portefeuille | Teste différents scénarios et compare les résultats |
| Recruteur / Évaluateur | Interagit avec le projet déployé — c'est la **vitrine du portfolio** |

## 5. Notre approche produit

- Interface **single-page** minimaliste mais soignée (HTML/CSS/JS vanille)
- Design moderne avec un thème sombre adapté au domaine financier
- Formulaire clair avec labels explicatifs pour chaque indicateur
- Feedback visuel immédiat (spinner pendant le chargement, couleur verte/rouge selon la prédiction)
- Responsive design pour une consultation mobile
- Aucun framework lourd nécessaire — garder la simplicité pour le MVP

## 6. Fonctionnalités principales

| ID | Fonctionnalité | Description |
|----|----------------|-------------|
| F5.1 | Formulaire de saisie | Champs pour les 7 indicateurs financiers avec labels et placeholders |
| F5.2 | Validation côté client | Vérification que tous les champs sont remplis et numériques avant envoi |
| F5.3 | Appel à l'API | Requête `fetch` POST vers l'endpoint `/predict` |
| F5.4 | Affichage du résultat | Prédiction numérique + interprétation textuelle + indicateur visuel |
| F5.5 | Indicateur visuel hausse/baisse | Couleur verte pour hausse, rouge pour baisse, avec une icône ou une flèche |
| F5.6 | Spinner de chargement | Animation pendant l'attente de la réponse API |
| F5.7 | Gestion des erreurs | Affichage d'un message clair si l'API est indisponible ou retourne une erreur |
| F5.8 | Design responsive | Interface adaptée aux écrans desktop et mobile |
| F5.9 | Section "À propos" | Brève explication du projet et de la méthodologie |

## 7. User Stories

| ID | User Story | Priorité |
|----|------------|----------|
| US5.1 | **En tant que** analyste financier, **je veux** saisir les indicateurs financiers dans un formulaire **afin de** obtenir une prédiction sans écrire de code | Must Have |
| US5.2 | **En tant que** analyste financier, **je veux** voir la prédiction avec un indicateur visuel clair (vert/rouge) **afin de** comprendre immédiatement si le rendement est positif ou négatif | Must Have |
| US5.3 | **En tant que** utilisateur, **je veux** voir un spinner pendant le chargement **afin de** savoir que ma requête est en cours de traitement | Should Have |
| US5.4 | **En tant que** utilisateur, **je veux** recevoir un message d'erreur clair si l'API est indisponible **afin de** ne pas rester dans l'incertitude | Must Have |
| US5.5 | **En tant que** utilisateur mobile, **je veux** que l'interface soit utilisable sur mon téléphone **afin de** consulter les prédictions en déplacement | Should Have |
| US5.6 | **En tant que** recruteur, **je veux** voir une interface visuellement soignée **afin de** évaluer les compétences front-end du candidat | Must Have |
| US5.7 | **En tant que** utilisateur, **je veux** voir une section explicative sur le projet **afin de** comprendre la méthodologie derrière la prédiction | Could Have |

## 8. Critères d'acceptation

| ID | Critère |
|----|---------|
| CA5.1 | Le formulaire contient les 7 champs correspondant aux features du modèle |
| CA5.2 | Le formulaire empêche l'envoi si des champs sont vides ou non numériques |
| CA5.3 | Le clic sur "Prédire" envoie une requête POST à l'API et affiche le résultat |
| CA5.4 | Le résultat affiche : la valeur numérique de la prédiction, l'interprétation (hausse/baisse), et un indicateur visuel |
| CA5.5 | Un spinner s'affiche entre l'envoi et la réception de la réponse |
| CA5.6 | Si l'API retourne une erreur ou est indisponible, un message d'erreur lisible s'affiche |
| CA5.7 | L'interface est responsive (testée sur mobile et desktop) |
| CA5.8 | Le design est professionnel : typographie soignée, palette cohérente, pas de défaut visuel |
| CA5.9 | L'interface est déployée et accessible via une URL publique |

## 9. Priorité

> **Must Have** — C'est la **vitrine du portfolio**. C'est ce que le recruteur verra en premier.

## 10. Dépendances avec les autres modules

| Direction | Module | Nature de la dépendance |
|-----------|--------|------------------------|
| ⬅️ Dépend de | Module 4 (API) | Le frontend consomme l'API pour obtenir les prédictions |
| ⬅️ Dépend de (indirect) | Module 2 (Feature Engineering) | Les noms et descriptions des features doivent correspondre |

## 11. Risques ou points d'attention

| Risque | Impact | Mitigation |
|--------|--------|------------|
| API non déployée → frontend inutile | Bloquant — le formulaire ne retourne rien | Tester d'abord avec l'API en local, déployer l'API avant le front |
| Cold start Render (30s) | UX — l'utilisateur pense que ça ne marche pas | Afficher un message "Première requête peut prendre ~30s" + spinner |
| URL de l'API hardcodée | Maintenance — changer l'URL nécessite de redéployer | Utiliser une variable d'environnement ou un fichier de config |
| Design négligé | Impact portfolio — mauvaise première impression | Investir du temps dans le CSS, s'inspirer de dashboards financiers modernes |

## 12. Livrables attendus

| Livrable | Format | Emplacement |
|----------|--------|-------------|
| Page HTML | HTML | `frontend/index.html` |
| Styles CSS | CSS | `frontend/styles.css` |
| Logique JavaScript | JS | `frontend/script.js` |
| Favicon (optionnel) | ICO/PNG | `frontend/favicon.ico` |
| README déploiement frontend | Markdown | Section dans `README.md` |

## 13. Indicateurs de succès / KPIs

| KPI | Cible |
|-----|-------|
| Temps de chargement de la page | < 2 secondes |
| Compatibilité navigateurs | Chrome, Firefox, Safari |
| Score mobile-friendly | Responsive sur écrans ≥ 320px |
| Erreurs JavaScript console | 0 |
| Déploiement | Accessible via une URL publique (Vercel) |

## 14. Questions à clarifier avant développement

- [ ] Faut-il un sélecteur d'indice boursier ou le modèle est universel ?
- [ ] Les labels des champs doivent-ils être en français ou en anglais ?
- [ ] Faut-il des valeurs par défaut (pre-filled) dans le formulaire pour faciliter le test ?
- [ ] Faut-il ajouter un historique des prédictions côté client (localStorage) ? (Could Have)
- [ ] Quel nom de domaine / sous-domaine pour le déploiement ?

---

---

## 📊 Matrice de Priorisation Globale

| Module | Priorité | Justification |
|--------|----------|---------------|
| Module 1 — Data Ingestion & Preprocessing | 🔴 Must Have | Fondation de tout le pipeline |
| Module 2 — Feature Engineering | 🔴 Must Have | Input direct du modèle |
| Module 3 — Model Training & Optimization | 🔴 Must Have | Cœur technique du projet |
| Module 4 — Prediction API | 🔴 Must Have | Démontre les compétences MLOps |
| Module 5 — Web Interface | 🔴 Must Have | Vitrine du portfolio |

> Tous les modules sont **Must Have** pour un portfolio complet. L'ordre de développement suit la chaîne de dépendances : **1 → 2 → 3 → 4 → 5**.

---

## 🗓️ Roadmap MVP Suggérée (Développeur Solo)

| Sprint | Durée estimée | Module(s) | Objectif |
|--------|--------------|-----------|----------|
| Sprint 1 | 3-4 jours | Module 1 + Module 2 | Données propres + features prêtes |
| Sprint 2 | 4-5 jours | Module 3 | Modèle entraîné, évalué, sauvegardé |
| Sprint 3 | 2-3 jours | Module 4 | API fonctionnelle en local |
| Sprint 4 | 2-3 jours | Module 5 | Interface web + déploiement |
| Sprint 5 | 1-2 jours | Polish | Tests, documentation, README final |

**Durée totale estimée : 12 à 17 jours**

---

## 📐 Architecture Technique Globale

```
┌─────────────────────────────────────────────────────────────┐
│                     WEB INTERFACE                           │
│                  (HTML/CSS/JavaScript)                       │
│                   Déployé sur Vercel                         │
└──────────────────────────┬──────────────────────────────────┘
                           │ HTTP POST /predict
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                    PREDICTION API                           │
│                      (FastAPI)                              │
│                 Déployé sur Render                           │
│                                                             │
│  ┌─────────────┐  ┌──────────────┐  ┌──────────────────┐   │
│  │ Validation   │→│ Normalisation │→│ Prédiction        │   │
│  │ (Pydantic)   │  │ (scaler)     │  │ (weights·X + b)  │   │
│  └─────────────┘  └──────────────┘  └──────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                           ▲
              Chargement au démarrage
                           │
┌─────────────────────────────────────────────────────────────┐
│                    MODÈLE SAUVEGARDÉ                        │
│              trained_model.pkl + scaler_params.pkl          │
└─────────────────────────────────────────────────────────────┘
                           ▲
               Entraînement (offline)
                           │
┌─────────────────────────────────────────────────────────────┐
│              PIPELINE D'ENTRAÎNEMENT                        │
│                                                             │
│  ┌──────────┐  ┌──────────────┐  ┌─────────────────────┐   │
│  │ Module 1  │→│   Module 2    │→│     Module 3         │   │
│  │ Ingestion │  │   Features    │  │ Training + GD        │   │
│  └──────────┘  └──────────────┘  └─────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                           ▲
                           │
┌─────────────────────────────────────────────────────────────┐
│                    HUGGING FACE DATASET                     │
│    pettah/global-top-Index-exploring-trends-in-stock-Market │
└─────────────────────────────────────────────────────────────┘
```

---

## ✅ Definition of Done (Globale)

Un module est considéré comme **terminé** lorsque :

- [ ] Le code est fonctionnel et exécutable sans erreur
- [ ] Les critères d'acceptation sont tous validés
- [ ] Le code est commenté et documenté
- [ ] Le code est versionné sur GitHub
- [ ] Le README est mis à jour avec les instructions correspondantes
- [ ] Les livrables listés sont produits

Le projet est considéré comme **terminé** lorsque :

- [ ] Tous les 5 modules passent la Definition of Done
- [ ] L'API est déployée et accessible publiquement
- [ ] L'interface web est déployée et accessible publiquement
- [ ] Le README final est complet avec les instructions d'installation, d'utilisation et les résultats
- [ ] Le repository GitHub est propre (`.gitignore`, pas de fichiers inutiles, commits clairs)
