//
// LambdaExpression.swift
// Georgi Kuklev on 12.07.2024

enum LambdaExpression {
    case variable(name: String)
    indirect case abstraction(variable: String, body: LambdaExpression)
    indirect case application(function: LambdaExpression, argument: LambdaExpression)
}