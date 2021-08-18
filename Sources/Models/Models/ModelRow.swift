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

    public private(set) var differenceIdentifier: String
    public var showSkeleton = false
    public var showSeparator = true
    
    required public init(id: String) {
        self.differenceIdentifier = id
    }
    
    open func isContentEqual(to source: ModelRow) -> Bool {
        return self.differenceIdentifier == source.differenceIdentifier &&
            self.showSkeleton == source.showSkeleton &&
            self.showSeparator == source.showSeparator
    }
    
    open func copy() -> ModelRow {
        let copy =  type(of: self).init(
            id: self.differenceIdentifier,
        )
        copy.showSeparator = self.showSeparator
        copy.showSkeleton = self.showSkeleton
        return copy
    }

    open func copyWithPrefix(prefix: String) -> ModelRow {
        let copy = self.copy()
        copy.differenceIdentifier = "\(prefix)_\(copy.differenceIdentifier)"
        return copy

    }

    public func setDifferenceId(_ id: String) {
        self.differenceIdentifier = id
    }

}

extension ModelRow: Equatable {

    public static func == (lhs: ModelRow, rhs: ModelRow) -> Bool {
        lhs.isContentEqual(to: rhs)
    }
    
}
