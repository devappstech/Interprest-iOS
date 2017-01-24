
[![](http://interprest.io/wp-content/uploads/2016/05/interprest-slide03.jpg)](http://interprest.io/wp-content/uploads/2016/05/interprest-slide03.jpg)

Interprest es un sistema de interpretación simultánea, portátil y de código abierto. Se vale de la tecnología inalámbrica empleando un sistema de comunicación basado en móviles. De esta forma, el móvil del intérprete (emisor) envía la señal a través de un pequeño micrófono y el oyente (receptor) lo recibe en su móvil. El proyecto es una apuesta a favor de la tecnología libre, y pone a disposición de la comunidad todo su desarrollo.

###Compile Requirements

 - ARC
 - XCode 7.x & iOS SDK 9.x

###Requerimientos

 - Arquitecturas soportadas: ARMv7, ARMv7s, ARM64 and x86-64
 - iOS version: Deploy target iOS 8.0 or later

###Librerías fundamentales

 Interprest está basado en el proyecto ffmpeg y en su herramienta ffplay para la reproducción de sonido. Para conocer más sobre este proyecto accede a [http://ffmpeg.org/](http://ffmpeg.org/).

Además para poder utilizar el proyecto ffmpeg desde una app iOS utilizamos las librerías creadas por el proyecto  [https://github.com/Bilibili/ijkplayer](https://github.com/Bilibili/ijkplayer).

La compilación del proyecto ffmeg para iOS se ha realizado siguiente las instrucciones de este proyecto. Además los parámetros de configuración que se han utilizado para la compilación están en el fichero: /interprest-ios/ijkplayer-ios/config/module-interprest.sh


Para conocer los detalles completos sobre las licencias de estas librerías deben acceder a cada uno de los proyectos.

###Librerías adicionales

Además se han utilizado un conjunto de librerías adicionales todas ellas open source para realizar la programación de esta App. A continuación el listado de estas librerías:

 - [XLPagerTabStrip ~> 3.0](https://github.com/xmartlabs/XLPagerTabStrip) 
 - [RestKit ~> 0.25.0](https://github.com/RestKit/RestKit)
 - [FSImageViewer ~> 1.2.0](https://github.com/x2on/FSImageViewer)
 - [SDWebImage ~> 3.7](https://github.com/rs/SDWebImage)
 - [MBProgressHUD ~> 0.9.2](https://github.com/jdg/MBProgressHUD)
 - [InAppSettingsKit ~> 2.6.3](https://github.com/jdg/MBProgressHUD)

###Contacto

 - Web: http://interprest.io
