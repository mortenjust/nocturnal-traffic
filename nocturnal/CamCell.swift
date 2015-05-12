//
//  CamCell.swift
//  nocturnal
//
//  Created by Morten Just Petersen on 1/10/15.
//  Copyright (c) 2015 Morten Just Petersen. All rights reserved.
//

import UIKit


class CamCell: UICollectionViewCell {
    var url = NSURL()
    var imageView = UIImageView()
    var testLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.frame = contentView.frame
        imageView.alpha = 0.8

        contentView.backgroundColor = UIColor.blackColor()
        imageView.contentMode = .ScaleAspectFill
        
        contentView.addSubview(imageView)

        testLabel.frame = contentView.frame
        contentView.addSubview(testLabel)
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
