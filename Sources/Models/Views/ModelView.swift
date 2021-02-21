//
//  File.swift
//  
//
//  Created by Semen Kologrivov on 20.02.2021.
//

import Foundation

open class ModelView {

    public var differenceIdentifier: String!

    required public init(id: String) {
        self.differenceIdentifier = id
    }

    open func isContentEqual(to source: ModelView?) -> Bool {
        return self.differenceIdentifier == source?.differenceIdentifier
    }

    open func copy() -> ModelView {
        let object = type(of: self).init(id: self.differenceIdentifier)
        return object
    }
}
