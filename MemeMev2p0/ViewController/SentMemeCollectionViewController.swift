//
//  SentMemeCollectionViewController.swift
//  MemeMev2p0
//
//  Created by Dushyant Juneja on 9/9/20.
//  Copyright © 2020 Dushyant Juneja. All rights reserved.
//

import Foundation
import UIKit

class SentMemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView?.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if collectionView != nil {
            collectionView?.reloadData()
        }
    }
    
    func showEmptyView(_ show: Bool) {
        if show {
            let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView!.frame.width, height: collectionView!.frame.height))
            label.numberOfLines = 2
            label.textAlignment = .center
            label.text = "No Memes Stored!\nClick '+' to create a new Meme."
            collectionView!.backgroundView = label
        } else {
            collectionView!.backgroundView = nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMemeDetail" {
            if let cell = sender as? SentMemeCollectionViewCell {
                let detailView = segue.destination as! MemeDetailViewController
                detailView.memeToShow = appDelegate.memes[(collectionView?.indexPath(for: cell)?.row)!]
            }
        }
    }
        
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        appDelegate.memes.count == 0 ? showEmptyView(true) : showEmptyView(false)
        return appDelegate.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentMemeCollectionViewCell",
                                                      for: indexPath) as! SentMemeCollectionViewCell
        let meme: Meme = appDelegate.memes[indexPath.row]
        cell.cellImageView!.image = meme.memedImage
        return cell
    }
}
