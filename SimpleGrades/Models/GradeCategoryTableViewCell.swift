//
//  GradeCategoryTableViewCell.swift
//  SimpleGrades
//
//  Created by Marvin von Rappard on 12.02.19.
//  Copyright © 2019 Marvin von Rappard. All rights reserved.
//

import UIKit

class GradeCategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelGrade: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
