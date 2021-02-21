//
//  ModelRow.swift
//  SQDifferenceKit
//
//  Created by Ivan Mikhailovskii on 13/02/2020.
//  Copyright © 2020 Ivan Mikhailovskii. All rights reserved.
//

import Foundation
import DifferenceKit

public class ModelRow: Differentiable {

    public typealias DifferenceIdentifier = String
    public var differenceIdentifier: String
    
    public required init(id: String) {
        self.differenceIdentifier = id
    }
    
    public func isContentEqual(to source: ModelRow) -> Bool {
        return self.differenceIdentifier == source.differenceIdentifier
    }
    
    public func copy() -> ModelRow {
        return type(of: self).init(id: self.differenceIdentifier)
    }
}

extension ModelRow: Equatable {
    
    public static func == (lhs: ModelRow, rhs: ModelRow) -> Bool {
        lhs.isContentEqual(to: rhs)
    }

}
