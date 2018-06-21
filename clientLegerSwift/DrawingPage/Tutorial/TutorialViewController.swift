//
//  TutorialViewController.swift
//  clientLegerSwift
//
//  Created by lea el hage on 2018-03-24.
//  Copyright © 2018 log3900. All rights reserved.
//

import Foundation
import UIKit

class TutorialViewController: UIViewController {
    
    @IBOutlet weak var scroll: UIScrollView!
    
    var imageArr = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageArr = [#imageLiteral(resourceName: "Tut3"), #imageLiteral(resourceName: "Tut1"), #imageLiteral(resourceName: "tut2-11"), #imageLiteral(resourceName: "tut2-12"), #imageLiteral(resourceName: "tut2-10"),#imageLiteral(resourceName: "tut2-7"), #imageLiteral(resourceName: "tut2-2"), #imageLiteral(resourceName: "tut2-9"), #imageLiteral(resourceName: "tut2-1"), #imageLiteral(resourceName: "tut2-8"), #imageLiteral(resourceName: "tut2-6")]
        
        for i in 0..<imageArr.count{
            let imageV = UIImageView()
            imageV.image = imageArr[i]
            
            let xCoordinate = scroll.frame.width * CGFloat(i)
        
            imageV.frame = CGRect(x: xCoordinate, y: 0, width:self.scroll.frame.width, height: self.scroll.frame.height)
            //imageV.contentMode = .scaleAspectFit
            
            
            scroll.contentSize.width = scroll.frame.size.width * CGFloat(i + 1)
            scroll.addSubview(imageV)
        }
    }
    
    
    @IBAction func doneWasPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
