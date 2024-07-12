//
// Lambda.swift
// Lambda
//
// Created by sabotzs on 12.07.2024
//

class Lambda {
    let lambda: LambdaExpression
    private(set) lazy var freeVariables: Set<String> = {
        getFreeVariables(lambda: lambda, free: [], bound: [])
    }()
    private(set) lazy var freeVariablesIndices: [String: UInt] = {
        let indices = freeVariables.enumerated().map { pair in
            (pair.element, UInt(bitPattern: pair.offset))
        }
        return [String: UInt](uniqueKeysWithValues: indices)
    }()
    private(set) lazy var deBruijnIndex: DeBruijnIndex = {
        getDeBruijnIndex(
            lambda: lambda,
            bound: [],
            boundVariablesIndices: [:],
            freeVariablesIndices: freeVariablesIndices
        )
    }()

    init(_ lambda: LambdaExpression) {
        self.lambda = lambda
    }
}

// MARK: Free variables
extension Lambda {
    private func getFreeVariables(
        lambda: LambdaExpression,
        free: Set<String>,
        bound: Set<String>
    ) -> Set<String> {
        switch lambda {
        case let .variable(name):
            if !bound.contains(name) {
                return free.union([name])
            }
            return free
        case let .abstraction(variable, body):
            return getFreeVariables(
                lambda: body,
                free: free,
                bound: bound.union([variable])
            )
        case let .application(function, argument):
            let functionFreeVariables = getFreeVariables(
                lambda: function,
                free: free,
                bound: bound
            )
            let argumentFreeVariables = getFreeVariables(
                lambda: argument,
                free: free,
                bound: bound
            )
            return functionFreeVariables.union(argumentFreeVariables)
        }
    }
}

// MARK: de Brujin index
extension Lambda {
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
