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
    public var differenceIdentifier: String
    
    required public init(id: String) {
        self.differenceIdentifier = id
    }
    
    open func isContentEqual(to source: ModelRow) -> Bool {
        return self.differenceIdentifier == source.differenceIdentifier
    }
    
    open func copy() -> ModelRow {
        return type(of: self).init(id: self.differenceIdentifier)
    }
}

extension ModelRow: Equatable {

    public static func == (lhs: ModelRow, rhs: ModelRow) -> Bool {
        lhs.isContentEqual(to: rhs)
    }
    
}
