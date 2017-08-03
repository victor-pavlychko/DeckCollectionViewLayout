//
//  ViewController.swift
//  DeckCollectionViewLayoutDemo
//
//  Created by Victor Pavlychko on 7/31/17.
//  Copyright © 2017 address.wtf. All rights reserved.
//

import UIKit
import DeckCollectionViewLayout

class ViewController: UIViewController {

    @IBOutlet fileprivate var collectionView: UICollectionView!
    @IBOutlet fileprivate var segmentedControl: UISegmentedControl!
    
    fileprivate var count = 100
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.clipsToBounds = false
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 5
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowRadius = 3
        cell.layer.shadowOpacity = 0.6
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        collectionView.performBatchUpdates({
            if self.segmentedControl.selectedSegmentIndex == 0 {
                self.count -= 1
                collectionView.deleteItems(at: [indexPath])
            } else {
                self.count += 1
                collectionView.insertItems(at: [indexPath])
            }
        }, completion: { _ in
            // ...
        })
    }
}

extension ViewController: DeckCollectionViewLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, deckLayout: DeckCollectionViewLayout, willInsertItem layoutAttributes: UICollectionViewLayoutAttributes) {
        layoutAttributes.alpha = 0
        layoutAttributes.transform = layoutAttributes.transform
            .translatedBy(x: 0, y: -200)
            .scaledBy(x: 0.5, y: 0.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, deckLayout: DeckCollectionViewLayout, willDeleteItem layoutAttributes: UICollectionViewLayoutAttributes) {
        layoutAttributes.alpha = 0
        layoutAttributes.transform = layoutAttributes.transform
            .translatedBy(x: 0, y: -200)
            .scaledBy(x: 0.5, y: 0.5)
    }
}
