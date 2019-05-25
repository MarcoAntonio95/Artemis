//
//  DetalhesConsultaViewController.swift
//  Artemis
//
//  Created by PUCPR on 23/05/2019.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit

class DetalhesConsultaViewController: UIViewController {

    @IBOutlet weak var nomeTF: UILabel!
    @IBOutlet weak var racaTF: UILabel!
    @IBOutlet weak var porteTF: UILabel!
    @IBOutlet weak var descricaoTF: UITextView!
    @IBOutlet weak var diagnosticoTF: UITextView!
    let artemisDAO = ArtemisDAO()
    override func viewDidLoad() {
        super.viewDidLoad()
        setInfo()
        // Do any additional setup after loading the view.
    }

    func setInfo(){
        nomeTF.text = ArtemisDAO.petAtual!.nome
        racaTF.text = ArtemisDAO.petAtual!.raca
        porteTF.text = ArtemisDAO.petAtual!.porte
        descricaoTF.text = ArtemisDAO.consultaAtual!.descricao
    }

    @IBAction func dianosticar(_ sender: Any) {
    var diagnostico = diagnosticoTF.text!
    if diagnostico != "" {
    artemisDAO.finalizarConsulta(diagnostico)
    }
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
