//
//  User.swift
//  Artemis
//
//  Created by PUCPR on 10/04/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import Foundation

class User {
    var nome: String?
    var email: String?
    var telefone: String?
    var cpf: String?
    var uid: String?
    
    init(_ nome:String, _ email:String, _ telefone:String,_ cpf:String ,_ uid:String) {
        self.email = email
        self.nome = nome
        self.telefone = telefone
        self.cpf = cpf
        self.uid = uid
    }
}
