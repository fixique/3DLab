import XCTest

final class MatrixTests: XCTestCase {

    private let accuracy: Double = 1e-9

    private func assertMatrix(_ matrix: Matrix, _ expected: [[Double]], file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(matrix.rows, expected.count, "row count mismatch", file: file, line: line)
        for (row, expectedRow) in expected.enumerated() {
            XCTAssertEqual(matrix.columns, expectedRow.count, "column count mismatch at row \(row)", file: file, line: line)
            for col in 0..<expectedRow.count {
                XCTAssertEqual(matrix[row, col], expectedRow[col], accuracy: accuracy, file: file, line: line)
            }
        }
    }

    func testTransfer() {
        let m = Matrix([1, 2, 3, 1, 4, 5, 6, 1], rows: 2, columns: 4)
        m.transfer(vector: Matrix([10, -4, 2.5], rows: 3, columns: 1))
        assertMatrix(m, [[11, -2, 5.5, 1], [14, 1, 8.5, 1]])
    }

    func testScale() {
        let m = Matrix([2, 4, 6, 1, -1, 3, 0.5, 1], rows: 2, columns: 4)
        m.scale(type: 1, scale: 2.5)
        assertMatrix(m, [[2, 10, 6, 1], [-1, 7.5, 0.5, 1]])
    }

    func testRotateAroundXBy90Degrees() {
        let m = Matrix([1, 2, 3, 1, 0, 0, 1, 1], rows: 2, columns: 4)
        m.rotate(angle: 90, typeO: 0, typeS: false)
        assertMatrix(m, [[1, 3, -2, 1], [0, 1, 0, 1]])
    }

    func testOrthographicProjection() {
        let m = Matrix([1, 2, 3, 1, 0.5, -1.25, 7, 1], rows: 2, columns: 4)
        let xy = m.ProjectOrt(type: 2, D: 0)
        assertMatrix(xy, [[1, 2, 1], [0.5, -1.25, 1]])
        let yz = m.ProjectOrt(type: 0, D: 0)
        assertMatrix(yz, [[2, 3, 1], [-1.25, 7, 1]])
    }
}
