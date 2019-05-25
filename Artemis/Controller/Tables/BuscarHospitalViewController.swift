//
//  BuscarHospitalViewController.swift
//  Artemis
//
//  Created by PUCPR on 10/05/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit

class BuscarHospitalViewController: UIViewController {

    @IBOutlet weak var estadoTF: UITextField!
    @IBOutlet weak var cidadeTF: UITextField!
    @IBOutlet weak var bairroTF: UITextField!
    var artemisDAO = ArtemisDAO()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buscaHospitais(_ sender: Any) {
        var estado = estadoTF.text!
         var cidade = cidadeTF.text!
         var bairro = bairroTF.text!
        
        artemisDAO.buscarHospitais(estado,cidade,bairro)
    }
}
