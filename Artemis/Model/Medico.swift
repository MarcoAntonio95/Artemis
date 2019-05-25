//
//  Medico.swift
//  Artemis
//
//  Created by ALUNO on 03/05/2019.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import Foundation

class Medico {
    var hospital:String?
    var nome:String?
    var especialidade:String?
    var crmv:String?
    var telefone:String?
    var consultas:[String]?

    init(_ hospital:String, _ nome:String, _ especialidade:String, _ crmv:String, _ telefone:String) {
        self.hospital = hospital
        self.nome = nome
        self.especialidade = especialidade
        self.crmv = crmv
        self.telefone = telefone
    }

    init(_ hospital:String, _ nome:String, _ especialidade:String, _ crmv:String, _ telefone:String, _ consultas:[String]) {
        self.hospital = hospital
        self.nome = nome
        self.especialidade = especialidade
        self.crmv = crmv
        self.telefone = telefone
        self.consultas = consultas
    }
}
