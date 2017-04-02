//
//  ViewController.swift
//  cg.Lab2
//
//  Created by Vlad Krupenko on 12.12.16.
//  Copyright © 2016 fixique. All rights reserved.
//

import UIKit

/*
0, 0, 0,
0, 100, 0,
100, 100, 0,
100, 0, 0,
150, 50, -50,
150, 150, -50,
50, 150, -50,
50 ,50, -50
*/
class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    let zeroCordX: Double = 512
    let zeroCordY: Double = 345
    let u: Double = 1.0
    var typeProjection = 5
    var typePerspective: Double = 512
    /*
    var vertex = Matrix([0,0,0,
                         0,100,-100,
                         10,100,-100,
                         10,0,-10,
                         90,0,-10,
                         90,100,100,
                         90,90,100,
                         90,80,100,
                         90,0,0,
                         0,-10,0,
                         0,-10,-10,
                         0,90,-100,
                         10,90,-100,
                         10,-10,-10,
                         100,-10,-10,
                         100,100,100,
                         100,90,100,
                         100,0,0],rows: 18, columns: 3)
    let relations = Matrix([0,1,
                            1,2,
                            2,3,
                            3,4,
                            4,5,
                            5,6,
                            7,8,
                            8,0,
                            0,9,
                            9,10,
                            10,11,
                            11,12,
                            12,13,
                            13,14,
                            14,15,
                            15,16,
                            16,17,
                            17,9,
                            14,17], rows: 19, columns: 2)
    //var vertex = Matrix([0, 0, 0 , 100, 100, 100, 100, 0], rows: 4, columns: 2)
    //let relations = Matrix([0,1,1,2,2,3,3,0], rows: 4, columns: 2)
    
    var vertex: Matrix = Matrix([0, 0, 0,
                                 0, 100, 0,
                                 100, 100, 0,
                                 100, 0, 0,
                                 100, 0, -100,
                                 100, 100, -100,
                                 0, 100, -100,
                                 0 ,0, -100], rows: 8, columns: 3)
    var relations: Matrix = Matrix([0,1,1,2,2,3,3,0,0,7,7,4,4,3,2,5,5,6,6,1,5,4,6,7], rows: 12, columns: 2)
 
    */
    var vertex: Matrix = Matrix([0,0,0,
                                 0,120,0,
                                 40,120,0,
                                 80,80,0,
                                 120,120,0,
                                 160,120,0,
                                 160,0,0,
                                 120,0,0,
                                 120,80,0,
                                 80,40,0,
                                 40,80,0,
                                 40,0,0,//
                                 0,0,-30,
                                 0,120,-30,
                                 40,120,-30,
                                 80,80,-30,
                                 120,120,-30,
                                 160,120,-30,
                                 160,0,-30,
                                 120,0,-30,
                                 120,80,-30,
                                 80,40,-30,
                                 40,80,-30,
                                 40,0,-30
                                 ], rows: 24, columns: 3)
    var relations: Matrix = Matrix([0,1,
                                    1,2,
                                    2,3,
                                    3,4,
                                    4,5,
                                    5,6,
                                    6,7,
                                    7,8,
                                    8,9,
                                    9,10,
                                    10,11,
                                    11,0,
                                    0,12,
                                    12,13,
                                    13,14,
                                    14,15,
                                    15,16,
                                    16,17,
                                    17,18,
                                    18,19,
                                    19,20,
                                    20,21,
                                    21,22,
                                    22,23,
                                    23,12,
                                    11,23,
                                    1,13,
                                    2,14,
                                    3,15,
                                    4,16,
                                    5,17,
                                    6,18,
                                    7,19,
                                    8,20,
                                    9,21,
                                    10,22], rows: 36, columns: 2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\(vertex)")
        
        vertex = convertCoord(points: vertex)
        print("\(vertex)")
        drawFigure(points: vertex.ProjectOrt(type: typeProjection, D: typePerspective), relations: relations)

    
    }
