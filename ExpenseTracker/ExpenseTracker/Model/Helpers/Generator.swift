//
//  Generator.swift
//  ExpenseTracker
//
//  Created by Mina Milosavljevic on 10/16/20.
//  Copyright © 2020 Mina Milosavljevic. All rights reserved.
//

import UIKit

struct Generator {
    
    static func generateRandomColors(numbersOfColor: Int) -> [UIColor] {
        var currentSetOfColors: [UIColor] = []
        for _ in 0..<numbersOfColor {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            currentSetOfColors.append(color)
        }
        return currentSetOfColors
    }
}
