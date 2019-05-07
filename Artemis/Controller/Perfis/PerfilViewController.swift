//
//  PerfilViewController.swift
//  Artemis
//
//  Created by PUCPR on 08/04/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit

class PerfilViewController: UIViewController {
    var artemisDAO = ArtemisDAO()
    @IBOutlet weak var emailLB: UILabel!
    @IBOutlet weak var cpfLB: UILabel!
    @IBOutlet weak var nomeLB: UILabel!
    @IBOutlet weak var telefoneLB: UILabel!
    
    @IBOutlet weak var petsIV: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        artemisDAO.carregarPerfil()
        petsIV.isUserInteractionEnabled = true
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress))
        petsIV.addGestureRecognizer(longPressGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if ArtemisDAO.usuarioAtual != nil {
            nomeLB.text = ArtemisDAO.usuarioAtual?.nome
            emailLB.text = ArtemisDAO.usuarioAtual?.email
            telefoneLB.text = ArtemisDAO.usuarioAtual?.telefone
            cpfLB.text = ArtemisDAO.usuarioAtual?.cpf
        }
    }
    
    @objc func longPress() {
        print("HELLO")
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
