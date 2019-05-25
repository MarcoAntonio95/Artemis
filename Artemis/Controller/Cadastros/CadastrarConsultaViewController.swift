//
//  CadastrarConsultaViewController.swift
//  Artemis
//
//  Created by PUCPR on 08/05/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit

class CadastrarConsultaViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource,UINavigationControllerDelegate {
    @IBOutlet weak var dataPV: UIDatePicker!
    @IBOutlet weak var petsPV: UIPickerView!
    var artemisDAO = ArtemisDAO()
    var pets:[Pet] = []
    var petSelecionado = Pet()
    var dia = 0
    var mes = 0
    var ano = 0
    var hora = 0
    var minutos = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        artemisDAO.carregarPets(petsPV)
        
        self.petsPV.delegate = self
        self.petsPV.dataSource = self
        dataPV.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
    }

    override func viewWillAppear(_ animated: Bool) {
       print(
        "count \(ArtemisDAO.petsAtuais.count)")
        if ArtemisDAO.petsAtuais.count > 0 {
            pets = ArtemisDAO.petsAtuais
            petsPV.reloadAllComponents()
        }
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: sender.date)
            dia = components.day!
            mes = components.month!
            ano = components.year!
            hora = components.hour!
            minutos = components.minute!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func numberOfComponents(in petsPV: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ petsPV: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if ArtemisDAO.petsAtuais.count > 0 {
            return ArtemisDAO.petsAtuais.count
        } else{
            return 0
        }
    }
    
    func pickerView(_ petsPV: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        petSelecionado = ArtemisDAO.petsAtuais[row] as Pet
    }
    
    func pickerView(_ petsPV: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if ArtemisDAO.petsAtuais.count > 0 {
            return ArtemisDAO.petsAtuais[row].nome
        } else{
            return ""
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "proxSegue"{
            
            
            
            let data = "\(dia)-\(mes)-\(ano)"
            let horas = "\(hora)-\(minutos)"
            ArtemisDAO.consultaAux.data = data
            ArtemisDAO.consultaAux.hora = horas
            print(petSelecionado.nome)
            if petSelecionado == nil{
             ArtemisDAO.petAtual = ArtemisDAO.petsAtuais[0]
            } else{
            ArtemisDAO.petAtual = petSelecionado
            }

        }

    }

}
