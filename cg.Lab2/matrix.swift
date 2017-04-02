//
//  matrix.swift
//  cg.Lab2
//
//  Created by Vlad Krupenko on 12.12.16.
//  Copyright © 2016 fixique. All rights reserved.
//

import Foundation
import UIKit

extension String {
    subscript(index: Int) -> Character {
        let startIndex = self.index(self.startIndex, offsetBy: index)
        return self[startIndex]
    }
    
    subscript(range: CountableRange<Int>) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: range.lowerBound)
        let endIndex = self.index(startIndex, offsetBy: range.count)
        return self[startIndex..<endIndex]
    }
    
    subscript(range: CountableClosedRange<Int>) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: range.lowerBound)
        let endIndex = self.index(startIndex, offsetBy: range.count)
        return self[startIndex...endIndex]
    }
    
    subscript(range: NSRange) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: range.location)
        let endIndex = self.index(startIndex, offsetBy: range.length)
        return self[startIndex..<endIndex]
    }
}

class Matrix: NSObject  {
    
    internal var data:Array<Double>
    
    var rows: Int
    var columns: Int
    
    
    override var description: String {
        var d = ""
        
        for row in 0..<rows {
            for col in 0..<columns {
                
                let s = String(self[row,col])
                d += s + " "
                
            }
            d += "\n"
        }
        
        return d
    }
    
    init(_ data:Array<Double>, rows:Int, columns:Int) {
        self.data = data
        self.rows = rows
        self.columns = columns
    }
    
    init(rows:Int, columns:Int) {
        self.data = [Double](repeating: 0.0, count: rows*columns)
        self.rows = rows
        self.columns = columns
    }
    
