//
//  Extensions.swift
//  FlatironSchool
//
//  Created by Matt Isaacs on 10/30/16.
//  Copyright © 2016 Ustwo. All rights reserved.
//

import Foundation

extension Array {
    mutating func swap(indexA: Int, indexB: Int) {
        let tmp = self[indexA]
        self[indexA] = self[indexB]
        self[indexB] = tmp
    }
}
