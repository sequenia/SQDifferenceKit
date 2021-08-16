//
//  File.swift
//  
//
//  Created by Semen Kologrivov on 16.08.2021.
//

import UIKit
import DifferenceKit

// MARK: - Associated keys
private struct DiffListAssociatedKeys {

    static var dataInput: UInt8 = 0
    static var data: UInt8 = 1
    static var scrollsPositions: UInt8 = 2
}

// MARK: - Protocol
public protocol DiffListProtocol: AnyObject {

    var data: [Section] { get }

    func appendOrReplaceSection(_ section: Section)

    func cacheKey(forModel model: ModelRow, inSection section: Int) -> String

    func storeScrollPosition(forCell cell: CollectionCell?, atIndexPath indexPath: IndexPath)
    func storeScrollPosition(_ position: CGPoint, forKey key: String)
    func restoreScrollPosition(forCell cell: CollectionCell?, atIndexPath indexPath: IndexPath)

    func resetScrollPositions()
    func resetScrollPosition(forModel model: ModelRow, inSection section: Int)
}

// MARK: - Variables
public extension DiffListProtocol {

    internal var dataInput: [Section] {
        get {
            guard let value = objc_getAssociatedObject(self, &DiffListAssociatedKeys.dataInput) as? [Section] else { return [] }

            return value
        }
        set {
            objc_setAssociatedObject(self, &DiffListAssociatedKeys.dataInput, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    internal(set) var data: [Section] {
        get {
            guard let value = objc_getAssociatedObject(self, &DiffListAssociatedKeys.data) as? [Section] else { return [] }

            return value
        }
        set {
            objc_setAssociatedObject(self, &DiffListAssociatedKeys.data, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    private var scrollsPositions: [String: CGPoint] {
        get {
            guard let value = objc_getAssociatedObject(self, &DiffListAssociatedKeys.scrollsPositions) as? [String: CGPoint]  else { return [:] }

            return value
        }
        set {
            objc_setAssociatedObject(self, &DiffListAssociatedKeys.scrollsPositions, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

// MARK: - Work with sections
public extension DiffListProtocol {

    func appendOrReplaceSection(_ section: Section) {
        if let index = self.dataInput.firstIndex(where: { $0.differenceIdentifier == section.differenceIdentifier }) {
            self.dataInput[index] = section
            return
        }

        self.dataInput.append(section)
    }
}

// MARK: - Cache
public extension DiffListProtocol {

    func cacheKey(forModel model: ModelRow, inSection section: Int) -> String {
        return "\(section)-\(model.differenceIdentifier)"
    }

}

// MARK: - Scroll positions
public extension DiffListProtocol {

    func storeScrollPosition(forCell cell: CollectionCell?,
                             atIndexPath indexPath: IndexPath) {
        let model = self.data[indexPath.section].elements[indexPath.row]
        let key = self.cacheKey(forModel: model, inSection: indexPath.section)

        self.scrollsPositions[key] = cell?.scrollPosition ?? .zero
    }

    func storeScrollPosition(_ position: CGPoint, forKey key: String) {
        self.scrollsPositions[key] = position
    }

    func restoreScrollPosition(forCell cell: CollectionCell?,
                               atIndexPath indexPath: IndexPath) {
        let model = self.data[indexPath.section].elements[indexPath.row]
        let key = self.cacheKey(forModel: model, inSection: indexPath.section)

        if let offset = self.scrollsPositions[key] {
            cell?.scrollPosition = offset
        }
    }

    func resetScrollPositions() {
        self.scrollsPositions.removeAll()
    }

    func resetScrollPosition(forModel model: ModelRow, inSection section: Int) {
        let key = self.cacheKey(forModel: model, inSection: section)
        self.scrollsPositions.removeValue(forKey: key)
    }

}
