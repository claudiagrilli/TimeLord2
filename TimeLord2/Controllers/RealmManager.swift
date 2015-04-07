//
//  RealmManager.swift
//  TimeLord2
//
//  Created by Claudia Grilli on 28/01/15.
//  Copyright (c) 2015 Claudia Grilli. All rights reserved.
//

import Foundation
import Realm

class RealmManager {
    class func addObject(object:RLMObject, realm:RLMRealm=RLMRealm.defaultRealm()){
        realm.beginWriteTransaction()
        realm.addObject(object)
        realm.commitWriteTransaction()
    }
    
    class func updateObject(updateBlock : ()->(Void),realm:RLMRealm=RLMRealm.defaultRealm()){
        realm.transactionWithBlock(updateBlock)
    }
}