// отражение относительно грани 
    @IBAction func yzProjection(_ sender: AnyObject) {
        typeProjection = 0
        drawFigure(points: vertex.ProjectOrt(type: typeProjection, D: typePerspective), relations: relations)
    }
    
    @IBAction func xzProjection(_ sender: AnyObject) {
        typeProjection = 1
        drawFigure(points: vertex.ProjectOrt(type: typeProjection, D: typePerspective), relations: relations)
    }
    
    @IBAction func xyProjection(_ sender: AnyObject) {
        typeProjection = 2
        drawFigure(points: vertex.ProjectOrt(type: typeProjection, D: typePerspective), relations: relations)
    }
    
    @IBAction func pYZ(_ sender: AnyObject) {
        typeProjection = 3
        drawFigure(points: vertex.ProjectOrt(type: typeProjection, D: typePerspective), relations: relations)
    }
    
    @IBAction func pXZ(_ sender: AnyObject) {
        typeProjection = 4
        drawFigure(points: vertex.ProjectOrt(type: typeProjection, D: typePerspective), relations: relations)
    }
    
    @IBAction func pXY(_ sender: AnyObject) {
        typeProjection = 5
        drawFigure(points: vertex.ProjectOrt(type: typeProjection, D: typePerspective), relations: relations)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func transferUp(_ sender: AnyObject) {
        vertex.transfer(vector: Matrix([0,10,0], rows: 3, columns: 1))
        print("\(vertex)")
        drawFigure(points: vertex.ProjectOrt(type: typeProjection, D: typePerspective), relations: relations)
    }
    
    @IBAction func transferDown(_ sender: AnyObject) {
        vertex.transfer(vector: Matrix([0,-10,0], rows: 3, columns: 1))
        print("\(vertex)")
        drawFigure(points: vertex.ProjectOrt(type: typeProjection, D: typePerspective), relations: relations)
    }
    
    @IBAction func transferRight(_ sender: AnyObject) {
        vertex.transfer(vector: Matrix([10,0,0], rows: 3, columns: 1))
        print("\(vertex)")
        drawFigure(points: vertex.ProjectOrt(type: typeProjection, D: typePerspective), relations: relations)
    }
    
    @IBAction func transferLeft(_ sender: AnyObject) {
        vertex.transfer(vector: Matrix([-10,0,0], rows: 3, columns: 1))
        print("\(vertex)")
        drawFigure(points: vertex.ProjectOrt(type: typeProjection, D: typePerspective), relations: relations)
    }
    
    @IBAction func transferForward(_ sender: AnyObject) {
        vertex.transfer(vector: Matrix([0,0,10], rows: 3, columns: 1))
    
        print("\(vertex)")
        drawFigure(points: vertex.ProjectOrt(type: typeProjection, D: typePerspective), relations: relations)

    }
    
    @IBAction func transferBack(_ sender: AnyObject) {
        vertex.transfer(vector: Matrix([0,0,-10], rows: 3, columns: 1))
        
        print("\(vertex)")
        drawFigure(points: vertex.ProjectOrt(type: typeProjection, D: typePerspective), relations: relations)
    }
    
    @IBAction func oxRotationBack(_ sender: AnyObject) {
        vertex.rotate(angle: 5, typeO: 0, typeS: true)
        
        drawFigure(points: vertex.ProjectOrt(type: typeProjection, D: typePerspective), relations: relations)
    }
    
    @IBAction func oxRotationForward(_ sender: AnyObject) {
        vertex.rotate(angle: 5, typeO: 0, typeS: false)
        print("\(vertex)")
        drawFigure(points: vertex.ProjectOrt(type: typeProjection, D: typePerspective), relations: relations)
    }
    
    @IBAction func oyRotationBack(_ sender: AnyObject) {
        vertex.rotate(angle: 5, typeO: 1, typeS: true)
        print("\(vertex)")
        drawFigure(points: vertex.ProjectOrt(type: typeProjection, D: typePerspective), relations: relations)
    }
    
    @IBAction func oyRotationForward(_ sender: AnyObject) {
        vertex.rotate(angle: 5, typeO: 1, typeS: false)
        print("\(vertex)")
        drawFigure(points: vertex.ProjectOrt(type: typeProjection, D: typePerspective), relations: relations)
    }
    
    @IBAction func ozRotationForward(_ sender: AnyObject) {
        vertex.rotate(angle: 5, typeO: 2, typeS: true)
        print("\(vertex)")
        drawFigure(points: vertex.ProjectOrt(type: typeProjection, D: typePerspective), relations: relations)
    }
    
    @IBAction func ozRotationBack(_ sender: AnyObject) {
        vertex.rotate(angle: 5, typeO: 2, typeS: false)
        print("\(vertex)")
        drawFigure(points: vertex.ProjectOrt(type: typeProjection, D: typePerspective), relations: relations)
    }
    
    @IBAction func xScale(_ sender: AnyObject) {
        vertex.scale(type: 0, scale: 1.25)
        print("\(vertex)")
        drawFigure(points: vertex.ProjectOrt(type: typeProjection, D: typePerspective), relations: relations)
    }
    
    @IBAction func xScaleMin(_ sender: AnyObject) {
        vertex.scale(type: 0, scale: 0.75)
        print("\(vertex)")
        drawFigure(points: vertex.ProjectOrt(type: typeProjection, D: typePerspective), relations: relations)
    }
    
    @IBAction func yScale(_ sender: AnyObject) {
        vertex.scale(type: 1, scale: 1.25)
        print("\(vertex)")
        drawFigure(points: vertex.ProjectOrt(type: typeProjection, D: typePerspective), relations: relations)
    }
    
    @IBAction func yScaleMin(_ sender: AnyObject) {
        vertex.scale(type: 1, scale: 0.75)
        print("\(vertex)")
        drawFigure(points: vertex.ProjectOrt(type: typeProjection, D: typePerspective), relations: relations)
    }
    
    @IBAction func xyScale(_ sender: AnyObject) {
        vertex.scale(type: 2, scale: 1.25)
        print("\(vertex)")
        drawFigure(points: vertex.ProjectOrt(type: typeProjection, D: typePerspective), relations: relations)
    }
    
    @IBAction func xyScaleMin(_ sender: AnyObject) {
        vertex.scale(type: 2, scale: 0.75)
        print("\(vertex)")
        drawFigure(points: vertex.ProjectOrt(type: typeProjection, D: typePerspective), relations: relations)
    }
    
    @IBAction func reflectXOZ(_ sender: AnyObject) {
        vertex.reflect(type: 0)
        print("\(vertex)")
        drawFigure(points: vertex.ProjectOrt(type: typeProjection, D: typePerspective), relations: relations)
    }
    
    @IBAction func reflectYOZ(_ sender: AnyObject) {
        vertex.reflect(type: 1)
        print("\(vertex)")
        drawFigure(points: vertex.ProjectOrt(type: typeProjection, D: typePerspective), relations: relations)
    }
    
    @IBAction func reflectXOY(_ sender: AnyObject) {
        vertex.reflect(type: 2)
        print("\(vertex)")
        drawFigure(points: vertex.ProjectOrt(type: typeProjection, D: typePerspective), relations: relations)
    }
    
    @IBAction func reflectBySide(_ sender: AnyObject) {
        vertex.reflectBySide(P0: 2, P1: 3, P2: 14)
        print("\(vertex)")
        drawFigure(points: vertex.ProjectOrt(type: typeProjection, D: typePerspective), relations: relations)
    }
    
    func drawFigure(points: Matrix, relations: Matrix) {
        
        let decPoints = convertToDec(points: points)
        print("\(decPoints)")
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1024, height: 691), false, 0)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setLineWidth(3.0)
        context.setFillColor(UIColor.purple.cgColor)
        context.setStrokeColor(UIColor.purple.cgColor)
        
        //убрать цикл по К
        for i in 0..<relations.rows {
            
            context.move(to: CGPoint(x: (decPoints[Int(relations[i,0]),0] + zeroCordX), y: zeroCordY - (decPoints[Int(relations[i,0]),1] )))
            context.addLine(to: CGPoint(x: (decPoints[Int(relations[i,1]),0] + zeroCordX), y: zeroCordY - (decPoints[Int(relations[i,1]),1])))
            
        }
        
        
        context.drawPath(using: .fillStroke)
        
        
        let img = UIGraphicsGetImageFromCurrentImageContext() // Получившийся рисунок присваеваем константе
        UIGraphicsEndImageContext() // Заканчиваем функцию отрисовки
        
        imageView.image = img
    }

    func convertCoord(points: Matrix) -> Matrix {
        
        let resultM = Matrix(rows: points.rows, columns: 4)
        
        for i in 0..<points.rows {
            for k in 0..<points.columns {
                resultM[i,k] = points[i,k] * u
            }
        }
        
        for i in 0..<points.rows {
            resultM[i,3] = u;
        }
        
        return resultM
        
    }
    
    func convertToDec(points: Matrix) -> Matrix {
        
        let resultM = Matrix(rows: points.rows, columns: 3)
        
        for i in 0..<points.rows {
            for k in 0..<points.columns-1 {
                resultM[i,k] = points[i,k] / points[i,points.columns-1]
            }
        }
        
        return resultM
    }


}

