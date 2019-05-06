//
//  Extensions.swift
//  Ticket
//
//  Created by Cameron Dunn on 5/6/19.
//  Copyright © 2019 Cameron Dunn. All rights reserved.
//

import Foundation

extension Array{
    mutating func appendAtBeginning(newItem: Element){
        let copy = self
        self = []
        self.append(newItem)
        self.append(contentsOf: copy)
    }
}

