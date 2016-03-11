//
//  videoCell.swift
//  StateChamps!
//
//  Created by Joel Nieman on 3/7/16.
//  Copyright © 2016 JoelNieman. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailOutlet: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var dateOutlet: UILabel!

    @IBOutlet weak var fullArticleTitleOutlet: UILabel!
    @IBOutlet weak var fullArticleAuthorOutlet: UILabel!
    @IBOutlet weak var fullArticleDateOutlet: UILabel!
    @IBOutlet weak var fullArticleImageOutlet: UIImageView!
    @IBOutlet weak var fullArticleBodyOutlet: UILabel!
}

