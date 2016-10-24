//
//  GraphView.swift
//  Calculator
//
//  Created by martin almaraz on 10/23/16.
//  Copyright © 2016 Martin Almaraz. All rights reserved.
//

import UIKit

protocol GraphViewCal: class {
    func yByX(_ x: Double) -> Double?
}

@IBDesignable
class GraphView: UIView {
    
    var snapShot: UIView? = nil
    
    weak var graphView = GraphViewCal?
    

}
