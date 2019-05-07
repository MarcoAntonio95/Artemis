//
//  ArtemisDAO.swift
//  Artemis
//
//  Created by PUCPR on 05/04/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import Foundation
import Firebase

class ArtemisDAO {
    var reference: DatabaseReference!
    static var emergencias:[Hospital] = []
    var hospitais:[Hospital] = []
    static var usuarioAtual:User?
    static var hospitalAtual:Hospital?
    static var medicoAtual:Medico?
    static var quadroMedico:[Medico]?
    static var especialidadesVeterinarias:[String] = ["Acupuntura","Cardiologia","Clinica Geral","Dermatologia","Homeopatia","Oncologia","Patologia"]
        
    func autenticar(_ email:String, _ senha:String, _ view:UIViewController){
           reference = Database.database().reference()
            Auth.auth().signIn(withEmail: email, password: senha) { (user, error) in
                if error != nil {
                    let alertController = UIAlertController(title: "Artemis", message:
                        "Erro no Login", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                    view.present(alertController, animated: true, completion: nil)
                    
                    print(error)
                    return
                } else {
                    let userID = Auth.auth().currentUser?.uid
                  
                    if(userID != nil){
                        print(userID!)
                        let id = userID!
                        
                        self.reference.child("usuarios").child(id).observe(.value, with: { snapshot in
                        let value = snapshot.value as? NSDictionary
                        if value != nil{
                        self.carregarPerfil()
                        view.performSegue(withIdentifier: "userSegue", sender: nil)
                        }})
                        
                        self.reference.child("hospitais").child(id).observe(.value, with: { snapshot in
                            let value = snapshot.value as? NSDictionary
                            if value != nil{
                                self.carregarInstituicao()
                                self.carregarMedicos()
                                print("medicos \(ArtemisDAO.quadroMedico!.count)")
                                view.performSegue(withIdentifier: "hospSegue", sender: nil)
                        }})
                        
                        self.reference.child("medicos").child(id).observe(.value, with: { snapshot in
                            let value = snapshot.value as? NSDictionary
                            if value != nil{
                                view.performSegue(withIdentifier: "medcSegue", sender: nil)
                            }})
                    }
                }
            }
}
    
    func cadastrar(_ email:String, _ senha:String, _ view:UIViewController, _ nome:String, _ telefone:String, _ tipo:String){
        reference = Database.database().reference()
        Auth.auth().createUser(withEmail: email, password: senha) { (resultado, erro) in
            if let user = resultado?.user{
                resultado?.user.createProfileChangeRequest().displayName = "pac\(nome)"
                
                let newUser = ["uid": user.uid,
                               "nome": nome,
                               "email": email,
                               "telefone": telefone,
                                "tipo": tipo
                              ]
                
                self.reference.child("usuarios").child(user.uid).setValue(newUser)
                view.performSegue(withIdentifier: "cancelarSegue", sender: nil)
            }
            else{
                print("error")
                return
            }
        }
    }
    
    func cadastrarHospital(_ email:String,_ senha:String,_ hospital:Hospital, _ view:UIViewController){
        reference = Database.database().reference()
        Auth.auth().createUser(withEmail: email, password: senha) { (resultado, erro) in
            if let hosp = resultado?.user{
                let newHospital = [
                               "nome": hospital.nome,
                               "numero": hospital.numero,
                               "estado": hospital.estado,
                               "cidade": hospital.cidade,
                               "bairro": hospital.bairro,
                               "cep": hospital.cep,
                               "rua": hospital.rua,
                               "emergencia": hospital.emergencia,
                               "busca": hospital.busca,
                               "responsavel": hospital.responsavel
                              ]

    
                self.reference.child("hospitais").child(hosp.uid).setValue(newHospital)
                view.performSegue(withIdentifier: "cancelarSegue", sender: nil)
            }
            else{
                print("error")
                return
            }
        }
    }
    
    func cadastrarMedico(_ email:String,_ senha:String,_ medico:Medico, _ view:UIViewController){
        let hospitalID = Auth.auth().currentUser?.uid
        reference = Database.database().reference()
        Auth.auth().createUser(withEmail: email, password: senha) { (resultado, erro) in
            if let medic = resultado?.user{
                let newMedic = [
                    "nome": medico.nome,
                    "especialidade": medico.especialidade,
                    "crmv": medico.crmv,
                    "telefone": medico.telefone,
                    "hospital": hospitalID
                ]
              
                self.reference.child("medicos").child(medic.uid).setValue(newMedic)
                
                self.addMedToHospital(hospitalID!,medic.uid,medico.especialidade!)
                
                view.navigationController?.popViewController(animated: true)
            }
            else{
                print("error")
                return
            }
        }
    }
    
    func alert(_ text:String, _ view:UIViewController){
        let alertController = UIAlertController(title: "Artemis", message:
            text, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
        view.present(alertController, animated: true, completion: nil)
    }
    
    func  addMedToHospital(_ hospitalID:String,_ medicID:String, _ especialidade:String){
        if(hospitalID != ""){
            reference.child("hospitais").child(hospitalID).observe(.value, with: { snapshot in
                let value = snapshot.value as? NSDictionary
                var especialidades = value?["especialidades"] as? [String] ?? []
                var medicos = value?["medicos"] as? [String] ?? []
                if !especialidades.contains(especialidade) {
                    especialidades.append(especialidade)
                    self.reference.child("hospitais").child(hospitalID).child("especialidades").setValue(especialidades)
                }
                
                if !medicos.contains(medicID) {
                medicos.append(medicID)
                self.reference.child("hospitais").child(hospitalID).child("medicos").setValue(medicos)
                }
    })
        }
    }
    
    func carregarMedicos(){
        ArtemisDAO.quadroMedico = []
          let hospitalID = Auth.auth().currentUser?.uid
        reference.child("hospitais").child(hospitalID!).observe(.value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            let medicos = value?["medicos"] as? [String] ?? []
            
            if medicos.count > 0 {
                medicos.forEach { item in
                        self.reference.child("medicos").child(item).observe(.value, with: { snapshot in
                            let value = snapshot.value as? NSDictionary
                            let nome = value?["nome"] as? String ?? ""
                            let telefone = value?["telefone"] as? String ?? ""
                            let crmv = value?["crmv"] as? String ?? ""
                            let especialidade = value?["especialidade"] as? String ?? ""
                            
                            let medicAux = Medico(hospitalID!, nome, especialidade, crmv, telefone)
                            ArtemisDAO.quadroMedico?.append(medicAux)
                        })
                    }
                }
            })
        }


    
    
    
    func carregarPerfil(){
        let userID = Auth.auth().currentUser?.uid
           reference = Database.database().reference()
        if(userID != nil){
            print(userID!)
            reference.child("usuarios").child(userID!).observe(.value, with: { snapshot in
                let value = snapshot.value as? NSDictionary
                let nome = value?["nome"] as? String ?? ""
                let email = value?["email"] as? String ?? ""
                let cpf = value?["cpf"] as? String ?? ""
                let telefone = value?["telefone"] as? String ?? ""
                
                ArtemisDAO.usuarioAtual = User(nome,email,telefone,cpf,userID!)
            })
        }
    }

    func carregarInstituicao(){
        let userID = Auth.auth().currentUser?.uid
        reference = Database.database().reference()
        if(userID != nil){
            print(userID!)
            reference.child("hospitais").child(userID!).observe(.value, with: { snapshot in
                let value = snapshot.value as? NSDictionary
                let nome = value?["nome"] as? String ?? ""
                let rua = value?["rua"] as? String ?? ""
                let bairro = value?["bairro"] as? String ?? ""
                let numero = value?["numero"] as? String ?? ""
                let cidade = value?["cidade"] as? String ?? ""
                let estado = value?["estado"] as? String ?? ""
                let telefone = value?["telefone"] as? String ?? ""
                let cep = value?["cep"] as? String ?? ""
                let emergencia = value?["emergencia"] as? String ?? ""
                let busca = value?["busca"] as? String ?? ""
                let especialidades = value?["especialidades"] as? [String] ?? []
                let responsavel = value?["responsavel"] as? String ?? ""
                let medicos = value?["medicos"] as? [String] ?? []
            
                if especialidades != [] {
                    ArtemisDAO.hospitalAtual = Hospital(nome,rua,bairro,numero,cidade,estado,cep,responsavel,telefone,emergencia,busca,especialidades,medicos)
                } else{
                     ArtemisDAO.hospitalAtual = Hospital(nome,rua,bairro,numero,cidade,estado,cep,responsavel,telefone,emergencia,busca)
                }
                
            })
        }
    }
    
    func carregarMedico(){
        let userID = Auth.auth().currentUser?.uid
        reference = Database.database().reference()
        if(userID != nil){
            print(userID!)
            reference.child("medicos").child(userID!).observe(.value, with: { snapshot in
                let value = snapshot.value as? NSDictionary
                let nome = value?["nome"] as? String ?? ""
                let telefone = value?["telefone"] as? String ?? ""
                let crmv = value?["crmv"] as? String ?? ""
                let especialidade = value?["especialidade"] as? String ?? ""
                
            })
        }
    }
    
    
    func carregarHospitais(){
        reference = Database.database().reference()
        
        reference.child("hospitais").observe(.value) { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let hosp = snap.value as! [String: Any]
                let nome = hosp["nome"] as! String
                let bairro = hosp["bairro"] as! String
                let rua = hosp["rua"] as! String
                let numero = hosp["numero"] as! String
                let cidade = hosp["cidade"] as! String
                let estado = hosp["estado"] as! String
                let cep = hosp["cep"] as! String
                let emergencia = hosp["emergencia"] as! String
                let busca = hosp["busca"] as! String
                let responsavel = hosp["responsavel"] as! String
                let telefone = hosp["telefone"] as! String
                let hospitalAux = Hospital(nome, rua, bairro, numero, cidade, estado, cep,responsavel,telefone,emergencia,busca)
                
                if hospitalAux.emergencia == "Sim"{
                  ArtemisDAO.emergencias.append(hospitalAux)

                } else{
                    self.hospitais.append(hospitalAux)
                }
              
            }
          
        }
 
    }
    
