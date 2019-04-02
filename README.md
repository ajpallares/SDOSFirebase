- [SDOSFirebase](#sdosfirebase)
  - [Introducción](#introducci%C3%B3n)
  - [Instalación](#instalaci%C3%B3n)
    - [Cocoapods](#cocoapods)
  - [Cómo se usa](#c%C3%B3mo-se-usa)
    - [Configuración del proyecto](#configuraci%C3%B3n-del-proyecto)
    - [Implementación](#implementaci%C3%B3n)
      - [Configuración inicial](#configuraci%C3%B3n-inicial)
      - [Uso](#uso)
    - [Otros ejemplos de configuración](#otros-ejemplos-de-configuraci%C3%B3n)
  - [Dependencias](#dependencias)
  - [Referencias](#referencias)

# SDOSFirebase

- Enlace confluence: https://kc.sdos.es/x/jAPLAQ

## Introducción

SDOSFirebase implementa las funcionalidades necesarias para el marcado de pantallas en la plataforma Firebase. La librería se encarga de recuperar la configuración del fichero .plist que proporciona Google y posteriormente la aplica. Está configuración se puede modificar y no es obligatoria hacerla con la librería, pero **sí es obligatorio aplicar la configuración de Firebase con está librería**. Si no se aplica la configuración con la librería, ésta no funcionará.

La librería se encarga de leer un fichero .plist con la asociación de los ViewControllers y el nombre que deben tener en Firebase y los aplica al llamarase al método viewDidAppear. Está implementación se realiza en un controlador base del que deberán heredar todas las pantallas.

## Instalación

### Cocoapods

Usaremos [CocoaPods](https://cocoapods.org). Hay que añadir la dependencia al `Podfile`:

```ruby
pod 'SDOSFirebase', '~>1.0.0' 
```

## Cómo se usa

### Configuración del proyecto

La librería está planteada para usarse conjuntamente con los entornos configurados para SDOSEnvironment. Google proporciona un fichero .plist con la configuración de la aplicación de Firebase correspondiente y por lo general, una aplicación tendrá configuraciones diferentes dependiendo del entorno. Para aplicar una correcta configuración hay que realizar los siguientes pasos:

- Descargar el fichero GoogleService-Info.plist desde Firebase y renombrarlo a GoogleService-Info-<*Entorno*>.plist (Ejemplo: GoogleService-Info-Debug.plist)
- Hacer el paso anterior para todos los entornos disponibles
- Añadir un fichero .plist llamado *FirebaseScreens.plist*. Este fichero contedrá los nombres de pantallas a poner en Firebase para cada ViewController. Ejemplo:
    ```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>DocumentationViewController</key>
        <string>Documentation</string>
    </dict>
    </plist>
    ```

*Estos nombres pueden variar y habrá que realizar la configuración correcta durante la implementación

### Implementación

#### Configuración inicial

La librería requiere que se lance la configuración inicial durante la carga de la aplicación (preferiblemente en el método *application(application:didFinishLaunchingWithOptions:)*). Está configuración se realiza con la siguiente implementación:

1. Cargar el fichero de configuración de Firebase con la siguiente llamada
    ```js
    //If environment is "Debug" load config file from GoogleService-Info-Debug.plist
    var options = SDOSFirebase.options(environment: SDOSEnvironment.environmentKey)
    ```
2. Aplicar la configuración
    ```js
    SDOSFirebase.configure(options: options)
    ```
La configuración de Firebase se puede cargar de otra forma o recibir modificaciones una vez cargada. Está implementación es válida si se configuran los ficheros por entornos.

#### Uso

Para realizar el marcaje de las pantallas hay que implementar el siguiente código durante la presentación de la vista:
```js
setFirebaseScreenName(name: firebaseScreenName())
```

Un ejemplo sería llamar al método en el viewDidAppear:
```js
override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setFirebaseScreenName(name: firebaseScreenName())
}
```

En algunos casos la pantalla puede tomar diferentes valores para el marcaje en Firebase dependiendo de varios factores que no puede ser configurados en el fichero *FirebaseScreens.plist*. Para estos casos se puede sobrescribir el método `firebaseScreenName() -> String?` disponible en las clases `UIViewController` y `UIView` para indicar el nombre que se debe marcar en Firebase:
```js
override func firebaseScreenName() -> String? {
    return "TestView"
}
```

En el caso que el nombre no exista en el fichero *FirebaseScreens.plist* y no sobrescriba el método `firebaseScreenName() -> String?`, la pantalla se marcará con el nombre del propio controlador

### Otros ejemplos de configuración

- Cargar la configuración de Firebase del fichero *GoogleService-Info.plist* (2 opciones válidas)
    
    Opción 1:
    ```js
    var options = SDOSFirebase.options()
    ```
    Opción 2:
    ```js
    var options = SDOSFirebase.options(filename: "GoogleService-Info")
    ```
- Cargar la configuración de Firebase del fichero *GoogleService-Info-Development.plist*
    ```js
    var options = SDOSFirebase.options(environment: "Development")
    ```
- Cargar la configuración de Firebase del fichero *Configuration.plist* y la asociación de pantallas del fichero *Screens.plist*
    ```js
    SDOSFirebase.options(fileName: "Configuration", screensPlist: "Screens")
    ```
- Cargar la configuración de Firebase del fichero *Configuration-Development.plist* y la asociación de pantallas del fichero *Screens.plist*
    ```js
    SDOSFirebase.options(environment: "Development", fileName: "Configuration", screensPlist: "Screens")
    ```

## Dependencias
* [Firebase/Core](https://cocoapods.org/pods/Firebase) - 5.x

## Referencias
* https://svrgitpub.sdos.es/iOS/SDOSFirebase
