//
// DeBruijnIndex+Substitution.swift
// Lambda
//
// Created by sabotzs on 15.07.2024
//

extension DeBruijnIndex {
    func substituting(
        _ index: UInt,
        with newIndex: DeBruijnIndex
    ) -> DeBruijnIndex {
        switch self {
        case let .variable(currentIndex):
            return currentIndex == index ? newIndex : self
        case let .abstraction(body):
            let shiftedNewIndex = newIndex.shifted(cutoff: 0, by: 1)
            let substitutedBody = body.substituting(index + 1, with: shiftedNewIndex)
            return .abstraction(body: substitutedBody)
        case let .application(function, argument):
            let substitutedFunction = function.substituting(index, with: newIndex)
            let substitutedArgument = argument.substituting(index, with: newIndex)
            return .application(function: substitutedFunction, argument: substitutedArgument)
        }
    }
}
