//
//  JSONDataViewProtocol.swift
//  
//
//  Created by Enes Karaosman on 27.11.2020.
//

import Foundation

internal protocol JSONDataViewProtocol: PresentableProtocol {

    var json: Data { get }
    var date: Date? { get }
    
    init(json: Data)
    init(json: Data, date: Date)
    
}
