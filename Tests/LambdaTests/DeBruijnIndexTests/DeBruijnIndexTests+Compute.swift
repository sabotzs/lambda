//
// DeBruijnIndexTests+Compute.swift
// Lambda
//
// Created by sabotzs on 16.07.2024
//

import XCTest
@testable import Lambda

final class DeBruijnIndexComputeTests: XCTestCase {
    func testComputingVariableReturnsTheSame() {
        let index: DeBruijnIndex = .variable(index: 0)
        let result = index.compute()

        XCTAssertEqual(result, index)
    }

    func testComputingAbstractionReturnsTheSame() {
        let index: DeBruijnIndex = .abstraction(body: .variable(index: 0))
        let result = index.compute()

        XCTAssertEqual(result, index)
    }

    func testComputingApplicationWithoutAbstractionAsFunctionReturnsTheSame() {
        let index: DeBruijnIndex = .application(
            function: .variable(index: 0),
            argument: .variable(index: 0)
        )
        let result = index.compute()

        XCTAssertEqual(result, index)
    }

    func testComputingApplicationWithAbstractionAsFunctionMakesReduction() {
        let index: DeBruijnIndex = .application(
            function: .abstraction(body: .variable(index: 0)),
            argument: .variable(index: 0)
        )
        let result = index.compute()

        let expected: DeBruijnIndex = .variable(index: 0)

        XCTAssertEqual(result, expected)
    }

    func testComputingNestedAbstractionReturnsAbstraction() {
        let index: DeBruijnIndex = .application(
            function: .abstraction(
                body: .abstraction(
                    body: .application(
                        function: .variable(index: 1),
                        argument: .variable(index: 2)
                    )
                )
            ),
            argument: .variable(index: 1)
        )
        let result = index.compute()

        let expected: DeBruijnIndex = .abstraction(
            body: .application(
                function: .variable(index: 2),
                argument: .variable(index: 1)
            )
        )
        XCTAssertEqual(result, expected)
    }
}