    func cadastrarPet(_ nome:String, _ raca:String, _ idade:String, _ porte:String, _ imgData:Data){
        let userID = Auth.auth().currentUser?.uid
        reference = Database.database().reference()
        let path = "\(nome)\(String(Int.random(in: 0...9999)))"
        let newPet = [
        "nome": nome,
        "raca": raca,
        "idade": idade,
        "porte": porte,
        ]
                
    self.reference.child("usuarios").child(userID!).child("pets").child(path).setValue(newPet)
        
    self.uploadImage(imgData, path, "Pet")
    }
    
    
    func uploadImage(_ imageData: Data, _ path:String, _ tipo:String){
        
        let storageReference = Storage.storage().reference()
        let currentUser = Auth.auth().currentUser
        var profileImageRef:StorageReference?
        
        profileImageRef = storageReference.child("users").child(currentUser!.uid).child("pets").child(path)
        
        if tipo == "perfil"{
            profileImageRef = storageReference.child("users").child(currentUser!.uid).child("pets").child(path)
        }
       
        
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        profileImageRef!.putData(imageData, metadata: uploadMetaData) { (uploadedImageMeta, error) in
            
            if error != nil
            {
                print("Error took place \(String(describing: error?.localizedDescription))")
                return
            } else {
                
                
                print("Meta data of uploaded image \(String(describing: uploadedImageMeta))")
            }
        }
    }
}


