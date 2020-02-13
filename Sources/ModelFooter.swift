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
    
    public init(id: String) {
        self.differenceIdentifier = id
    }
    
    public func isContentEqual (to source: ModelFooter?) -> Bool {
        return self.differenceIdentifier == source?.differenceIdentifier
    }
    
    public func copy() -> ModelFooter {
        let object = ModelFooter(id: self.differenceIdentifier)
        return object
    }
}
