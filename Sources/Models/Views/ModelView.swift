//
//  File.swift
//  
//
//  Created by Semen Kologrivov on 20.02.2021.
//

import Foundation

public class ModelView {

    public var differenceIdentifier: String!

    public required init(id: String) {
        self.differenceIdentifier = id
    }

    public func isContentEqual(to source: ModelView?) -> Bool {
        return self.differenceIdentifier == source?.differenceIdentifier
    }

    public func copy() -> Self {
        let object = type(of: self).init(id: self.differenceIdentifier)
        return object
    }
}