    subscript(row: Int, col: Int) -> Double {
        get {
            precondition(row >= 0 && col >= 0 && row < self.rows && col < self.columns, "Index out of bounds")
            return data[(row * columns) + col]
        }
        
        set {
            precondition(row >= 0 && col >= 0 && row < self.rows && col < self.columns, "Index out of bounds")
            self.data[(row * columns) + col] = newValue
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Matrix {
        let m = Matrix(self.data, rows:self.rows, columns:self.columns)
        return m;
    }
    
    func row(index: Int) -> [Double] {
        var r = [Double]()
        for col in 0..<columns {
            r.append(self[index,col])
        }
        
        return r
    }
    
    func col(index: Int) -> [Double] {
        var c = [Double]()
        for row in 0..<rows {
            c.append(self[row,index])
        }
        
        return c
    }
    
    func clear() {
        self.data = [Double](repeating: 0.0, count: self.rows * self.columns)
        self.rows = 0
        self.columns = 0
    }
    
    func ProjectOrt(type: Int, D: Double) -> Matrix {
        
        var temp = Matrix(rows: self.rows, columns: 3)
        
            if (type < 3) {
            
                var scaleMatrix = Matrix(rows: 3, columns: 4)
        
                switch type {
                case 0: //yz
                    scaleMatrix = Matrix([0,1,0,0,0,0,1,0,0,0,0,1] ,rows: 3, columns: 4)
                case 1: //xz
                    scaleMatrix = Matrix([1,0,0,0,0,0,1,0,0,0,0,1] ,rows: 3, columns: 4)
                case 2: //xy
                    scaleMatrix = Matrix([1,0,0,0,0,1,0,0,0,0,0,1],rows: 3, columns: 4)
                default:
                    scaleMatrix = Matrix([1, 0, 0, 0, 1, 0, 0, 0, 1] ,rows: 3, columns: 3)
                }
        
                for i in 0..<self.rows {
                    let tempVector = scaleMatrix * Matrix(self.row(index: i) ,rows: 4, columns: 1)
                    for k in 0..<temp.columns {
                        temp[i,k] = tempVector[k,0]
                    }
                }
        
            
                print("rrr\n  \(temp)")
        
                return temp
            
            } else {
                temp = projectionPercpective(type: type, D: D)
            }
        
        return temp;
    }
    
    func projectionPercpective(type: Int, D: Double) -> Matrix {
        let temp = Matrix(rows: self.rows, columns: 3)
        
        var scaleMatrix = Matrix(rows: 3, columns: 4)
        
        switch type {
        case 3: //yz
            scaleMatrix = Matrix([0,1,0,0,0,0,1,0,(-1/D),0,0,1] ,rows: 3, columns: 4)
        case 4: //xz
            scaleMatrix = Matrix([1,0,0,0,0,0,1,0,0,(-1/D),0,1] ,rows: 3, columns: 4)
        case 5: //xy
            scaleMatrix = Matrix([1,0,0,0,0,1,0,0,0,0,(-1/D),1],rows: 3, columns: 4)
        default:
            scaleMatrix = Matrix([1, 0, 0, 0, 1, 0, 0, 0, 1] ,rows: 3, columns: 3)
        }
        
        for i in 0..<self.rows {
            let tempVector = scaleMatrix * Matrix(self.row(index: i) ,rows: 4, columns: 1)
            for k in 0..<temp.columns {
                temp[i,k] = tempVector[k,0]
            }
        }
        
        print("rrr\n  \(temp)")
        
        return temp

    }
    
    
    // Поворот с углом
    
    
    func rotate(angle: Double, typeO: Int, typeS: Bool) {
        let temp = Matrix(self.data, rows: self.rows, columns: self.columns)
        var rotationMatrix = Matrix(rows: 4, columns: 4)
        
        switch typeO {
        case 0:
            if (typeS){
                rotationMatrix = Matrix([1,0,0,0,0,cos(angle * M_PI / 180),-sin(angle * M_PI / 180),0,0,sin(angle * M_PI / 180),cos(angle * M_PI / 180),0,0,0,0,1], rows: 4, columns: 4)
            } else {
                rotationMatrix = Matrix([1,0,0,0,0,cos(angle * M_PI / 180),sin(angle * M_PI / 180),0,0,-sin(angle * M_PI / 180),cos(angle * M_PI / 180),0,0,0,0,1], rows: 4, columns: 4)
            }
        case 1:
            if(typeS){
                rotationMatrix = Matrix([cos(angle * M_PI / 180),0,sin(angle * M_PI / 180),0,0,1,0,0,-sin(angle * M_PI / 180),0,cos(angle * M_PI / 180),0,0,0,0,1], rows: 4, columns: 4)
            } else {
                rotationMatrix = Matrix([cos(angle * M_PI / 180),0,-sin(angle * M_PI / 180),0,0,1,0,0,sin(angle * M_PI / 180),0,cos(angle * M_PI / 180),0,0,0,0,1], rows: 4, columns: 4)
            }
        case 2:
            if (typeS) {
                rotationMatrix = Matrix([cos(angle * M_PI / 180),-sin(angle * M_PI / 180),0,0,sin(angle * M_PI / 180),cos(angle * M_PI / 180),0,0,0,0,1,0,0,0,0,1],rows: 4, columns: 4)
            } else {
                rotationMatrix = Matrix([cos(angle * M_PI / 180),sin(angle * M_PI / 180),0,0,-sin(angle * M_PI / 180),cos(angle * M_PI / 180),0,0,0,0,1,0,0,0,0,1],rows: 4, columns: 4)
            }
        default:
            rotationMatrix = Matrix([1, 0, 0, 0, 1, 0, 0, 0, 1] ,rows: 3, columns: 3)
        }
        
        for i in 0..<self.rows {
            let tempVector = rotationMatrix * Matrix(temp.row(index: i) ,rows: 4, columns: 1)
            for k in 0..<self.columns {
                temp[i,k] = tempVector[k,0]
            }
        }
        
        self.data = temp.data
    }
    
    
    func rotate(CosI: Double, SinI: Double, typeO: Int, typeS: Bool) {
        let temp = Matrix(self.data, rows: self.rows, columns: self.columns)
        var rotationMatrix = Matrix(rows: 4, columns: 4)
        
        switch typeO {
        case 0:
            if (typeS){
                rotationMatrix = Matrix([1,0,0,0,0,CosI,-SinI,0,0,SinI,CosI,0,0,0,0,1], rows: 4, columns: 4)
            } else {
                rotationMatrix = Matrix([1,0,0,0,0,CosI,SinI,0,0,-SinI,CosI,0,0,0,0,1], rows: 4, columns: 4)
            }
        case 1:
            if(typeS){
                rotationMatrix = Matrix([CosI,0,SinI,0,0,1,0,0,-SinI,0,CosI,0,0,0,0,1], rows: 4, columns: 4)
            } else {
                rotationMatrix = Matrix([CosI,0,-SinI,0,0,1,0,0,SinI,0,CosI,0,0,0,0,1], rows: 4, columns: 4)
            }
        case 2:
            if (typeS) {
                rotationMatrix = Matrix([CosI,-SinI,0,0,SinI,CosI,0,0,0,0,1,0,0,0,0,1],rows: 4, columns: 4)
            } else {
                rotationMatrix = Matrix([CosI,SinI,0,0,-SinI,CosI,0,0,0,0,1,0,0,0,0,1],rows: 4, columns: 4)
            }
        default:
            rotationMatrix = Matrix([1, 0, 0, 0, 1, 0, 0, 0, 1] ,rows: 3, columns: 3)
        }
        
        for i in 0..<self.rows {
            let tempVector = rotationMatrix * Matrix(temp.row(index: i) ,rows: 4, columns: 1)
            for k in 0..<self.columns {
                temp[i,k] = tempVector[k,0]
            }
        }
        
        self.data = temp.data
    }
    
    
    
    func transfer(vector: Matrix) {
        precondition(vector.rows == 3 || vector.columns == 1, "Type vector is wrong!")
        
        let transferMatrix = Matrix([1,0,0,vector[0,0],0,1,0,vector[1,0],0,0,1,vector[2,0],0,0,0,1],rows: 4, columns: 4)
        let temp = Matrix(self.data, rows: self.rows, columns: self.columns)
        
        for i in 0..<self.rows {
            let tempVector = transferMatrix * Matrix(temp.row(index: i) ,rows: 4, columns: 1)
            for k in 0..<self.columns {
                temp[i,k] = tempVector[k,0]
            }
        }
        
        self.data = temp.data
    }
    
    func scale(type: Int, scale: Double) {
        let temp = Matrix(self.data, rows: self.rows, columns: self.columns)
        var scaleMatrix = Matrix(rows: 3, columns: 3)
        
        switch type {
        case 0:
            scaleMatrix = Matrix([scale,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1] ,rows: 4, columns: 4)
        case 1:
            scaleMatrix = Matrix([1,0,0,0,0,scale,0,0,0,0,1,0,0,0,0,1] ,rows: 4, columns: 4)
        case 2:
            scaleMatrix = Matrix([scale,0,0,0,0,scale,0,0,0,0,1,0,0,0,0,1] ,rows: 4, columns: 4)
        default:
            scaleMatrix = Matrix([1, 0, 0, 0, 1, 0, 0, 0, 1] ,rows: 3, columns: 3)
        }
        
        for i in 0..<self.rows {
            let tempVector = scaleMatrix * Matrix(temp.row(index: i) ,rows: 4, columns: 1)
            for k in 0..<self.columns {
                temp[i,k] = tempVector[k,0]
            }
        }
        
        self.data = temp.data
    }

    
    func transferBack(vector: Matrix) -> Matrix {
        //Исправить на две координаты в векторе декартовых
        precondition(vector.rows == 2 || vector.columns == 1, "Type vector is wrong!")
        
        let transferMatrix = Matrix([1,0,vector[0,0],0,1,vector[1,0],0,0,1],rows: 3, columns: 3)
        let temp = Matrix(self.data, rows: self.rows, columns: self.columns)
        
        for i in 0..<self.rows {
            let tempVector = transferMatrix * Matrix(temp.row(index: i) ,rows: 3, columns: 1)
            for k in 0..<self.columns {
                temp[i,k] = tempVector[k,0]
            }
        }
        
        return temp
    }
    
    
    func rotate(angle: Double, rotationDirection: Bool) {
        
        if (rotationDirection) {
            let rotationMatrix = Matrix([(cos(angle * M_PI / 180)),-sin(angle * M_PI / 180), 0, sin(angle * M_PI / 180) , cos(angle * M_PI / 180), 0, 0, 0, 1] ,rows: 3, columns: 3)
            let temp = Matrix(self.data, rows: self.rows, columns: self.columns)
            
            for i in 0..<self.rows {
                let tempVector = rotationMatrix * Matrix(temp.row(index: i) ,rows: 3, columns: 1)
                for k in 0..<self.columns {
                    temp[i,k] = tempVector[k,0]
                }
            }
            
            self.data = temp.data
            
        } else {
            let rotationMatrix = Matrix([(cos(angle * M_PI / 180)),sin(angle * M_PI / 180), 0, -sin(angle * M_PI / 180) , cos(angle * M_PI / 180), 0, 0, 0, 1] ,rows: 3, columns: 3)
            let temp = Matrix(self.data, rows: self.rows, columns: self.columns)
            
            for i in 0..<self.rows {
                let tempVector = rotationMatrix * Matrix(temp.row(index: i) ,rows: 3, columns: 1)
                for k in 0..<self.columns {
                    temp[i,k] = tempVector[k,0]
                }
            }
            
            self.data = temp.data
            
        }
        
    }
    
    func rotate(cosI: Double, sinI: Double, rotationDirection: Bool) {
        if (rotationDirection) {
            let rotationMatrix = Matrix([cosI,-sinI, 0,sinI, cosI, 0, 0, 0, 1] ,rows: 3, columns: 3)
            let temp = Matrix(self.data, rows: self.rows, columns: self.columns)
            
            for i in 0..<self.rows {
                let tempVector = rotationMatrix * Matrix(temp.row(index: i) ,rows: 3, columns: 1)
                for k in 0..<self.columns {
                    temp[i,k] = tempVector[k,0]
                }
            }
            
            self.data = temp.data
            
        } else {
            let rotationMatrix = Matrix([cosI,sinI, 0,-sinI, cosI, 0, 0, 0, 1] ,rows: 3, columns: 3)
            let temp = Matrix(self.data, rows: self.rows, columns: self.columns)
            
            for i in 0..<self.rows {
                let tempVector = rotationMatrix * Matrix(temp.row(index: i) ,rows: 3, columns: 1)
                for k in 0..<self.columns {
                    temp[i,k] = tempVector[k,0]
                }
            }
            
            self.data = temp.data
            
        }
    }
    
    func rotatePoint(angle: Double, rotationDirection: Bool, point: Int) {
        
        if (rotationDirection) {
            
            let temp = Matrix(self.data, rows: self.rows, columns: self.columns)
            
            let pointone = temp[point,0]
            let pointtwo = temp[point,1]
            
            
            
            temp.transfer(vector: Matrix([pointone * (-1),pointtwo * (-1)], rows: 3, columns: 1))
            print("\(temp)")
            temp.rotate(angle: 5, rotationDirection: true)
            print("\(temp)")
            temp.transfer(vector: Matrix([pointone,pointtwo], rows: 3, columns: 1))
            
            
            
            self.data = temp.data
            
        }
    }
    
    
    func reflect(type: Int) {
        let temp = Matrix(self.data, rows: self.rows, columns: self.columns)
        var reflectMatrix = Matrix(rows: 3, columns: 3)
        
        switch type {
        case 0: //xOz
            reflectMatrix = Matrix([1,0,0,0,
                                    0,-1,0,0,
                                    0,0,1,0,
                                    0,0,0,1] ,rows: 4, columns: 4)
        case 1: //yOz
            reflectMatrix = Matrix([-1,0,0,0,
                                    0,1,0,0,
                                    0,0,1,0,
                                    0,0,0,1] ,rows: 4, columns: 4)
        case 2: //xOy
            reflectMatrix = Matrix([1,0,0,0,
                                    0,1,0,0,
                                    0,0,-1,0,
                                    0,0,0,1] ,rows: 4, columns: 4)
        default:
            reflectMatrix = Matrix([1, 0, 0, 0, 1, 0, 0, 0, 1] ,rows: 3, columns: 3)
        }
        
        for i in 0..<self.rows {
            let tempVector = reflectMatrix * Matrix(temp.row(index: i) ,rows: 4, columns: 1)
            for k in 0..<self.columns {
                temp[i,k] = tempVector[k,0]
            }
        }
        
        self.data = temp.data
        
    }
    
    func reflectBySide(P0: Int, P1: Int, P2: Int) {
        let temp = Matrix(self.data, rows: self.rows, columns: self.columns)
        
        let X0 = temp[P0,0]
        let Y0 = temp[P0,1]
        let Z0 = temp[P0,2]
        
        let X1 = temp[P1,0]
        let Y1 = temp[P1,1]
        let Z1 = temp[P1,2]
        
        let X2 = temp[P2,0]
        let Y2 = temp[P2,1]
        let Z2 = temp[P2,2]
        
        let NX1 = X1 - X0
        let NY1 = Y1 - Y0
        let NZ1 = Z1 - Z0
        
        let NX2 = X2 - X0
        let NY2 = Y2 - Y0
        let NZ2 = Z2 - Z0
        
        let X = ((NY1 * NZ2) - (NY2 * NZ1))
        let Y = -((NX1 * NZ2) - (NX2 * NZ1))
        let Z = ((NX1 * NY2) - (NX2 * NY1))
        
        let R1 = sqrt(pow(X, 2) + pow(Y, 2))
        let R2 = sqrt(pow(R1, 2) + pow(Z, 2))
        
        
            
            let COS1 = Y / R1
            let SIN1 = X / R1
            let COS2 = R1 / R2
            let SIN2 = Z / R2
            
            
            temp.transfer(vector: Matrix([-X0, -Y0, -Z0], rows: 3, columns: 1))
            print("\(temp)")
            temp.rotate(CosI: COS1, SinI: SIN1, typeO: 2, typeS: true)
            temp.rotate(CosI: COS2, SinI: SIN2, typeO: 0, typeS: false)
            temp.reflect(type: 0)
            temp.rotate(CosI: COS2, SinI: SIN2, typeO: 0, typeS: true)
            temp.rotate(CosI: COS1, SinI: SIN1, typeO: 2, typeS: false)
            temp.transfer(vector: Matrix([X0, Y0, Z0], rows: 3, columns: 1))
            
        
        
        
        self.data = temp.data
        
        
    }
    
    
    //2 3
    func reflectBrink(point1: Int, point2: Int) {
        let temp = Matrix(self.data, rows: self.rows, columns: self.columns)
        
        let pointonex = temp[point1,0]
        let pointoney = temp[point1,1]
        
        
        temp.transfer(vector: Matrix([pointonex * (-1),pointoney * (-1)], rows: 3, columns: 1))
        print("\(temp)")
        let pointtwox = temp[point2,0]
        let pointtwoy = temp[point2,1]
        let sinAng = pointtwox / (sqrt(pow(pointtwox, 2) + pow(pointtwoy,2)))
        let cosAng = pointtwoy / (sqrt(pow(pointtwox, 2) + pow(pointtwoy,2)))
        
        temp.rotate(cosI: cosAng, sinI: sinAng, rotationDirection: true)
        print("\(temp)")
        temp.reflect(type: 0)
        print("\(temp)")
        temp.rotate(cosI: cosAng, sinI: sinAng, rotationDirection: false)
        print("\(temp)")
        temp.transfer(vector: Matrix([pointonex,pointoney], rows: 3, columns: 1))
        print("\(temp)")
        
        
        self.data = temp.data
        
    }
    
    
}







// Matrix Operations


func +(left: Matrix, right: Matrix) -> Matrix {
    
    precondition(left.rows == right.rows && left.columns == right.columns)
    
    let m = Matrix(left.data, rows: left.rows, columns: left.columns)
    
    for row in 0..<left.rows {
        for col in 0..<left.columns {
            m[row,col] += right[row,col]
        }
    }
    
    return m
}

func -(left: Matrix, right: Matrix) -> Matrix {
    
    precondition(left.rows == right.rows && left.columns == right.columns)
    
    let m = Matrix(left.data, rows: left.rows, columns: left.columns)
    
    for row in 0..<left.rows {
        for col in 0..<left.columns {
            m[row,col] -= right[row,col]
        }
    }
    
    return m
}

func *(left: Matrix, right: Double) -> Matrix {
    let m = Matrix(left.data, rows: left.rows, columns: left.columns)
    
    for row in 0..<left.rows {
        for col in 0..<left.columns {
            m[row,col] *= right
        }
    }
    
    return m
}

func *(left: Double, right:Matrix) -> Matrix {
    let m = Matrix(right.data, rows: right.rows, columns: right.columns)
    
    for row in 0..<right.rows {
        for col in 0..<right.columns {
            m[row,col] *= left
        }
    }
    
    return m
}


func *(left: Matrix, right: Matrix) -> Matrix {
    
    var lcp = left.copy()
    var rcp = right.copy();
    
    if (lcp.rows == 1 && rcp.rows == 1) && (lcp.columns == rcp.columns) { // exception for single row matrices (inspired by numpy)
        rcp = rcp^
    }
    else if (lcp.columns == 1 && rcp.columns == 1) && (lcp.rows == rcp.rows) { // exception for single row matrices (inspired by numpy)
        lcp = lcp^
    }
    
    precondition(lcp.columns == rcp.rows, "Matrices cannot be multipied")
    
    let dot = Matrix(rows:lcp.rows, columns:rcp.columns)
    
    for rindex in 0..<lcp.rows {
        
        for cindex in 0..<rcp.columns {
            
            let a = lcp.row(index: rindex) ** rcp.col(index: cindex)
            dot[rindex,cindex] = a
        }
    }
    
    return dot
    
    
    
}

// transpose
postfix operator ^

postfix func ^(m:Matrix) -> Matrix {
    
    let transposed = Matrix(rows:m.columns, columns:m.rows)
    
    for row in 0..<m.rows {
        
        for col in 0..<m.columns {
            
            transposed[col,row] = m[row,col]
        }
        
        
    }
    return transposed
}

infix operator **

func **(left:[Double], right:[Double]) -> Double {
    
    
    var d : Double = 0
    for i in 0..<left.count {
        d += left[i] * right[i]
    }
    return d
}
