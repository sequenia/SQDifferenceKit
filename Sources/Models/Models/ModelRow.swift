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
    public private(set) var showSkeleton = false
    public private(set) var showSeparator = true
    
    required public init(
        id: String,
        showSkeleton: Bool = false,
        showSeparator: Bool = true
    ) {
        self.differenceIdentifier = id
        self.showSkeleton = showSkeleton
        self.showSeparator = showSeparator
    }
    
    open func isContentEqual(to source: ModelRow) -> Bool {
        return self.differenceIdentifier == source.differenceIdentifier &&
            self.showSkeleton == source.showSkeleton &&
            self.showSeparator == source.showSeparator
    }
    
    open func copy() -> ModelRow {
        return type(of: self).init(
            id: self.differenceIdentifier,
            showSkeleton: self.showSkeleton,
            showSeparator: self.showSeparator
        )
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
