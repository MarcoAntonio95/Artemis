//
//  CadastrarAnimalViewController.swift
//  Artemis
//
//  Created by ALUNO on 06/05/2019.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class CadastrarAnimalViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate
 {

    @IBOutlet weak var nomeTF: UITextField!
    @IBOutlet weak var racaTF: UITextField!
    @IBOutlet weak var idadeTF: UITextField!
    @IBOutlet weak var portePV: UIPickerView!
    @IBOutlet weak var fotoIV: UIImageView!
    var nome:String?
    var idade:String?
    var raca:String?
    var porte:String?
    var img:UIImage?
    var imgData:Data?
    var artemisDAO = ArtemisDAO()
    var portes:[String] = ["Pequeno","Médio","Grande"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.portePV.delegate = self
        self.portePV.dataSource = self
        // Do any additional setup after loading the view.
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
        return portes.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ especPV: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return portes[row]
    }
    
    @IBAction func cadastrarPET(_ sender: Any) {
    nome = nomeTF.text!
    raca = racaTF.text!
    idade = idadeTF.text!
    porte = portes[portePV.selectedRow(inComponent: 0)]
    
        if nome != "" && raca != "" && idade != "" && porte != "" {
            if imgData != nil {
                artemisDAO.cadastrarPet(nome!,raca!,idade!,porte!,imgData!)
            }else{
                artemisDAO.alert("Por favor! Selecione uma imagem", self)
            }
        }else{
            artemisDAO.alert("Por favor! Preencha todos os campos", self)
        }
   
}

    @IBAction func alterarFoto(_ sender: Any) {
        let imageController  = UIImagePickerController()
        imageController.delegate = self
        imageController.sourceType = .photoLibrary
        self.present(imageController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {

        img = info[UIImagePickerController.InfoKey.originalImage] as?  UIImage
        
        fotoIV.image = img
        
        imgData = fotoIV.image?.pngData()
       // uploadProfileImage(imageData: imgData!)
     picker.dismiss(animated: true, completion:nil)
    }
    
}

func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion:nil)
    }
    


