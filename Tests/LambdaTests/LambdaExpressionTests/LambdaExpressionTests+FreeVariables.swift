//
// LambdaExpressionTests+FreeVariables.swift
// LambdaTests
//
// Create by Georgi Kuklev on 12.07.2024
//

import XCTest
@testable import Lambda

final class LambdaExpressionFreeVariablesTests: XCTestCase {
    func testSingleVariableIsFree() {
        let name = "x"
        let expression: LambdaExpression = .variable(name: name)

        let expected: Set<String> = [name]

        XCTAssertEqual(expression.freeVariables, expected)
    }

    func testAbstractionOnVariableWithSameNameHasNoFreeVariables() {
        let name = "x"
        let expression: LambdaExpression = .abstraction(
            variable: name,
            body: .variable(name: name)
        )

        let expected: Set<String> = []

        XCTAssertEqual(expression.freeVariables, expected)
    }

    func testAbstractionOnVariableWithDifferentHasFreeVariable() {
        let bound = "x"
        let free = "y"
        let expression: LambdaExpression = .abstraction(
            variable: bound,
            body: .variable(name: free)
        )

        let expected: Set<String> = [free]

        XCTAssertEqual(expression.freeVariables, expected)
    }

    func testApplicationFreeVariablesIsUnionOfFunctionAndArgumentFreeVariables() {
        let bound = "x"
        let free = "y"
        let expression: LambdaExpression = .application(
            function: .abstraction(variable: bound, body: .variable(name: bound)),
            argument: .variable(name: free)
        )

        let expected: Set<String> = [free]

        XCTAssertEqual(expression.freeVariables, expected)
    }

    func testFreeVariableInFunctionAndArgumentIsFreeInApplication() {
        let expression: LambdaExpression = .application(
            function: .abstraction(variable: "x", body: .variable(name: "y")),
            argument: .variable(name: "z")
        )

        let expected: Set<String> = ["y", "z"]

        XCTAssertEqual(expression.freeVariables, expected)
    }

    func testNameShadowingFreeVariableReturnsTheVariable() {
        let name = "x"
        let expression: LambdaExpression = .application(
            function: .abstraction(variable: name, body: .variable(name: name)),
            argument: .variable(name: name)
        )

        let expected: Set<String> = [name]

        XCTAssertEqual(expression.freeVariables, expected)
    }
}
