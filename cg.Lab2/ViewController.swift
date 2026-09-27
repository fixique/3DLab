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

    let imageView = UIImageView()
    let u: Double = 1.0
    var typeProjection = 5
    var typePerspective: Double = 512

    private let buttonHeight: CGFloat = 44
    private let buttonFontSize: CGFloat = 13

    private var didConvertToHomogeneous = false
    private var didComputeContentOffset = false
    private var contentOffset: CGPoint = .zero
    private var renderedSize: CGSize = .zero
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
        
        buildInterface()

        print("\(vertex)")
        
        if !didConvertToHomogeneous {
            vertex = convertCoord(points: vertex)
            didConvertToHomogeneous = true
        }
        print("\(vertex)")
        redraw()

    
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
        
        let viewport = imageView.bounds.size
        guard viewport.width > 0, viewport.height > 0 else { return }
        renderedSize = viewport

        let decPoints = convertToDec(points: points)
        print("\(decPoints)")
        
        if !didComputeContentOffset {
            contentOffset = centeredContentOffset(for: decPoints)
            didComputeContentOffset = true
        }

        let zeroCordX = viewport.width / 2 + contentOffset.x
        let zeroCordY = viewport.height / 2 + contentOffset.y

        UIGraphicsBeginImageContextWithOptions(viewport, false, 0)
        
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

    private func redraw() {
        drawFigure(points: vertex.ProjectOrt(type: typeProjection, D: typePerspective), relations: relations)
    }

    private func redrawIfNeeded() {
        let viewport = imageView.bounds.size
        guard viewport.width > 0, viewport.height > 0, viewport != renderedSize else { return }
        redraw()
    }

    private func centeredContentOffset(for points: Matrix) -> CGPoint {

        guard points.rows > 0 else { return .zero }

        var minX = Double.greatestFiniteMagnitude
        var maxX = -Double.greatestFiniteMagnitude
        var minY = Double.greatestFiniteMagnitude
        var maxY = -Double.greatestFiniteMagnitude

        for i in 0..<points.rows {
            minX = Swift.min(minX, points[i,0])
            maxX = Swift.max(maxX, points[i,0])
            minY = Swift.min(minY, points[i,1])
            maxY = Swift.max(maxY, points[i,1])
        }

        return CGPoint(x: -((minX + maxX) / 2), y: (minY + maxY) / 2)
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


    // MARK: - Programmatic interface

    private func buildInterface() {

        view.backgroundColor = .white

        let rootStack = makeStack(axis: .vertical, spacing: 8, distribution: .fill)
        rootStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rootStack)

        let drawingArea = FigureView()
        drawingArea.onLayout = { [weak self] in
            self?.redrawIfNeeded()
        }
        drawingArea.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        drawingArea.setContentCompressionResistancePriority(UILayoutPriority(1), for: .vertical)
        drawingArea.addSubview(imageView)

        imageView.contentMode = .scaleToFill
        imageView.isUserInteractionEnabled = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentHuggingPriority(UILayoutPriority(1), for: .horizontal)
        imageView.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        imageView.setContentCompressionResistancePriority(UILayoutPriority(1), for: .horizontal)
        imageView.setContentCompressionResistancePriority(UILayoutPriority(1), for: .vertical)

        let controlsStack = makeStack(axis: .vertical, spacing: 8, distribution: .fill)
        controlsStack.setContentHuggingPriority(.required, for: .vertical)
        controlsStack.setContentCompressionResistancePriority(.required, for: .vertical)

        let translationRow = makeStack(axis: .horizontal, spacing: 6)
        for (title, action) in [
            ("Вверх", #selector(transferUp(_:))),
            ("Вниз", #selector(transferDown(_:))),
            ("Вправо", #selector(transferRight(_:))),
            ("Влево", #selector(transferLeft(_:))),
            ("Вперед", #selector(transferForward(_:))),
            ("Назад", #selector(transferBack(_:)))
            ] {
            translationRow.addArrangedSubview(makeButton(title: title, action: action))
        }

        let operationsRow = makeStack(axis: .horizontal, spacing: 6)
        operationsRow.addArrangedSubview(makeButtonGroup([
            ("Отражение xOz", #selector(reflectXOZ(_:))),
            ("Отражение yOz", #selector(reflectYOZ(_:))),
            ("Отражение xOy", #selector(reflectXOY(_:))),
            ("Отраж. от грани", #selector(reflectBySide(_:)))
            ]))
        operationsRow.addArrangedSubview(makeButtonGroup([
            ("Приближение X", #selector(xScale(_:))),
            ("Отдаление Х", #selector(xScaleMin(_:))),
            ("Приближение Y", #selector(yScale(_:))),
            ("Отдаление Y", #selector(yScaleMin(_:))),
            ("Приближение XY", #selector(xyScale(_:))),
            ("Отдаление XY", #selector(xyScaleMin(_:)))
            ]))
        operationsRow.addArrangedSubview(makeButtonGroup([
            ("Ox по часовой", #selector(oxRotationBack(_:))),
            ("Ox против", #selector(oxRotationForward(_:))),
            ("Oy по часовой", #selector(oyRotationBack(_:))),
            ("Oy против", #selector(oyRotationForward(_:))),
            ("Oz по часовой", #selector(ozRotationForward(_:))),
            ("Oz против", #selector(ozRotationBack(_:)))
            ]))
        operationsRow.addArrangedSubview(makeButtonGroup([
            ("YZ", #selector(yzProjection(_:))),
            ("XZ", #selector(xzProjection(_:))),
            ("XY", #selector(xyProjection(_:))),
            ("П. YZ", #selector(pYZ(_:))),
            ("П. XZ", #selector(pXZ(_:))),
            ("П. XY", #selector(pXY(_:)))
            ]))

        controlsStack.addArrangedSubview(translationRow)
        controlsStack.addArrangedSubview(operationsRow)
        rootStack.addArrangedSubview(drawingArea)
        rootStack.addArrangedSubview(controlsStack)

        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            rootStack.topAnchor.constraint(equalTo: guide.topAnchor),
            rootStack.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            rootStack.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            rootStack.trailingAnchor.constraint(equalTo: guide.trailingAnchor),

            imageView.topAnchor.constraint(equalTo: drawingArea.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: drawingArea.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: drawingArea.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: drawingArea.trailingAnchor)
            ])
    }

    private func makeStack(axis: NSLayoutConstraint.Axis, spacing: CGFloat, distribution: UIStackView.Distribution = .fillEqually) -> UIStackView {
        let stack = UIStackView()
        stack.axis = axis
        stack.spacing = spacing
        stack.alignment = .fill
        stack.distribution = distribution
        return stack
    }

    private func makeButtonGroup(_ items: [(String, Selector)]) -> UIStackView {
        let group = makeStack(axis: .vertical, spacing: 6)
        for (title, action) in items {
            group.addArrangedSubview(makeButton(title: title, action: action))
        }
        return group
    }

    private func makeButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.contentHorizontalAlignment = .center
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: buttonHeight).isActive = true
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
}


// Контейнер рисунка, который сообщает о своей раскладке,
// чтобы рисунок можно было перерисовать под фактический размер.
private final class FigureView: UIView {

    var onLayout: (() -> Void)?

    override func layoutSubviews() {
        super.layoutSubviews()
        onLayout?()
    }
}

