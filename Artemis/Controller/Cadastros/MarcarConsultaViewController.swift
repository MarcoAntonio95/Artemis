//
//  MarcarConsultaViewController.swift
//  Artemis
//
//  Created by PUCPR on 17/05/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit

class MarcarConsultaViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource,UINavigationControllerDelegate {

    @IBOutlet weak var especPV: UIPickerView!
    @IBOutlet weak var medicPV: UIPickerView!
    @IBOutlet weak var descTV: UITextView!
  
    var artemisDAO = ArtemisDAO()
    var x = 0
    var especialidadeAtual = ""
    var medicoAtual = ""
    
    override func viewDidLoad() {
//        artemisDAO.carregarEspecialidades(medicPV)
    
        print(ArtemisDAO.hospitalAtual?.especialidades?[0])
        super.viewDidLoad()
        especPV.tag = 1
        medicPV.tag = 2
        self.especPV.delegate = self
         self.especPV.dataSource = self
        self.medicPV.delegate = self
         self.medicPV.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in petsPV: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == especPV {
            return (ArtemisDAO.hospitalAtual!.especialidades!.count)
        } else if pickerView == medicPV {
            return (ArtemisDAO.hospitalAtual!.medicos!.count)
        } else {
            return 0
        
    }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if (pickerView == especPV) {
            especialidadeAtual = (ArtemisDAO.hospitalAtual?.especialidades![row])!
            print(especialidadeAtual)
        } else if (pickerView == medicPV) {
            medicoAtual = (ArtemisDAO.hospitalAtual?.medicos![row])!
                print(medicoAtual)
        }

    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == especPV{
            return ArtemisDAO.hospitalAtual!.especialidades![row]
        } else if pickerView == medicPV {
            return ArtemisDAO.hospitalAtual!.medicos![row]
        } else {
            return ""
        }
    }


    @IBAction func marcarConsulta(_ sender: Any) {
        let descricao = descTV.text
        
        ArtemisDAO.consultaAux.codigo = UUID().uuidString
        ArtemisDAO.consultaAux.descricao = descTV.text
        ArtemisDAO.consultaAux.medico = self.medicoAtual
        ArtemisDAO.consultaAux.especialidade = self.especialidadeAtual
        artemisDAO.descobrirDoutor()
    }
}


