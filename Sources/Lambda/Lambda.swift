//
// Lambda.swift
// Georgi Kuklev on 12.07.2024

class Lambda {
    let lambda: LambdaExpression
    private(set) lazy var freeVariables: Set<String> = {
        var all: Set<String> = []
        var bound: Set<String> = []
        getVariables(lambda: lambda, all: &all, bound: &bound)
        return all.subtracting(bound)
    }()

    init(_ lambda: LambdaExpression) {
        self.lambda = lambda
    }
}

// MARK: Free variables
extension Lambda {
    private func getVariables(
        lambda: LambdaExpression,
        all: inout Set<String>,
        bound: inout Set<String>
    ) {
        switch lambda {
        case let .variable(name):
            all.insert(name)
        case let .abstraction(variable, body):
            all.insert(variable)
            bound.insert(variable)
            getVariables(lambda: body, all: &all, bound: &bound)
        case let .application(function, argument):
            getVariables(lambda: function, all: &all, bound: &bound)
            getVariables(lambda: argument, all: &all, bound: &bound)
        }
    }
}

