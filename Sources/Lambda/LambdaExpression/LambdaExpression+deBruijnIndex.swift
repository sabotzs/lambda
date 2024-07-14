//
// LambdaExpression+deBruijnIndex.swift
// Lambda
//
// Created by sabotzs on 14.07.2024
//

extension LambdaExpression {
    var deBruijnIndex: DeBruijnIndex {
        getDeBruijnIndex(
            bound: [],
            boundVariablesIndices: [:],
            freeVariablesIndices: freeVariablesIndices
        )
    }

    private var freeVariablesIndices: [String: UInt] {
        var result: [String: UInt] = [:]
        for (idx, el) in freeVariables.enumerated() {
            result[el] = UInt(bitPattern: idx)
        }
        return result
    }

    private func getDeBruijnIndex(
        bound: Set<String>,
        boundVariablesIndices: [String: UInt],
        freeVariablesIndices: [String: UInt]
    ) -> DeBruijnIndex {
        switch self {
        case let .variable(name):
            let index = if bound.contains(name) {
                boundVariablesIndices[name]!
            } else {
                freeVariablesIndices[name]!
            }
            return .variable(index: index)
        case let .abstraction(variable, body):
            var newBoundVariablesIndices = boundVariablesIndices.mapValues { $0 + 1 }
            newBoundVariablesIndices[variable] = 0
            let newFreeVariablesIndices = boundVariablesIndices.mapValues { $0 + 1 }
            let index = body.getDeBruijnIndex(
                bound: bound.union([variable]),
                boundVariablesIndices: newBoundVariablesIndices,
                freeVariablesIndices: newFreeVariablesIndices
            )
            return .abstraction(body: index)
        case let .application(function, argument):
            let functionIndex = function.getDeBruijnIndex(
                bound: bound,
                boundVariablesIndices: boundVariablesIndices,
                freeVariablesIndices: freeVariablesIndices
            )
            let argumentIndex = argument.getDeBruijnIndex(
                bound: bound,
                boundVariablesIndices: boundVariablesIndices,
                freeVariablesIndices: freeVariablesIndices
            )
            return .application(function: functionIndex, argument: argumentIndex)
        }
    }
}
