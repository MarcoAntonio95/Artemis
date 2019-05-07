//
//  MedicTableViewCell.swift
//  Artemis
//
//  Created by PUCPR on 03/05/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit

class MedicTableViewCell: UITableViewCell {

    @IBOutlet weak var crmvLB: UILabel!
    @IBOutlet weak var nomeLB: UILabel!
    @IBOutlet weak var telefoneLB: UILabel!
    @IBOutlet weak var especialidadeLB: UILabel!
    @IBOutlet weak var medicIV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
