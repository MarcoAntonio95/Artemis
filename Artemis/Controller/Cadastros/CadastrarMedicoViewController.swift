//
//  CadastrarMedicoViewController.swift
//  Artemis
//
//  Created by ALUNO on 03/05/2019.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit

class CadastrarMedicoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var nomeLB: UITextField!
    @IBOutlet weak var crvmLB: UITextField!
    @IBOutlet weak var telefoneLB: UITextField!
    @IBOutlet weak var especPV: UIPickerView!
    @IBOutlet weak var emailLB: UITextField!
    @IBOutlet weak var senhaLB: UITextField!
    
    var nome:String?
    var crmv:String?
    var telefone:String?
    var espec:String?
    var email:String?
    var senha:String?
    var artemisDAO = ArtemisDAO()
    var especialidades:[String] = ArtemisDAO.especialidadesVeterinarias
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.especPV.delegate = self
        self.especPV.dataSource = self
        
    }
    
   override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Number of columns of data
    func numberOfComponents(in especPV: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ especPV: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return especialidades.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ especPV: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return especialidades[row]
    }
    
    @IBAction func cadastrarMedico(_ sender: Any) {
       nome = nomeLB.text!
       crmv = crvmLB.text!
   telefone = telefoneLB.text!
      email = emailLB.text!
      senha = senhaLB.text!
        let especialidade = especialidades[especPV.selectedRow(inComponent: 0)]
        let medicoAux = Medico("", nome!, especialidade, crmv!, telefone!)
        
        artemisDAO.cadastrarMedico(email!,senha!,medicoAux,self)
        
    }
    
}
