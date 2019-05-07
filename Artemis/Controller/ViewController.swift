//
//  ViewController.swift
//  Artemis
//
//  Created by PUCPR on 03/04/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit
import Firebase
class ViewController: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var senhaTF: UITextField!
    var email:String?
    var senha:String?
    var artemisDao = ArtemisDAO()
    override func viewDidLoad() {
        super.viewDidLoad()
   
    }

    @IBAction func Logar(_ sender: Any) {
        email = emailTF.text!
        senha = senhaTF.text!
      
        if email == "" && senha == ""{
            let alertController = UIAlertController(title: "Artemis", message:
                "Preencha todos os campos", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
        } else{
            artemisDao.autenticar(email!, senha!, self)
        }
    }
    
    @IBAction func Cadastrar(_ sender: Any) {
        self.performSegue(withIdentifier: "cadastrarSegue", sender: nil)
    }
}

