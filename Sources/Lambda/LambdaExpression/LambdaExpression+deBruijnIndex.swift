//
// LambdaExpression+deBruijnIndex.swift
// Lambda
//
// Created by sabotzs on 13.07.2024
//

extension LambdaExpression {
    var deBruijnIndex: DeBruijnIndex {
        getDeBruijnIndex(
            lambda: self,
            bound: [],
            boundVariablesIndices: [:],
            freeVariablesIndices: freeVariablesIndices
        )
    }

    private func getDeBruijnIndex(
        lambda: LambdaExpression,
        bound: Set<String>,
        boundVariablesIndices: [String: UInt],
        freeVariablesIndices: [String: UInt]
    ) -> DeBruijnIndex {
        switch lambda {
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
            let newFreeVariablesIndices = freeVariablesIndices.mapValues { $0 + 1 }
            let index = getDeBruijnIndex(
                lambda: body,
                bound: bound.union([variable]),
                boundVariablesIndices: newBoundVariablesIndices,
                freeVariablesIndices: newFreeVariablesIndices
            )
            return .abstraction(body: index)
        case let .application(function, argument):
            let functionIndex = getDeBruijnIndex(
                lambda: function,
                bound: bound,
                boundVariablesIndices: boundVariablesIndices,
                freeVariablesIndices: freeVariablesIndices
            )
            let argumentIndex = getDeBruijnIndex(
                lambda: argument,
                bound: bound,
                boundVariablesIndices: boundVariablesIndices,
                freeVariablesIndices: freeVariablesIndices
            )
            return .application(function: functionIndex, argument: argumentIndex)
        }
    }
}
