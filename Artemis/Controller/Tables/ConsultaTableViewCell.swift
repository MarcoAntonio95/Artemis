//
//  ConsultaTableViewCell.swift
//  Artemis
//
//  Created by PUCPR on 23/05/2019.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit

class ConsultaTableViewCell: UITableViewCell {

@IBOutlet weak var nomeLB: UILabel!
@IBOutlet weak var dataLB: UILabel!
@IBOutlet weak var horaLB: UILabel!
@IBOutlet weak var especialidadeLB: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
