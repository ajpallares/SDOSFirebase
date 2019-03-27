//
//  VIPERBaseClass.swift
//
//  Copyright © 2019 SDOS. All rights reserved.
//

import Foundation
import SDOSVIPER

@objc class VIPERBaseDataStore: VIPERGenericObject {
    
}

@objc class VIPERBaseInteractor : VIPERGenericObject {
    
}

@objc class VIPERBasePresenter : VIPERGenericObject {
    
}

@objc class VIPERBaseViewController : VIPERGenericViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setFirebaseScreenName(name: firebaseScreenName())
    }
}

@objc class VIPERBaseWireframe: VIPERGenericObject {
    
}
