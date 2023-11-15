# Demande de certificat à la PKI d'Expérimentation CQEN

Cette application de ligne de commande sert à faire la création de la demande de génération 
de certificat et ensuite la reception et création d'un fichier PKCS#12 pour son utilisation. 

Clonez ce projet dans votre ordinateur, et ensuite rentrez dans le répertoire de l'application: 

```
git clone https://github.com/CQEN-QDCE/DemandePKI.git
cd DemandePKI
```

## Demander la génération 

Un certificat est émis par l'autorité de certification par moyen d'un fichier appelé `Certificate Signing Request (CSR)`. 

Lors de la création d'une CSR, le paire de clés qui sera utilisé par le certificat est aussi généré. Tandis que la clé 
public est incluse dans la CSR pour être signé et incluse dans le certificat lors de l'émission du certificat numérique,
la clé privée est placée dans un fichier à part dans le répertoire de l'application. Elle n'est pas transmise à l'autorité
de certification et ne doit jamais être publiée ou sortir de votre contrôle. 

Pour générer la CSR, exécutez la commande ci-dessous, en remplaçant `<alias>` par n'importe quel mot court qui servira de 
référence pour la génération des objets cryptographiques: 

```
./cert demander <alias>
```

Ensuite, suivez les instructions de l'application, qui vous demandera votre `nom` et votre `courriel` pour inclure dans la CSR.  

En admettant qu'on exécute la commande avec l'alias `moncert`, la commande donnera le résultat suivant: 

```
./cert.sh demander moncert
Bienvenu à l'outil de demande d'un nouveau certificat (CSR)
 
Saisissez les informations demandés ci-dessous, pour générer la CSR

Prénom et nom complèt: Jean Tremblay
Email: jean.tremblay@quebec.ca

Voici les données saisies. Vérifiez si elles sont exactes: 
Nom complèt :  Jean Tremblay
Courriel    :  jean.tremblay@quebec.ca

Tous les données sont correctes? (O/N)
O

```
Si les informations saisiez sont correctes, confirmez avec `O`, sinon répondez `N` et récommencez la procédure. 

```
Données confirmées.
..+.+.........+...+.....+.............+...+..+...+.+......+..+................+.........+..+.+..+...+.........+.+...+.........+..+..........+.....+......+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*.......+.....+.+..+....+...+......+.....+.+..............+.+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*......+............+........+............+...+...+..........+......+...+......+...........+....+...........+.+.....+.............+.........+...+.........+..............+............+...+.+..............+...............+......+................+........................+........+.+..+.......+...+...+.....+..........+.....+.......+...+..+...................+..................+...............+...+..+..........+..+...+....+.........+.....+....+...+...............+..+.....................+......+.+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
```

La génération randomique du paire de clés est faite, et ensuite on vous demande de rentrer et confirmer un mot de passe. Ceci est le mot qui protège votre clé privée. Gardez-le soigneusement. 

```
Enter PEM pass phrase:
Verifying - Enter PEM pass phrase:
-----

Le fichier ««moncert.csr»» est généré dans ce répertoire. Merci de le transmettre via courriel au responsable de l'Autorité de Certification.
[[ATTENTION]] Le fichier ««moncert.key»» présent dans ce repertoire est votre clé privée. Veuillez la protéger de tout accès non autorisé. 

```

Finalement, dans le répertoire, vous aurez deux fichiers résultants de la demande: 

- `moncert.csr` qui doit être transmis à l'AC pour faire l'émission de votre certificat; 
- `moncert.key` qui est votre clé privée. Ce fichier est accedé avec le mot de passe que vous avez créé, et doit être protegé soigneusement - il est la garantie de l'inviolabilité de votre certificat. 


