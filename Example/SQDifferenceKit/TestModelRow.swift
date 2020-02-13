//
//  TestModelRow.swift
//  SQDifferenceKit_Example
//
//  Created by Ivan Mikhailovskii on 13/02/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import SQDifferenceKit

class TestModelRow: ModelRow {
    
    var text: String?
    
    init(id: String, text: String?) {
        super.init()
        
        self.text = text
        self.differenceIdentifier = id
    }
    
    override func isContentEqual(to source: ModelRow) -> Bool {
        guard let source = source as? TestModelRow else { return true }
        
        return self.text == source.text
    }
    
    override func copy() -> ModelRow {
        let object = TestModelRow(id: self.differenceIdentifier, text: self.text)
        
        return object
    }
    
}
