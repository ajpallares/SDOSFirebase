//
//  SDOSFirebase.swift
//
//  Copyright © 2019 SDOS. All rights reserved.
//

import Foundation
import FirebaseAnalytics
import FirebaseCore

public enum SDOSFirebaseConfigType: String {
    case plist
}

enum SDOSFirebaseScreenConfigType: String {
    case plist
}

public class SDOSFirebase {
    public static let screensPlistNameDefault = "FirebaseScreens"
    public static let fileConfigurationName = "GoogleService-Info"
    public static let fileConfigurationExtension = SDOSFirebaseConfigType.plist
    
    fileprivate static var configurationLoaded = false
    fileprivate static var screensPlistName = "FirebaseScreens" {
        didSet {
            guard let screensPlist = Bundle.main.path(forResource: screensPlistName, ofType: SDOSFirebaseScreenConfigType.plist.rawValue),
                let screensDictionary = NSDictionary(contentsOfFile: screensPlist)
                else {
                    print("[\(self)] - No se ha podido cargar el fichero de configuración de los nombres de pantallas de Firebase. Comprueba que el fichero \"\(screensPlistName).\(SDOSFirebaseScreenConfigType.plist.rawValue)\" existe")
                    return
            }
            self.screensDictionary = NSDictionary(contentsOfFile: screensPlist)
            print("[\(self)] - Fichero \"\(screensPlistName).\(SDOSFirebaseScreenConfigType.plist.rawValue)\" cargado correctamente")
        }
    }
    fileprivate static var screensDictionary: NSDictionary?
    
    
    /// Recupera la configuración para enviar a Firebase a partir del fichero de configuración indicado
    ///
    /// - Parameters:
    ///   - environment: Entorno de ejecución. Este String se usará para formar el nombre completo del fichero a cargar. El fichero a buscar será: fileName-environment.fileExtension (Ejemplo: GoogleService-Info-Debug.plist)
    ///   - fileName: Nombre del fichero de configuración sin la extensión. Default: GoogleService-Info
    ///   - fileExtension: Extensión del fichero de configuración. Default: plist
    ///   - bundle: Paquete donde se buscará el fichero de configuración: Default: Bundle.main
    ///   - screensPlist: Nombre del fichero que contiene la asociación de nombres de las pantallas que se setearan en firebase
    /// - Returns: Objeto options con la configuración del fichero. Devuelve nil si no se encuentra el fichero de configuración
    public static func options(environment: String, fileName: String = fileConfigurationName, fileExtension: SDOSFirebaseConfigType = fileConfigurationExtension, bundle: Bundle = Bundle.main, screensPlist: String = screensPlistNameDefault) -> FirebaseOptions? {
        self.screensPlistName = screensPlist
        let completeName = "\(fileName)-\(environment)"
        return options(fileName: completeName, fileExtension: fileExtension, bundle: bundle, screensPlist: screensPlist)
    }
    
    /// Recupera la configuración para enviar a Firebase a partir del fichero de configuración indicado
    ///
    /// - Parameters:
    ///   - fileName: Nombre del fichero de configuración sin la extensión. Default: GoogleService-Info
    ///   - fileExtension: Extensión del fichero de configuración. Default: plist
    ///   - bundle: Paquete donde se buscará el fichero de configuración: Default: Bundle.main
    ///   - screensPlist: Nombre del fichero que contiene la asociación de nombres de las pantallas que se setearan en firebase
    /// - Returns: Objeto options con la configuración del fichero. Devuelve nil si no se encuentra el fichero de configuración
    public static func options(fileName: String = fileConfigurationName, fileExtension: SDOSFirebaseConfigType = fileConfigurationExtension, bundle: Bundle = Bundle.main, screensPlist: String = screensPlistNameDefault) -> FirebaseOptions? {
        self.screensPlistName = screensPlist
        guard let firebasePlist = bundle.path(forResource: fileName, ofType: fileExtension.rawValue),
            let firebaseOptions = FirebaseOptions(contentsOfFile: firebasePlist)
            else {
                print("[\(self)] - No se ha podido recuperar la configuración de Firebase. Comprueba que el fichero \"\(fileName).\(fileExtension.rawValue)\" existe")
                return nil
        }
        print("[\(self)] - Cargada la configuración de Firebase del fichero \"\(fileName).\(fileExtension.rawValue)\"")
        return firebaseOptions
    }
    
    /// Lanza la configuración de Firebase. Este método sólo puede ser invocado una vez
    ///
    /// - Parameter options: Configuración a cargar en Firebase
    public static func configure(options: FirebaseOptions?) {
        guard let options = options else {
            print("[\(self)] - No se ha podido cargar la configuración de Firebase. FirebaseOptions es nil")
            return
        }
        guard !configurationLoaded else {
            fatalError("[\(self)] - No se puede volver a cargar la configuración de Firebase una vez que ya ha sido inicializada")
            return
        }
        FirebaseApp.configure(options: options)
        configurationLoaded = true
        print("[\(self)] - Configuración de Firebase realizada correctamente")
    }
    
    
    /// Setea el nombre de una pantalla para la clase indicada en Firebase
    ///
    /// - Parameters:
    ///   - name: Nombre de la pantalla a setear. Si viene nulo pondrá el nombre de la clase
    ///   - screenClass: Clase a la que setear el nombre
    public static func setScreenName(_ name: String?, forClass screenClass: AnyClass) {
        guard configurationLoaded else {
            return
        }
        
        var screenName = String(describing: screenClass)
        if let name = name {
            screenName = name
        } else if let screensDictionary = screensDictionary, let name = screensDictionary[String(describing: screenClass)] as? String {
            screenName = name
        }
        Analytics.setScreenName(screenName, screenClass: String(describing: screenClass))
    }
}

extension UIView {
    /// Setea el nombre de la vista en el framework de analíticas
    ///
    /// - Parameters:
    ///   - name: Nombre de la pantalla. Si es nulo lo buscará en el fichero plist a partir de la clase
    @objc open func setFirebaseScreenName(name: String? = nil) {
        SDOSFirebase.setScreenName(name, forClass: type(of: self))
    }
    
    /// Nombre de la pantalla para marcar en Firebase. Si devuelve nil seteara el nombre en el .plist si existe o el nombre del controlador si no existe.
    ///
    /// - Returns: Nombre para marcar en Firebase
    @objc open func firebaseScreenName() -> String? {
        return nil
    }
}

extension UIViewController {
    /// Setea el nombre de la vista en el framework de analíticas. Normalmente se llamará en el método viewDidAppear(animated: Bool)
    ///
    /// - Parameters:
    ///   - name: Nombre de la pantalla. Si es nulo lo buscará en el fichero plist a partir de la clase
    @objc open func setFirebaseScreenName(name: String? = nil) {
        SDOSFirebase.setScreenName(name, forClass: type(of: self))
    }
    
    /// Nombre de la pantalla para marcar en Firebase. Si devuelve nil seteara el nombre en el .plist si existe o el nombre del controlador si no existe
    ///
    /// - Returns: Nombre para marcar en Firebase
    @objc open func firebaseScreenName() -> String? {
        return nil
    }
}
