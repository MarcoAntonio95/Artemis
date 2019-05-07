//
//  CadastrarViewController.swift
//  Artemis
//
//  Created by PUCPR on 05/04/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit
import Firebase

class CadastrarViewController: UIViewController {

    @IBOutlet weak var nomeTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var senhaTF: UITextField!
    @IBOutlet weak var telefoneTF:UITextField!
    var email:String?
    var senha:String?
    var uid:String?
    var nome:String?
    var telefone:String?
    
    var artemisDAO = ArtemisDAO()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func Cadastrar(_ sender: Any) {
        email = emailTF.text!
        senha = senhaTF.text!
        nome = nomeTF.text!
        telefone = telefoneTF.text!
        
        if(email == "" && senha == "" && nome == "" && telefone == ""){
            let alertController = UIAlertController(title: "Artemis", message:
                "Preencha todos os campos", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }else{
            artemisDAO.cadastrar(email!, senha!, self, nome!, telefone!,"Paciente")
        }
    }
    
    
    @IBAction func Cancelar(_ sender: Any) {
     self.performSegue(withIdentifier: "cancelarSegue", sender: nil)
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
