//
//  File.swift
//  
//
//  Created by Semen Kologrivov on 20.02.2021.
//

import UIKit
import DifferenceKit

// MARK: - Associated keys
private struct DiffCollectionAssociatedKeys {

    static var dataInput: UInt8 = 0
    static var data: UInt8 = 1
    static var horizontalScrollsPositions: UInt8 = 2
    
}

// MARK: - Protocol
public protocol DiffCollectionProtocol: class {

    var data: [Section] { get }
    var collectionView: UICollectionView! { get }

    func appendOrReplaceSection(_ section: Section)
    func reloadAnimated()
    func reloadAnimated(_ animated: Bool)

    func cacheKey(forModel model: ModelRow, inSection section: Int) -> String

    func storeScrollPosition(forCell cell: UICollectionViewCell, atIndexPath indexPath: IndexPath)
    func storeScrollPosition(_ position: CGPoint, forKey key: String)
    func restoreScrollPosition(forCell cell: UICollectionViewCell, atIndexPath indexPath: IndexPath)
    func resetScrollPositions()
}

// MARK: - Variables
public extension DiffCollectionProtocol {

    private var dataInput: [Section] {
        get {
            guard let value = objc_getAssociatedObject(self, &DiffCollectionAssociatedKeys.dataInput) as? [Section] else { return [] }

            return value
        }
        set {
            objc_setAssociatedObject(self, &DiffCollectionAssociatedKeys.dataInput, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    private(set) var data: [Section] {
        get {
            guard let value = objc_getAssociatedObject(self, &DiffCollectionAssociatedKeys.data) as? [Section] else { return [] }

            return value
        }
        set {
            objc_setAssociatedObject(self, &DiffCollectionAssociatedKeys.data, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    private var horizontalScrollsPositions: [String: CGPoint] {
        get {
            guard let value = objc_getAssociatedObject(self, &DiffCollectionAssociatedKeys.horizontalScrollsPositions) as? [String: CGPoint]  else { return [:] }

            return value
        }
        set {
            objc_setAssociatedObject(self, &DiffCollectionAssociatedKeys.horizontalScrollsPositions, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

// MARK: - Work with sections
public extension DiffCollectionProtocol {

    func appendOrReplaceSection(_ section: Section) {
        if let index = self.dataInput.firstIndex(where: { $0.differenceIdentifier == section.differenceIdentifier }) {
            self.dataInput[index] = section
            return
        }

        self.dataInput.append(section)
    }
}

// MARK: - Reloads
public extension DiffCollectionProtocol {

    func reloadAnimated() {
        self.reloadAnimated(true)
    }

    func reloadAnimated(_ animated: Bool) {
        self.dataInput.sort { $0.model.position.position() < $1.model.position.position() }
        let changeset = StagedChangeset(source: self.data, target: self.dataInput)

        if !animated {
            UIView.performWithoutAnimation {
                self.reload(usingChangeset: changeset)
            }
            return
        }

        self.reload(usingChangeset: changeset)
    }

    func reload(usingChangeset changeset: StagedChangeset<[Section]>) {
        self.collectionView.reload(using: changeset, setData: { (data) in
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
public extension DiffCollectionProtocol {

    func cacheKey(forModel model: ModelRow, inSection section: Int) -> String {
        return "\(section)-\(model.differenceIdentifier)"
    }

}

// MARK: - Scroll positions
public extension DiffCollectionProtocol {

    func storeScrollPosition(forCell cell: UICollectionViewCell,
                             atIndexPath indexPath: IndexPath) {
        guard let collectionCell = cell as? CollectionCell else { return }

        let model = self.data[indexPath.section].elements[indexPath.row]
        let key = self.cacheKey(forModel: model, inSection: indexPath.section)

        self.horizontalScrollsPositions[key] = collectionCell.scrollPosition
    }

    func storeScrollPosition(_ position: CGPoint, forKey key: String) {
        self.horizontalScrollsPositions[key] = position
    }

    func restoreScrollPosition(forCell cell: UICollectionViewCell,
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


