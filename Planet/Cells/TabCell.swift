//
//  TabCell.swift
//  Planet
//
//  Created by Kovs on 09.09.2022.
//

import UIKit

class TabCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var url: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
