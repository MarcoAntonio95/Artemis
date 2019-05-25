//
//  ArtemisDAO.swift
//  Artemis
//
//  Created by PUCPR on 05/04/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation
import MapKit

class ArtemisDAO {
    var reference: DatabaseReference!

    //Mapa
    static var emergencias:[Hospital] = []
    static var hospitais:[Hospital] = []
    static var posAtual = CLLocationCoordinate2D()
    static var mapaAtual = MKMapView()
    var cordenadas:[(x: Double,y: Double)] = []
    static var hospDist:[( _: String, _: String)] = []
    var direcoes = [MKDirections]()
    static var hospitaisRotas = [CLLocationDistance]()
    static var emergenciasRotas = [CLLocationDistance]()
    static var proximosRotas = [CLLocationDistance]()
    static var proximosHospitais:[String] = []

    //Usuario Atual
    static var usuarioAtual:User?
    static var hospitalAtual:Hospital?
    static var medicoAtual:Medico?
    static var petsAtuais:[Pet] = []
    static var petAtual:Pet?
    static var consultaAtual:Consulta?
    static var quadroMedico:[Medico]?
    static var consultasMedico:[Consulta]?
    static var petsImages:[UIImage] = []
    static var medicUid = ""
    //Consulta Atual
    static var consultaAux = Consulta()
    static var especialistas = [
        "Acupuntura"  : [String](),
        "Cardiologia" : [String](),
        "Clinica Geral" : [String](),
        "Dermatologia" : [String](),
        "Homeopatia" : [String](),
        "Oncologia" : [String](),
        "Patologia" : [String]()]

    //Especi
    static var especialidades:[String] = []

    static var imageProfile = UIImage()


    static var busca:[Hospital] = []

    //Static
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
                                self.carregarMedico()
                                self.carregarConsultas()
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

    func cadastrarHospital(_ email:String,_ senha:String,_ hospital:Hospital,_ imgData:Data, _ view:UIViewController){
        reference = Database.database().reference()
        Auth.auth().createUser(withEmail: email, password: senha) { (resultado, erro) in
            if let hosp = resultado?.user{
                let newHospital = [
                               "nome": hospital.nome,
                               "numero": hospital.numero,
                               "estado": hospital.estado,
                               "cidade": hospital.cidade,
                               "bairro": hospital.bairro,
                               "telefone" : hospital.telefone,
                               "cep": hospital.cep,
                               "rua": hospital.rua,
                               "emergencia": hospital.emergencia,
                               "busca": hospital.busca,
                               "responsavel": hospital.responsavel
                              ]
            self.reference.child("hospitais").child(hosp.uid).setValue(newHospital)
                var path = hosp.uid
                self.uploadImage(imgData, path, "Hospital")
                view.performSegue(withIdentifier: "cancelarSegue", sender: nil)
            }
            else{
                print("error")
                return
            }
        }
    }

