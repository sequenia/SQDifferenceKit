//
//  File.swift
//  
//
//  Created by Semen Kologrivov on 21.02.2021.
//

import UIKit
import DifferenceKit

open class TableCollectionCell: UITableView, CollectionCell, DiffCollectionProtocol {

    public var scrollPosition: CGPoint {
        get {
            self.collectionView.contentOffset
        }
        set {
            self.collectionView.setContentOffset(newValue, animated: false)
        }
    }

    public var collectionView: UICollectionView!

    public var model: CollectionModelRow? {
        didSet {
            (self.model?.sections ?? []).forEach { self.appendOrReplaceSection($0) }
        }
    }

    public weak var collectionDelegate: CollectionCellDelegate?

    public func bind(model: CollectionModelRow, delegate: CollectionCellDelegate) {
        self.model = model
        self.collectionDelegate = delegate

        self.reloadAnimated()
    }

    open override func awakeFromNib() {
        super.awakeFromNib()

        self.initCollectionView()
    }

    internal func initCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
}

extension TableCollectionCell: UICollectionViewDataSource {

    public override func numberOfRows(inSection section: Int) -> Int {
        return self.data.count
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data[section].elements.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

}

extension TableCollectionCell: UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView,
                               willDisplay cell: UICollectionViewCell,
                               forItemAt indexPath: IndexPath) {
        let section = self.data[indexPath.section]
        let model = section.elements[indexPath.row]

        self.collectionDelegate?.collectionModel(self.model,
                                                 willShowModelRow: model,
                                                 inSection: section)
    }

    public func collectionView(_ collectionView: UICollectionView,
                               didSelectItemAt indexPath: IndexPath) {
        let section = self.data[indexPath.section]
        let model = section.elements[indexPath.row]

        self.collectionDelegate?.collectionModel(self.model,
                                                 didSelectModel: model,
                                                 inSection: section)
    }
}

extension TableCollectionCell: UIScrollViewDelegate {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDragging || scrollView.isDecelerating {
            self.collectionDelegate?.saveScrollPosition(scrollView.contentOffset, forModel: self.model)
        }
    }
}
