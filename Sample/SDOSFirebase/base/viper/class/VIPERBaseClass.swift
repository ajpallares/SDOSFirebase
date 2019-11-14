//
//  VIPERBaseClass.swift
//
//  Copyright © 2019 SDOS. All rights reserved.
//

import Foundation
import UIKit
import SDOSFirebase

@objc class VIPERBaseDataStore: NSObject {
    
}

@objc class VIPERBaseInteractor : NSObject {
    
}

@objc class VIPERBasePresenter : NSObject {
    
}

@objc class VIPERBaseViewController : UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SDOSFirebase.setScreenName(forInstance: self)
//        SDOSFirebase.setScreenName(firebaseScreenName(), forClass: type(of: self))
    }
}

@objc class VIPERBaseWireframe: NSObject {
    
}