    func definirPet(_ x:Int){
        ArtemisDAO.petAtual = ArtemisDAO.petsAtuais[x]
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

    func definirPosAtual(_ pos:CLLocationCoordinate2D)  {
        ArtemisDAO.posAtual = pos

    }

    func definirMapAtual(_ mapa:MKMapView!){
        ArtemisDAO.mapaAtual = mapa
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

                self.downloadImage("","perfil")
            })
        }
    }

    func definirHospital(_ nome: String){
        for i in 0 ... ArtemisDAO.hospitais.count-1{
            if ArtemisDAO.hospitais[i].nome == nome {
                print("SETOU")
                ArtemisDAO.hospitalAtual = ArtemisDAO.hospitais[i]
               ArtemisDAO.consultaAux.local = ArtemisDAO.hospitalAtual?.nome
            }
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
                let medic_espec = value?["medic_espec"] as? [String] ?? []
                if especialidades != [] {
                    ArtemisDAO.hospitalAtual = Hospital(nome,rua,bairro,numero,cidade,estado,cep,responsavel,telefone,emergencia,busca,especialidades,medicos,medic_espec)
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
            reference.child("medicos").child(userID!).observe(.value, with: { snapshot in
                let value = snapshot.value as? NSDictionary
                let nome = value?["nome"] as? String ?? ""
                let telefone = value?["telefone"] as? String ?? ""
                let crmv = value?["crmv"] as? String ?? ""
                let hospital = value?["crmv"] as? String ?? ""
                let especialidade = value?["especialidade"] as? String ?? ""
                let consultas = value?["consultas"] as? [String] ?? []

                if consultas != []{
                ArtemisDAO.medicoAtual = Medico(nome,especialidade,hospital,crmv,telefone,consultas)
                } else{
                ArtemisDAO.medicoAtual = Medico(nome,especialidade,hospital,crmv,telefone)
                }
            })
        }
    }

    func definirConsulta(_ consulta:Consulta){
    ArtemisDAO.consultaAtual = consulta
    }


    func carregarConsultas(){
    ArtemisDAO.consultasMedico = []
      let medicoID = Auth.auth().currentUser?.uid
    reference.child("medicos").child(medicoID!).observe(.value, with: { snapshot in
        let value = snapshot.value as? NSDictionary
        let consultas = value?["consultas"] as? [String] ?? []
        if consultas.count > 0 {
            consultas.forEach { item in
                    self.reference.child("consultas").child(item).observe(.value, with: { snapshot in
                        let value = snapshot.value as? NSDictionary
                        let codigo = value?["nome"] as? String ?? ""
                        let medico = value?["telefone"] as? String ?? ""
                        let hora = value?["crmv"] as? String ?? ""
                        let data = value?["especialidade"] as? String ?? ""
                        let local = value?["crmv"] as? String ?? ""
                        let descricao = value?["descricao"] as? String ?? ""
                        let pet = value?["pet"] as? String ?? ""
                        let especialidade = value?["especialidade"] as? String ?? ""
    
                        
                        let consultaAux = Consulta(codigo, medico, hora, data, local, especialidade, descricao, pet)
                        ArtemisDAO.consultasMedico?.append(consultaAux)
                    })
                }
            }
        })
    }

    func carregarHospitais(){
        var hospitalAux = Hospital()
        var medicos:[String] = []
        var especialidades:[String] = []
        var medic_espec:[String] = []
        reference = Database.database().reference()
        var cont = 0

        reference.child("hospitais").observe(.value) { (snapshot) in
            for child in snapshot.children {
                cont = Int(snapshot.childrenCount)
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

                if hosp["especialidades"] != nil{
                especialidades  = hosp["especialidades"] as! [String]}

                if hosp["medicos"] != nil{
                medicos  = hosp["medicos"] as! [String]}

                if hosp["especialidades"] != nil && hosp["medicos"] != nil{
                    medic_espec  = hosp["medic-espec"] as! [String]
                    print("adicinou")
                    hospitalAux = Hospital(nome, rua, bairro, numero, cidade, estado, cep,responsavel,telefone,emergencia,busca,especialidades,medicos,medic_espec)
                }else{
                    hospitalAux = Hospital(nome, rua, bairro, numero, cidade, estado, cep,responsavel,telefone,emergencia,busca)
                }

                ArtemisDAO.hospitais.append(hospitalAux)

                if hospitalAux.emergencia == "Sim"{
                    ArtemisDAO.emergencias.append(hospitalAux)
                }

                if ArtemisDAO.hospitais.count == cont && cont > 0{
                    self.buscarCoordenadas(ArtemisDAO.mapaAtual)
                }

            }

        }
    }

    func buscarHospitais(_ estado:String,_ cidade:String, _ bairro:String){
        var encontrados:[Hospital] = []
        for i in 0 ... ArtemisDAO.hospitais.count-1{
            var hospAux = ArtemisDAO.hospitais[i]
            if hospAux.estado == estado && hospAux.cidade == cidade && hospAux.bairro == bairro{
                encontrados.append(hospAux)
                }

            }
        ArtemisDAO.busca = encontrados
    }

    func carregarImagem(_ image:UIImageView,_ tipo:String){
        if tipo == "Perfil"{
            image.image = ArtemisDAO.imageProfile
            if image.image == nil{
                carregarImagem(image,tipo)
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

    func carregarPets(_ picker:UIPickerView){

        reference = Database.database().reference()
             let userID = Auth.auth().currentUser?.uid
        reference.child("usuarios").child(userID!).child("pets").observe(.value) { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let pet = snap.value as! [String: Any]
                let nome = pet["nome"] as! String
                     print(nome)
                let idade = pet["idade"] as! Int
                let porte = pet["porte"] as! String
                let raca = pet["raca"] as! String

                let historico:[Consulta] = []
                let petAux = Pet(nome,idade,porte,raca,historico)
                ArtemisDAO.petsAtuais.append(petAux)
                picker.reloadAllComponents()
            }

        }

    }

    func carregarEspecialidades(_ picker: UIPickerView){
       picker.reloadAllComponents()
    }

    func uploadImage(_ imageData: Data, _ path:String, _ tipo:String){

        let storageReference = Storage.storage().reference()
        let currentUser = Auth.auth().currentUser
        var profileImageRef:StorageReference?

        if tipo == "Pet"{
            profileImageRef = storageReference.child("users").child(currentUser!.uid).child("pets").child(path)
        } else if tipo == "Hospital"{
            profileImageRef = storageReference.child("hospitais").child(path).child("hospital.png")
        } else if tipo == "Perfil"{
            profileImageRef = storageReference.child("users").child(path).child("profile.png")
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

func downloadImage(_ path:String, _ tipo:String){

    let storageReference = Storage.storage().reference()
    let currentUser = Auth.auth().currentUser
    var profileImageRef:StorageReference?

    if tipo == "Pet"{
        profileImageRef = storageReference.child("users").child(currentUser!.uid).child("pets").child(path)
    } else if tipo == "Hospital"{
        profileImageRef = storageReference.child("hospitais").child(path).child("hospital.png")
    } else if tipo == "perfil"{
        profileImageRef = storageReference.child("users").child(currentUser!.uid).child("profile.png")
        print(profileImageRef)
    }


    profileImageRef?.getData(maxSize: 15 * 1024 * 1024) { data, error in
        if let error = error {
            // Uh-oh, an error occurred!
        } else {
            // Data for "images/island.jpg" is returned
            let image = UIImage(data: data!)
            print(image)
            if tipo == "perfil" || tipo == "hospital"{
               ArtemisDAO.imageProfile = image!
            } else if tipo == "Pet"{
              ArtemisDAO.petsImages.append(image!)
            }
        }
    }
}

    func buscarCoordenadas(_ mapa:MKMapView!){
        for i in 0 ... ArtemisDAO.hospitais.count-1{
            let location = ArtemisDAO.hospitais[i].busca?.components(separatedBy: "%")[1]
            let geocoder:CLGeocoder = CLGeocoder();

            geocoder.geocodeAddressString(location!){ (placemarks, error) in
                guard
                    let placemarks = placemarks,
                    let local = placemarks.first?.location

                    else {
                        // handle no location found
                        return
                }
                self.cordenadas.append((Double(local.coordinate.latitude), Double(local.coordinate.longitude)))


                if self.cordenadas.count == ArtemisDAO.hospitais.count && self.cordenadas.count > 0 {
                    self.setEmergencias(mapa)
                    self.medirDistancias()}
//                } else {
//                self.buscarCoordenadas(mapa)
//                }
            }

        }

    }

    func setEmergencias(_ mapa:MKMapView!){
        print("Setou")
        print(ArtemisDAO.emergencias.count)
        for i in 0...ArtemisDAO.emergencias.count-1{
            let anotacao = MKPointAnnotation()
            let coord = CLLocationCoordinate2D(latitude: self.cordenadas[i].x, longitude: self.cordenadas[i].y)
                anotacao.coordinate = coord
                anotacao.title = ArtemisDAO.hospitais[i].busca?.components(separatedBy: "%")[0]
                ArtemisDAO.mapaAtual.addAnnotation(anotacao)
        }

     
    }

    func medirDistancias() {
        for c in 0...cordenadas.count-1{
            let request = MKDirections.Request()

            request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: ArtemisDAO.posAtual.latitude, longitude: ArtemisDAO.posAtual.longitude), addressDictionary: nil))

            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: cordenadas[Int(c)].x, longitude: cordenadas[Int(c)].y), addressDictionary: nil))

            request.requestsAlternateRoutes = true
            request.transportType = .automobile

            let directions = MKDirections(request: request)

            direcoes.append(directions)

            if c == cordenadas.count-1 && c > 0{
                calcularRotas()
            }
        }
    }

    func calcularRotas(){
        var mkDirections = [MKDirections.Response]()
var cont = 0
        for n in 0 ... direcoes.count-1{
            direcoes[n].calculate { [unowned self] response, error in
                guard let unwrappedResponse = response else {
                    print("erro")
                    return
                }
                mkDirections.append(unwrappedResponse)

                if mkDirections.count == self.direcoes.count{
                    for l in 0...mkDirections.count-1{
                        var routes = mkDirections[l].routes
                        var menorRota = routes[0]
                        for s in 0...routes.count-1{
                            if routes[s].distance < menorRota.distance {
                                menorRota = routes[s]

                            }
                        }
                        if ArtemisDAO.hospitais[n].emergencia == "Sim"{
                            ArtemisDAO.emergenciasRotas.append(menorRota.distance)
                              print(" emergencia \(ArtemisDAO.emergenciasRotas[0])")
                        }

                        var limite:CLLocationDistance = 5000
                        if menorRota.distance < limite{
                            print("É PROXIMO")
                            print(ArtemisDAO.hospitais[n].nome!)
                            print(ArtemisDAO.hospitais.count)
                            ArtemisDAO.proximosRotas.append(menorRota.distance)

                        }

                        ArtemisDAO.hospitaisRotas.append(menorRota.distance)


                        var o = ArtemisDAO.hospitais.count
                        if  ArtemisDAO.hospitais.count == ArtemisDAO.hospitaisRotas.count && n > 0 {
                            self.definirLocais()
                        }
                    }
                }
            }
        }

    }

    func marcarConsulta(){
        let userID = Auth.auth().currentUser?.uid
        reference = Database.database().reference()
        let path = ArtemisDAO.consultaAux.codigo!
      
        
        let newConsulta = [
            "codigo": path,
            "medico": ArtemisDAO.consultaAux.medico,
            "data": ArtemisDAO.consultaAux.data,
            "hora": ArtemisDAO.consultaAux.hora,
            "local": ArtemisDAO.consultaAux.local,
            "descricao": ArtemisDAO.consultaAux.descricao,
            "especialidade": ArtemisDAO.consultaAux.especialidade,
            "pet": ArtemisDAO.consultaAux.pet
      ]
        
        if ArtemisDAO.medicUid != nil{
            self.reference.child("consultas").child(path).setValue(newConsulta)
        self.reference.child("medicos").child(ArtemisDAO.medicUid).child("consultas").child(ArtemisDAO.consultaAux.codigo!).setValue(path)
        }
   
    }
    
    func descobrirDoutor(){
        for i in 0...(ArtemisDAO.hospitalAtual?.espec_medic?.count)!-1{
            let slice = ArtemisDAO.hospitalAtual?.espec_medic![i].split(separator: "%")[1]
            let nome:String = String(slice!)
            if nome == ArtemisDAO.consultaAux.medico{
                let uid = ArtemisDAO.hospitalAtual?.espec_medic![i].split(separator: "%")[0]
                ArtemisDAO.medicUid = String(uid!)
                self.marcarConsulta()
            }
        }
    }

    func finalizarConsulta(_ diagnostico:String){
        _ = ArtemisDAO.consultaAtual!.codigo
    reference = Database.database().reference()
        self.reference.child("consultas").child(ArtemisDAO.consultaAtual!.codigo!).child("diagnostico").setValue(diagnostico)
    }



    func definirLocais(){
        var nome:String = ""
        var dist:String = ""
        for i in 0...ArtemisDAO.hospitais.count-1{
            nome = ArtemisDAO.hospitais[i].nome!

            dist = String((ArtemisDAO.hospitaisRotas[i] / 1000))
            ArtemisDAO.hospDist.append((dist,nome))
            print("\(dist) \(nome)")
        }


 }



}
