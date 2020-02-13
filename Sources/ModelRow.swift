//
//  ModelRow.swift
//  SQDifferenceKit
//
//  Created by Ivan Mikhailovskii on 13/02/2020.
//  Copyright © 2020 Ivan Mikhailovskii. All rights reserved.
//

import Foundation
import DifferenceKit

open class ModelRow: Differentiable {

    public typealias DifferenceIdentifier = String
    public var differenceIdentifier: String = UUID().uuidString
    
    public init() {}
    
    open func isContentEqual(to source: ModelRow) -> Bool {
        return self.differenceIdentifier == source.differenceIdentifier
    }
    
    open func copy() -> ModelRow {
        let object = ModelRow()
        object.differenceIdentifier = self.differenceIdentifier
        
        return object
    }
    
}
