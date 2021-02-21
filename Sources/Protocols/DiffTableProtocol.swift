//
//  File.swift
//  
//
//  Created by Semen Kologrivov on 20.02.2021.
//

import UIKit
import DifferenceKit

// MARK: - Associated keys
private struct DiffTableAssociatedKeys {

    static var dataInput: UInt8 = 0
    static var data: UInt8 = 1
    static var horizontalScrollsPositions: UInt8 = 2
    static var cellHeights: UInt8 = 3
}

// MARK: - Protocol
public protocol DiffTableProtocol: class {

    var data: [Section] { get }
    var tableView: UITableView! { get }

    func appendOrReplaceSection(_ section: Section)
    func reloadAnimated()
    func reloadAnimated(_ animated: UITableView.RowAnimation)

    func cacheKey(forModel model: ModelRow, inSection section: Int) -> String

    func storeHeight(forCell cell: UITableViewCell, atIndexPath indexPath: IndexPath)
    func height(forCellAtIndexPath indexPath: IndexPath) -> CGFloat

    func storeScrollPosition(forCell cell: UITableViewCell, atIndexPath indexPath: IndexPath)
    func storeScrollPosition(_ position: CGPoint, forKey key: String)
    func restoreScrollPosition(forCell cell: UITableViewCell, atIndexPath indexPath: IndexPath)
    func resetScrollPositions()
}

// MARK: - Variables
public extension DiffTableProtocol {

    private var dataInput: [Section] {
        get {
            guard let value = objc_getAssociatedObject(self, &DiffTableAssociatedKeys.dataInput) as? [Section] else { return [] }

            return value
        }
        set {
            objc_setAssociatedObject(self, &DiffTableAssociatedKeys.dataInput, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    private(set) var data: [Section] {
        get {
            guard let value = objc_getAssociatedObject(self, &DiffTableAssociatedKeys.data) as? [Section] else { return [] }

            return value
        }
        set {
            objc_setAssociatedObject(self, &DiffTableAssociatedKeys.data, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    private var horizontalScrollsPositions: [String: CGPoint] {
        get {
            guard let value = objc_getAssociatedObject(self, &DiffTableAssociatedKeys.horizontalScrollsPositions) as? [String: CGPoint]  else { return [:] }

            return value
        }
        set {
            objc_setAssociatedObject(self, &DiffTableAssociatedKeys.horizontalScrollsPositions, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    private var cellHeights: [String: CGFloat] {
        get {
            guard let value = objc_getAssociatedObject(self, &DiffTableAssociatedKeys.cellHeights) as? [String: CGFloat] else { return [:] }

            return value
        }
        set {
            objc_setAssociatedObject(self, &DiffTableAssociatedKeys.cellHeights, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

// MARK: - Work with sections
public extension DiffTableProtocol {

    func appendOrReplaceSection(_ section: Section) {
        if let index = self.dataInput.firstIndex(where: { $0.differenceIdentifier == section.differenceIdentifier }) {
            self.dataInput[index] = section
            return
        }

        self.dataInput.append(section)
    }
}

// MARK: - Reloads
public extension DiffTableProtocol {

    func reloadAnimated() {
        self.reloadAnimated(.automatic)
    }

    func reloadAnimated(_ animated: UITableView.RowAnimation = .automatic) {
        self.dataInput.sort { $0.model.position.position() < $1.model.position.position() }
        let changeset = StagedChangeset(source: self.data, target: self.dataInput)

        if animated == .none {
            UIView.performWithoutAnimation {
                self.reload(usingChangeset: changeset, animation: animated)
            }
            return
        }
        self.reload(usingChangeset: changeset, animation: animated)
    }

    func reload(usingChangeset changeset: StagedChangeset<[Section]>,
                        animation: UITableView.RowAnimation) {
        self.tableView.reload(using: changeset, with: animation, setData: { (data) in
            self.data = data.map { (section) -> Section in
                let tempsection = section.model.copy()
                let elemets = section.elements.map { $0.copy() }
                return Section(model: tempsection, elements: elemets)
            }
        })
        self.dataInput.removeAll()
    }
}

// MARK: - Cache
public extension DiffTableProtocol {

    func cacheKey(forModel model: ModelRow, inSection section: Int) -> String {
        return "\(section)-\(model.differenceIdentifier)"
    }

}

// MARK: - Cell heights
public extension DiffTableProtocol {

    func storeHeight(forCell cell: UITableViewCell,
                     atIndexPath indexPath: IndexPath) {
        let model = self.data[indexPath.section].elements[indexPath.row]
        self.cellHeights[self.cacheKey(forModel: model, inSection: indexPath.section)] = cell.frame.height
    }

    func height(forCellAtIndexPath indexPath: IndexPath) -> CGFloat {
        let model = self.data[indexPath.section].elements[indexPath.row]
        return self.cellHeights[self.cacheKey(forModel: model, inSection: indexPath.section)] ?? 44
    }
}

// MARK: - Scroll positions
public extension DiffTableProtocol {

    func storeScrollPosition(forCell cell: UITableViewCell,
                             atIndexPath indexPath: IndexPath) {
        guard let collectionCell = cell as? CollectionCell else { return }

        let model = self.data[indexPath.section].elements[indexPath.row]
        let key = self.cacheKey(forModel: model, inSection: indexPath.section)

        self.horizontalScrollsPositions[key] = collectionCell.scrollPosition
    }

    func storeScrollPosition(_ position: CGPoint, forKey key: String) {
        self.horizontalScrollsPositions[key] = position
    }

    func restoreScrollPosition(forCell cell: UITableViewCell,
                               atIndexPath indexPath: IndexPath) {
        guard let collectionCell = cell as? CollectionCell else { return }

        let model = self.data[indexPath.section].elements[indexPath.row]
        let key = self.cacheKey(forModel: model, inSection: indexPath.section)

        if let offset = self.horizontalScrollsPositions[key] {
            collectionCell.scrollPosition = offset
        }
    }

    func resetScrollPositions() {
        self.horizontalScrollsPositions.removeAll()
    }

}

