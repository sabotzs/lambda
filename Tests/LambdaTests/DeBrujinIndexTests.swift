//
// DeBrujinIndexTests.swift
// LambdaTests
//
// Created by sabotzs on 12.07.2024
//

import XCTest
@testable import Lambda

class DeBruijnIndexTests: XCTestCase {
    func testIndexOfSingleVariable() {
        let expression: LambdaExpression = .variable(name: "x")
        let lambda = Lambda(expression)

        let expected: DeBruijnIndex = .variable(index: 0)

        XCTAssertEqual(lambda.deBruijnIndex, expected)
    }

    func testIndexOfSingleAbstraction() {
        let name = "x"
        let expression: LambdaExpression = .abstraction(
            variable: name,
            body: .variable(name: name)
        )
        let lambda = Lambda(expression)

        let expected: DeBruijnIndex = .abstraction(body: .variable(index: 0))

        XCTAssertEqual(lambda.deBruijnIndex, expected)
    }

    func testIndexOfSingleApplication() {
        let name = "x"
        let expression: LambdaExpression = .application(
            function: .abstraction(variable: name, body: .variable(name: name)),
            argument: .abstraction(variable: name, body: .variable(name: name))
        )
        let lambda = Lambda(expression)

        let expected: DeBruijnIndex = .application(
            function: .abstraction(body: .variable(index: 0)),
            argument: .abstraction(body: .variable(index: 0))
        )

        XCTAssertEqual(lambda.deBruijnIndex, expected)
    }

    func testIndexOfBoundIncreasesInDeeperAbstraction() {
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
        let lambda = Lambda(expression)

        let expected: DeBruijnIndex = .abstraction(
            body: .abstraction(
                body: .abstraction(
                    body: .variable(index: 2)
                )
            )
        )

        XCTAssertEqual(lambda.deBruijnIndex, expected)
    }

    func testIndexOfFreeVariables() {
        let expression: LambdaExpression = .application(
            function: .variable(name: "x"),
            argument: .variable(name: "y")
        )
        let lambda = Lambda(expression)
        let indices = lambda.freeVariablesIndices

        let expected: DeBruijnIndex = .application(
            function: .variable(index: indices["x"]!),
            argument: .variable(index: indices["y"]!)
        )

        XCTAssertEqual(lambda.deBruijnIndex, expected)
    }

    func testIndexWithVariableBothFreeAndBound() {
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

    func testAdvancedExpression() {
        // \x.(x(\y.ya)x)y
        let expression: LambdaExpression = .abstraction(
            variable: "x",
            body: .application(
                function: .application(
                    function: .application(
                        function: .variable(name: "x"),
                        argument: .abstraction(
                            variable: "y",
                            body: .application(
                                function: .variable(name: "y"),
                                argument: .variable(name: "a")))),
                    argument: .variable(name: "x")),
                argument: .variable(name: "y")
            )
        )
        let lambda = Lambda(expression)
        let freeIndices = lambda.freeVariablesIndices

        // If free indices are ["a": 0, "y": 1] then \(0(\02)0)2
        // If free indices are ["a": 1, "y": 0] then \(0(\03)0)1
        // In both cases is valid index of the expression
        let expected: DeBruijnIndex = .abstraction(
            body: .application(
                function: .application(
                    function: .application(
                        function: .variable(index: 0),
                        argument: .abstraction(
                            body: .application(
                                function: .variable(index: 0),
                                argument: .variable(index: freeIndices["a"]! + 2)
                            )
                        )
                    ),
                    argument: .variable(index: 0)
                ), 
                argument: .variable(index: freeIndices["y"]! + 1)
            )
        )

        XCTAssertEqual(lambda.deBruijnIndex, expected)
    }
}
