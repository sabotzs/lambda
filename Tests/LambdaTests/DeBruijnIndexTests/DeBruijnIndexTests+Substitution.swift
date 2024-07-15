//
// DeBruijnIndexTests+Substitution.swift
// Lambda
//
// Created by sabotzs on 15.07.2024
//

import XCTest
@testable import Lambda

final class DeBruijnIndexSubstitutionTests: XCTestCase {
    func testSubstitutingInSameVariable() {
        let index: DeBruijnIndex = .variable(index: 0)
        let newIndex: DeBruijnIndex = .abstraction(body: .variable(index: 0))
        let result = index.substituting(0, with: newIndex)

        let expected: DeBruijnIndex = .abstraction(body: .variable(index: 0))

        XCTAssertEqual(result, expected)
    }

    func testSubstitutingInDifferentVariable() {
        let index: DeBruijnIndex = .variable(index: 0)
        let newIndex: DeBruijnIndex = .abstraction(body: .variable(index: 0))
        let result = index.substituting(1, with: newIndex)

        let expected: DeBruijnIndex = .variable(index: 0)

        XCTAssertEqual(result, expected)
    }

    func testSubstitutingInClosedAbstraction() {
        let index: DeBruijnIndex = .abstraction(body: .variable(index: 0))
        let newIndex: DeBruijnIndex = .abstraction(body: .variable(index: 0))
        let result = index.substituting(0, with: newIndex)

        let expected: DeBruijnIndex = .abstraction(body: .variable(index: 0))

        XCTAssertEqual(result, expected)
    }

    func testSubstitutingInApplication() {
        let index: DeBruijnIndex = .application(
            function: .variable(index: 0),
            argument: .variable(index: 1)
        )
        let newIndex: DeBruijnIndex = .abstraction(body: .variable(index: 0))
        let result = index.substituting(0, with: newIndex)

        let expected: DeBruijnIndex = .application(
            function: .abstraction(body: .variable(index: 0)),
            argument: .variable(index: 1)
        )

        XCTAssertEqual(result, expected)
    }

    func testSubstitutingInAbstractionWithFreeVariables() {
        let index: DeBruijnIndex = .abstraction(
            body: .application(
                function: .variable(index: 0),
                argument: .variable(index: 1)
            )
        )
        let newIndex: DeBruijnIndex = .abstraction(body: .variable(index: 0))
        let result = index.substituting(0, with: newIndex)

        let expected: DeBruijnIndex = .abstraction(
            body: .application(
                function: .variable(index: 0),
                argument: .abstraction(body: .variable(index: 0))
            )
        )

        XCTAssertEqual(result, expected)
    }
}
