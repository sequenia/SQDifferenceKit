//
//  ModelFooter.swift
//  SQDifferenceKit
//
//  Created by Ivan Mikhailovskii on 13/02/2020.
//  Copyright © 2020 Ivan Mikhailovskii. All rights reserved.
//

import Foundation

public class ModelFooter {
    
    public var differenceIdentifier: String!
    
    public required init(id: String) {
        self.differenceIdentifier = id
    }
    
    open func isContentEqual (to source: ModelFooter?) -> Bool {
        return self.differenceIdentifier == source?.differenceIdentifier
    }
    
    open func copy() -> ModelFooter {
        let object = type(of: self).init(id: self.differenceIdentifier)
        return object
    }
}
