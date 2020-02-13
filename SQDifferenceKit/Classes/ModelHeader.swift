//
//  ModelHeader.swift
//  SQDifferenceKit
//
//  Created by Ivan Mikhailovskii on 13/02/2020.
//  Copyright © 2020 Ivan Mikhailovskii. All rights reserved.
//

import Foundation

public class ModelHeader {
    
    public var differenceIdentifier: String!
    
    public init(id: String) {
        self.differenceIdentifier = id
    }
    
    public func isContentEqual (to source: ModelHeader?) -> Bool {
        return self.differenceIdentifier == source?.differenceIdentifier
    }
    
    public func copy() -> ModelHeader {
        let object = ModelHeader(id: self.differenceIdentifier)
        return object
    }
}
