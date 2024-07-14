//
// LambdaExpressionTests+DeBrujinIndex.swift
// LambdaTests
//
// Created by sabotzs on 12.07.2024
//

import XCTest
@testable import Lambda

class LambdaExpressionDeBruijnIndexTests: XCTestCase {
    func testIndexOfVariable() {
        let expression: LambdaExpression = .variable(name: "x")

        let expected: DeBruijnIndex = .variable(index: 0)

        XCTAssertEqual(expression.deBruijnIndex, expected)
    }

    func testIndexOfAbstraction() {
        let name = "x"
        let expression: LambdaExpression = .abstraction(
            variable: name,
            body: .variable(name: name)
        )

        let expected: DeBruijnIndex = .abstraction(body: .variable(index: 0))

        XCTAssertEqual(expression.deBruijnIndex, expected)
    }

    func testIndexOfApplication() {
        let name = "x"
        let expression: LambdaExpression = .application(
            function: .abstraction(variable: name, body: .variable(name: name)),
            argument: .abstraction(variable: name, body: .variable(name: name))
        )

        let expected: DeBruijnIndex = .application(
            function: .abstraction(body: .variable(index: 0)),
            argument: .abstraction(body: .variable(index: 0))
        )

        XCTAssertEqual(expression.deBruijnIndex, expected)
    }

    func testIndexOfDeeperAbstraction() {
        // \x.\y.\z.x
        let expression: LambdaExpression = .abstraction(
            variable: "x",
            body: .abstraction(
                variable: "y",
                body: .abstraction(
                    variable: "z",
                    body: .variable(name: "x")
                )
            )
        )

        let expected: DeBruijnIndex = .abstraction(
            body: .abstraction(
                body: .abstraction(
                    body: .variable(index: 2)
                )
            )
        )

        XCTAssertEqual(expression.deBruijnIndex, expected)
    }

    func testIndexOfFreeVariablesOnly() {
        let expression: LambdaExpression = .application(
            function: .variable(name: "x"),
            argument: .variable(name: "y")
        )
        let lambda = Lambda(expression)

        let expectedWithContext: ([String: UInt]) -> DeBruijnIndex = { indices in
            .application(
                function: .variable(index: indices["x"]!),
                argument: .variable(index: indices["y"]!)
            )
        }

        XCTAssert(
            lambda.deBruijnIndex == expectedWithContext(["x": 0, "y": 1])
            || lambda.deBruijnIndex == expectedWithContext(["x": 1, "y": 0])
        )
    }

    func testIndexWithSameNamedFreeAndBoundVariable() {
        let name = "x"
        let expression: LambdaExpression = .application(
            function: .abstraction(variable: name, body: .variable(name: name)),
            argument: .variable(name: name)
        )
        let lambda = Lambda(expression)

        let expected: DeBruijnIndex = .application(
            function: .abstraction(body: .variable(index: 0)),
            argument: .variable(index: 0)
        )

        XCTAssertEqual(lambda.deBruijnIndex, expected)
    }
}
