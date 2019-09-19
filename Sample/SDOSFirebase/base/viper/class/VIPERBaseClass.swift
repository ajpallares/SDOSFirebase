//
//  VIPERBaseClass.swift
//
//  Copyright © 2019 SDOS. All rights reserved.
//

import Foundation
import UIKit

@objc class VIPERBaseDataStore: NSObject {
    
}

@objc class VIPERBaseInteractor : NSObject {
    
}

@objc class VIPERBasePresenter : NSObject {
    
}

@objc class VIPERBaseViewController : UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setFirebaseScreenName(name: firebaseScreenName())
    }
}

@objc class VIPERBaseWireframe: NSObject {
    
}
