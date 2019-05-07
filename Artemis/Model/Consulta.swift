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
    
    init(_ codigo:String, _ medico:String, _ hora:String, _ data:String, _ local:String, _ descricao:String) {
        self.codigo = codigo
        self.medico = medico
        self.hora = hora
        self.data = data
        self.local = local
        self.descricao = descricao
    }
}
