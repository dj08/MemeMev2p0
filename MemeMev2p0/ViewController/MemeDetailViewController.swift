//
//  MemeDetailViewController.swift
//  MemeMev2p0
//
//  Created by Dushyant Juneja on 9/9/20.
//  Copyright © 2020 Dushyant Juneja. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {

    var memeToShow: Meme!
    @IBOutlet var memeImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memeImageView.image = memeToShow.memedImage
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
