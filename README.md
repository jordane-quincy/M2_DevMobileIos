# M2_DevMobileIos

## Pré-requis :
* Swift 3

## Adresses pour compte ios :
* jordanequincy@gmail.com
* duriez.jeanbaptiste@gmail.com
* morggandu59@live.fr
* jordan.canonne@icloud.com
* samir.moutawakil59@gmail.com
* maximegrassart@gmail.com

## Formation de 45min :

### Intro :
* Historique et évolutions de Swift (diff swift 1/2/3)
* Sources : Différences entre Objective-C et Swift : http://codewithchris.developpez.com/tutoriels/swift/debuter/apprendre-swift-a-partir-objective-c/devriez-vous-continuer-apprendre-objective-c/#LIV


### Main parties :
* Expliquer structure d'une appli (comment ça marche en terme de scène etc, cycle de vie des scnènes..., services en background)
* Installation IDE, Présentation IDE (Outil graphique pour les vues, pas de manifest => ihm depuis xcode)
* Partie swift : 
  * Demo : Création hello world de A à Z, montrer certaines structures, montrer comment fonctionne les formulaires, montrer potentiellement utilisation des trucs natifs (passer d'une scène à une autre, appareil photo, giroscope, accelerometre...), montrer le cycle de vie (genre afficher un truc à chaque début de cycle), notification push
  * Partie service (service apple ( de pub, de notif...))
  
### Seconde main parties :
* Enregistrement des données
* Vers la fin, montrer comment mettre un application sur le store


Cycle de vie Ios : https://developer.apple.com/library/content/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/TheAppLifeCycle/TheAppLifeCycle.html#//apple_ref/doc/uid/TP40007072-CH2-SW3

Parsing Json :
https://developer.apple.com/swift/blog/?id=37


### Informations système
http://stackoverflow.com/questions/33855998/how-to-get-hardware-details-in-swift

https://github.com/beltex/SystemKit/pull/24/commits/60dcaf3683bcc9ba472d318e9560a7f5203b3e60?diff=split


Pour image base 64

let dataDecoded : Data = Data(base64Encoded: strBase64, options: .ignoreUnknownCharacters)!  
let decodedimage = UIImage(data: dataDecoded)  
yourImageView.image = decodedimage  
