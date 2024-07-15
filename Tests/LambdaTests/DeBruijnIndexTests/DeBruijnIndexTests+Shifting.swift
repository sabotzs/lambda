//
// DeBruijnIndexTests+Shifting.swift
// Lambda
//
// Created by sabotzs on 14.07.2024
//

import XCTest
@testable import Lambda

final class DeBruijnIndexShiftingTests: XCTestCase {
    func testShiftingVariableLowerThanCutoff() {
        let index: DeBruijnIndex = .variable(index: 0)
        let result = index.shifted(cutoff: 2, by: 1)

        let expected: DeBruijnIndex = .variable(index: 0)

        XCTAssertEqual(result, expected)
    }

    func testShiftingVariableEqualToTheCutoff() {
        let index: DeBruijnIndex = .variable(index: 1)
        let result = index.shifted(cutoff: 1, by: 1)

        let expected: DeBruijnIndex = .variable(index: 2)

        XCTAssertEqual(result, expected)
    }

    func testShiftingVariableAboveTheCutoff() {
        let index: DeBruijnIndex = .variable(index: 3)
        let result = index.shifted(cutoff: 2, by: 1)

        let expected: DeBruijnIndex = .variable(index: 4)

        XCTAssertEqual(result, expected)
    }

    func testShiftingAbstractionIncreasesCutoff() {
        let index: DeBruijnIndex = .abstraction(body: .variable(index: 1))
        let result = index.shifted(cutoff: 1, by: 1)

        let expected: DeBruijnIndex = .abstraction(body: .variable(index: 1))

        XCTAssertEqual(result, expected)
    }

    func testShiftingApplicationDoesNotIncreaseTheCutoff() {
        let index: DeBruijnIndex = .application(
            function: .abstraction(body: .variable(index: 1)),
            argument: .variable(index: 0)
        )
        let result = index.shifted(cutoff: 1, by: 1)

        let expected: DeBruijnIndex = .application(
            function: .abstraction(body: .variable(index: 1)),
            argument: .variable(index: 0)
        )

        XCTAssertEqual(result, expected)
    }
}
