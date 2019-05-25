
import Foundation
class Pet {
    var nome:String?
    var idade:Int?
    var porte:String?
    var raca:String?
    var historico:[Consulta]?
    
    init() {
    }
    
    
    init(_ nome:String,_ idade:Int,_ porte:String,_ raca:String,_ historico:[Consulta]) {
        self.nome = nome
        self.idade = idade
        self.porte = porte
        self.raca = raca
        self.historico = historico
    }
}
