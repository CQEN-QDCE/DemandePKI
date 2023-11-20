#!/bin/bash
#
# ************************************************************
# *** Autorité de Certification CQEN Exp V1                ***
# ************************************************************
# Outil de demande et reception de certificat numérique de l'AC Intermediaire CQEN.  
# Auteur: Julio Cesar Torres (@torjc01)
# Date  : 2003-11-14
#
#
set -e

# Bienvenu à l'outil de demande d'un nouveau certificat 

OPENSSL_EXEC=openssl


# =================================
# ===== Fonctions utilitaires ===== 
# =================================

function echoRed (){
  _msg=${1}
  _red='\e[31m'
  _nc='\e[0m' # No Color
  echo -e "${_red}${_msg}${_nc}"
}

function echoYellow (){
  _msg=${1}
  _yellow='\e[33m'
  _nc='\e[0m' # No Color
  echo -e "${_yellow}${_msg}${_nc}"
}

function isInstalled () {
  rtnVal=$(type "$1" >/dev/null 2>&1)
  rtnCd=$?
  if [ ${rtnCd} -ne 0 ]; then
    return 1
  else
    return 0
  fi
}

function isOpensslInstalle () {

  if ! isInstalled ${OPENSSL_EXEC}; then
    echoError "L'exécutable ${OPENSSL_EXEC} est requis mais il n'est pas dans votre path." 
    echoError "Suivez les instructions d'installation à partir de: https://www.ibm.com/docs/en/ts4500-tape-library?topic=openssl-installing"
    echoError "Assurez-vous d'extraire le binaire dans un répertoire dans votre path."
    exit 1
  fi
}

# Change les letres majuscules en lettres minuscules
function toLower(){
    echo $(echo ${@} | tr '[:upper:]' '[:lower:]')
}

# Change les lettres minuscules en majuscules
function toUpper(){
    echo $(echo ${@} | tr '[:lower:]' '[:upper:]')
}

# =================================
# ===== Fonctions principales =====
# =================================

demander(){
  # Vérifie si openssl est installé
  isOpensslInstalle
  
  echoYellow "Bienvenu à l'outil de demande d'un nouveau certificat (CSR)"
  echo " " 

  echoYellow "Saisissez les informations demandés ci-dessous, pour générer la CSR"
  echoYellow ""
  
  # Nom de l'usager détenteur du certificat 
  read -e -i "$nom" -p "Prénom et nom complèt: " INPUT 
  NOM="${INPUT:-nom}"

  # Courriel du détenteur du certificat 
  read -e -i "$email" -p "Email: " INPUT 
  EMAIL="${INPUT:-email}"


  # ==== Validation des informations fournies 
  echo ""
  echo "Voici les données saisies. Vérifiez si elles sont exactes: "
  
  echo "Nom complèt : " $NOM 
  echo "Courriel    : " $EMAIL
  
  echo ""
  echo "Tous les données sont correctes? (O/N)"
  read CONFIRMATION 
  echo ""

  case $CONFIRMATION in 

      O | o)
          echo "Données confirmées."

          openssl req -new -config usager.cnf -out $PARM.csr -keyout $PARM.key -utf8 \
          -subj "/C=CA/ST=Quebec/L=Quebec City/O=Centre Quebecois d'Excellence Numerique/OU=Autorite de Certification Intermediaire CQEN Exp V1/CN=$(toUpper ${NOM})" \
          -addext "subjectAltName=email:move;email:${EMAIL}"
          # /emailAddress=${EMAIL}
          ;;
      N | n)
          echo ${RED}"******************************************"
          echo "ERREUR: Données non confirmées."
          echo "Le script va quitter avec code d'erreur 1"
          echo "Merci de redémarrer le script"
          echo "******************************************"${RESET}
          exit 1
          ;;
      *)
          ${RED}"******************************************"
          echo "ERREUR: Option invalide."
          echo "Le script va quitter avec code d'erreur 2"
          echo "Merci de redémarrer le script"
          "******************************************"${RESET}
          exit 2
          ;;
  esac
      
  echo " " 
  echoYellow "Le fichier ««${PARM}.csr»» est généré dans ce répertoire. Merci de le transmettre via courriel au responsable de l'Autorité de Certification."
  echo " "
  echoRed "[[ATTENTION]] Le fichier ««${PARM}.key»» présent dans ce repertoire est votre clé privée. Veuillez la protéger de tout accès non autorisé. " 
  
  # openssl req -new -config usager.cnf -out $PARM.csr -keyout $PARM.key -utf8
  # -subj "/C=CA/ST=Québec/L=Québec City/O=Centre Quebecois d'Excellence Numerique/OU=Autorite de Certification Intermediaire CQEN Exp V1/CN=$(NOM)" \

}

recevoir(){
  # Vérifie si openssl est installé
  isOpensslInstalle

  echoYellow ""
  echoYellow "Assurez-vous que les objets reçus de l'AC et la clé privé générée lors de la demande sont placés dans ce repertoire."
  echoYellow "Veuillez suivre les commandes à l'écran"
  echo " "  
  echoYellow "Génération du fichier PKCS#12 en cours: "

  # Gera arquivo PKCS12 do usuario 
    openssl pkcs12 -export -name $PARM -inkey $PARM.key -in $PARM.crt -out $PARM.p12

  echoYellow "Le fichier ««${PARM}.p12»» a été créé et placé dans ce repertoire."
}


usage() {
  cat <<-EOF


      Usage: $0 [command] [parms]
    
      commands: 

          demande <alias>
              Créér une CSR pour la demande d'un nouvel certificat. Informez un nom court d'alias 
              pour nommer le fichier résultant.  
          
          recevoir <alias> 
              Genèrer un numéro de série et emet le certificat.

          usage 
              Affiche cette page d'aide. 

      parms:
      
          alias - nom de reference que sera utilisé pour la genération de la CSR et sera utilisé pour nommer 
                  les objets cryptographiques qui seront générés (csr, keys, crt, etc).  

EOF
  exit 1
}


# ------------------------------------------
# Évaluation et exécution des commandes
# ------------------------------------------
COMMAND=$(toLower ${1})

# Valide la commande
if [ -z "${COMMAND}" ]; then
    COMMAND="help"
fi

# Valide le parm et évalue la commande complète
PARM=${2}

if [ -z $PARM ]
then
    usage
else 
    case "$COMMAND" in 
      demander)
        demander
        ;;
      recevoir)
        recevoir
        ;;
      *) 
        usage
        ;;
    esac
fi

# =============================================================================
#      Fin du script
# =============================================================================
