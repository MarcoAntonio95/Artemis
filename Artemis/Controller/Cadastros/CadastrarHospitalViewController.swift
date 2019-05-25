//
//  CadastrarHospitalViewController.swift
//  Artemis
//
//  Created by PUCPR on 12/04/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit

class CadastrarHospitalViewController: UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate
 {

    @IBOutlet weak var nomeTF: UITextField!
    @IBOutlet weak var responsavelTF: UITextField!
    
    @IBOutlet weak var estadoTF: UITextField!
    @IBOutlet weak var cidadeTF: UITextField!
    
    @IBOutlet weak var bairroTF: UITextField!
    @IBOutlet weak var numeroTF: UITextField!
    
    @IBOutlet weak var cepTF: UITextField!
    @IBOutlet weak var ruaTF: UITextField!
    
    @IBOutlet weak var telefoneTF: UITextField!
    @IBOutlet weak var senhaTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var imageIV: UIImageView!
    @IBOutlet weak var emergenciaSW: UISwitch!
    var artemisDAO = ArtemisDAO()
    var img:UIImage?
    var imgData:Data?


    override func viewDidLoad() {
        super.viewDidLoad()

        imageIV.isUserInteractionEnabled = true
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.alterarFoto))
        
        imageIV.addGestureRecognizer(longPressGesture)
        // Do any additional setup after loading the view.
    }
    

    @IBAction func cadastrar(_ sender: Any) {
        var email:String = emailTF.text!
        var senha:String = senhaTF.text!
        var nome:String = nomeTF.text!
        var responsavel:String = responsavelTF.text!
        var estado:String = estadoTF.text!
        var cidade:String = cidadeTF.text!
        var bairro:String = bairroTF.text!
        var numero:String = numeroTF.text!
        var rua:String = ruaTF.text!
        var cep:String = cepTF.text!
        var telefone:String = telefoneTF.text!
        var emergencia = ""
        if(emergenciaSW.isOn){
            emergencia = "Sim"
        }else{
            emergencia = "Nao"
        }
    
        if(email != "" && senha != "" && nome != "" && responsavel != "" && telefone != "" && estado != "" && cidade != ""
            && bairro != "" && numero != "" && rua != "" && cep != "" && emergencia != ""){
            var endereco:String?
            endereco = "\(nome)%\(rua), \(numero) - \(bairro), \(cidade) - \(estado), \(cep)"
            if imgData != nil {
                let hospital = Hospital(nome, rua, bairro, numero, cidade, estado, cep,responsavel,telefone, emergencia, endereco!)
                artemisDAO.cadastrarHospital(email,senha,hospital,imgData!,self)
                }else{
                artemisDAO.alert("Por favor! Selecione uma imagem", self)
            }
        }else{
            artemisDAO.alert("Por favor! Preencha todos os campos", self)
        }
    }
    
    @objc func alterarFoto() {
        let imageController  = UIImagePickerController()
        imageController.delegate = self
        imageController.sourceType = .photoLibrary
        self.present(imageController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        
        img = info[UIImagePickerController.InfoKey.originalImage] as?  UIImage
        
        imageIV.image = img
        
        imgData =  imageIV.image?.pngData()
        // uploadProfileImage(imageData: imgData!)
        picker.dismiss(animated: true, completion:nil)
    }




func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
{
    picker.dismiss(animated: true, completion:nil)
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
