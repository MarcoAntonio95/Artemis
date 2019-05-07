//
//  PerfilHospitalViewController.swift
//  Artemis
//
//  Created by ALUNO on 03/05/2019.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit

class PerfilHospitalViewController: UIViewController {

    @IBOutlet weak var nomeLB: UILabel!
    @IBOutlet weak var donoLB: UILabel!
    @IBOutlet weak var enderecoLB: UILabel!
    @IBOutlet weak var telefoneLB: UILabel!
    var artemisDAO = ArtemisDAO()
    override func viewDidLoad() {
        super.viewDidLoad()
      artemisDAO.carregarInstituicao()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nomeLB.text = ArtemisDAO.hospitalAtual?.nome
        donoLB.text = ArtemisDAO.hospitalAtual?.responsavel
        enderecoLB.text = ArtemisDAO.hospitalAtual?.rua
        telefoneLB.text = ArtemisDAO.hospitalAtual?.telefone
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
