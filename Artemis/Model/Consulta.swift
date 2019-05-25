//
//  Consulta.swift
//  Artemis
//
//  Created by ALUNO on 03/05/2019.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import Foundation

class Consulta{
    var codigo:String?
    var medico:String?
    var hora:String?
    var data:String?
    var local:String?
    var descricao:String?
    var especialidade:String?
    var pet:String?
    
    init() {
    }
    
    init(_ codigo:String, _ medico:String, _ hora:String, _ data:String, _ local:String,_ especialidade:String, _ descricao:String, _ pet:String) {
        self.codigo = codigo
        self.medico = medico
        self.hora = hora
        self.data = data
        self.local = local
        self.especialidade = especialidade
        self.descricao = descricao
        self.pet = pet
    }
    
}
