//
//  ItemCell.swift
//  TesteZup
//
//  Created by Fredyson Costa Marques Bentes on 31/12/16.
//  Copyright © 2016 home. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet var lblItem: UILabel!
    @IBOutlet var btnDeleteItem: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
