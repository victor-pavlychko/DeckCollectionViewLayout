//
//  DeckCollectionViewLayout.swift
//  NoteBucket
//
//  Created by Victor Pavlychko on 7/28/17.
//  Copyright © 2017 address.wtf. All rights reserved.
//

import UIKit

/// The `DeckCollectionViewLayoutDelegate` protocol defines methods that let you coordinate with a `DeckCollectionViewLayout`
/// object to implement a card stack layout. The methods of this protocol define insertion and deletion transitions for cards.
@objc public protocol DeckCollectionViewLayoutDelegate: UICollectionViewDelegate {

    /// Asks the delegate for the initial layout attributes of the appearing item’s cell.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view object displaying the flow layout.
    ///   - deckLayout: The layout object requesting the information.
    ///   - layoutAttributes: Layout attributes of the cell, intialized to the final value.
    @objc optional func collectionView(_ collectionView: UICollectionView, deckLayout: DeckCollectionViewLayout, willInsertItem layoutAttributes: UICollectionViewLayoutAttributes)

    /// Asks the delegate for the final layout attributes of the disappearing item’s cell.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view object displaying the flow layout.
    ///   - deckLayout: The layout object requesting the information.
    ///   - layoutAttributes: Layout attributes of the cell, intialized to the initial value.
    @objc optional func collectionView(_ collectionView: UICollectionView, deckLayout: DeckCollectionViewLayout, willDeleteItem layoutAttributes: UICollectionViewLayoutAttributes)
}

/// DeckCollectionViewLayout provides card stack layout for UICollectionView control.
@IBDesignable open class DeckCollectionViewLayout: UICollectionViewLayout {
    
    /// Amount of visible cards on screen.
    @IBInspectable open var cardCount = 5 {
        didSet { invalidateLayout() }
    }

    /// Insets of the deck inside the content area.
    @IBInspectable open var deckInsets = UIEdgeInsets(top: 50, left: 20, bottom: 20, right: 20) {
        didSet { invalidateLayout() }
    }

    /// Opacity decrease step for cards in the stack.
    @IBInspectable open var cardOpacityDelta = CGFloat(0.05) {
        didSet { invalidateLayout() }
    }

    /// Dimensions decrease step for cards in the stack. Final size will be fit inside the resulting dimensions to original card keep aspect ratio.
    @IBInspectable open var cardSizeDelta = CGSize(width: -20, height: -20) {
        didSet { invalidateLayout() }
    }

    /// Position offset step for cards in the stack, relative to previous card bounds.
    @IBInspectable open var cardOffsetDelta = CGPoint(x: 0, y: -10) {
        didSet { invalidateLayout() }
    }

    open override func prepare() {
        contentRect = UIEdgeInsetsInsetRect(collectionView!.bounds, collectionView!.contentInset)
        cardFrame = UIEdgeInsetsInsetRect(contentRect, deckInsets)
        cardScaleFactor = min(cardFrame.width.scaleFactor(delta: cardSizeDelta.width),
                              cardFrame.height.scaleFactor(delta: cardSizeDelta.height))
        cardOffsetStep = CGPoint(x: cardOffsetDelta.x + cardFrame.width * (1 - cardScaleFactor) * cardOffsetDelta.x.signum / 2,
                                 y: cardOffsetDelta.y + cardFrame.height * (1 - cardScaleFactor) * cardOffsetDelta.y.signum / 2)
        visibleCardAttributes = makeVisibleCardAttributes()
        deletedItems = []
        insertedItems = []
    }
    
    open override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        deletedItems = updateItems
            .filter { $0.updateAction == .delete }
            .flatMap { $0.indexPathBeforeUpdate }
        insertedItems = updateItems
            .filter { $0.updateAction == .insert }
            .flatMap { $0.indexPathAfterUpdate }
    }
    
    open override var collectionViewContentSize: CGSize {
        return contentRect.size
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return visibleCardAttributes
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return makeLayoutAttributesForItem(at: indexPath)
    }
    
    open override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = makeLayoutAttributesForItem(at: itemIndexPath)
        if insertedItems.contains(itemIndexPath) {
            if let callback = delegate?.collectionView(_:deckLayout:willInsertItem:) {
                callback(collectionView!, self, attr)
            } else {
                attr.alpha = 0
            }
        }
        return attr
    }

    open override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = makeLayoutAttributesForItem(at: itemIndexPath)
        if deletedItems.contains(itemIndexPath)  {
            attr.zIndex += 1
            if let callback = delegate?.collectionView(_:deckLayout:willDeleteItem:) {
                callback(collectionView!, self, attr)
            } else {
                attr.alpha = 0
            }
        }
        return attr
    }
    
    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    private var delegate: DeckCollectionViewLayoutDelegate? {
        return collectionView?.delegate as? DeckCollectionViewLayoutDelegate
    }
    
    private var contentRect: CGRect = .zero
    private var cardFrame: CGRect = .zero
    private var cardScaleFactor: CGFloat = 0
    private var cardOffsetStep: CGPoint = .zero
    private var visibleCardAttributes: [UICollectionViewLayoutAttributes] = []

    private var deletedItems: [IndexPath] = []
    private var insertedItems: [IndexPath] = []

    private func makeVisibleCardAttributes() -> [UICollectionViewLayoutAttributes] {
        var result: [UICollectionViewLayoutAttributes] = []
        for section in 0 ..< collectionView!.numberOfSections {
            for item in 0 ..< collectionView!.numberOfItems(inSection: section) {
                result.append(makeLayoutAttributesForItem(offset: result.count, at: IndexPath(item: item, section: section)))
                if result.count == cardCount {
                    return result
                }
            }
        }
        return result
    }

    private func makeLayoutAttributesForItem(offset: Int? = nil, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        let offset = offset ?? (0 ..< indexPath.section).reduce(indexPath.item, { $0 + collectionView!.numberOfItems(inSection: $1) })
        let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attr.frame = cardFrame
        attr.zIndex = -offset * 2
        attr.alpha = offset >= cardCount ? 0 : max(0, 1 - cardOpacityDelta * CGFloat(offset))
        attr.transform = CGAffineTransform.identity
            .translated(by: cardOffsetStep * CGFloat(offset))
            .scaled(by: max(0, 1 - (1 - cardScaleFactor) * CGFloat(offset)))
        return attr
    }
}
