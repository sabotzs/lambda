//
// FreeVariablesTests.swift
// LambdaTests
//
// Create by Georgi Kuklev on 12.07.2024
//

import XCTest
@testable import Lambda

final class FreeVariablesTests: XCTestCase {
    func testVariableExpressionIsFreeVariable() {
        let name = "x"
        let expression: LambdaExpression = .variable(name: name)
        let lambda = Lambda(expression)

        let expected: Set<String> = [name]

        XCTAssertEqual(lambda.freeVariables, expected)
    }

    func testAbstractionOnVariableWithSameNameHasNoFreeVariables() {
        let name = "x"
        let expression: LambdaExpression = .abstraction(variable: name, body: .variable(name: name))
        let lambda = Lambda(expression)

        let expected: Set<String> = []

        XCTAssertEqual(lambda.freeVariables, expected)
    }

    func testAbstractionOnVariableWithDifferentHasFreeVariable() {
        let bound = "x"
        let free = "y"
        let expression: LambdaExpression = .abstraction(variable: bound, body: .variable(name: free))
        let lambda = Lambda(expression)

        let expected: Set<String> = [free]

        XCTAssertEqual(lambda.freeVariables, expected)
    }

    func testApplicationFreeVariablesIsUnionOfFunctionAndArgumentFreeVariables() {
        let bound = "x"
        let free = "y"
        let function: LambdaExpression = .abstraction(variable: bound, body: .variable(name: bound))
        let argument: LambdaExpression = .variable(name: free)
        let expression: LambdaExpression = .application(function: function, argument: argument)
        let lambda = Lambda(expression)

        let expected: Set<String> = [free]

        XCTAssertEqual(lambda.freeVariables, expected)
    }

    func testFreeVariableInFunctionAndArgumentIsFreeInApplication() {
        let bound = "x"
        let free = "y"
        let function: LambdaExpression = .abstraction(variable: bound, body: .variable(name: free))
        let argument: LambdaExpression = .variable(name: free)
        let expression: LambdaExpression = .application(function: function, argument: argument)
        let lambda = Lambda(expression)

        let expected: Set<String> = [free]

        XCTAssertEqual(lambda.freeVariables, expected)
    }
}