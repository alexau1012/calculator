//
//  main.swift
//  calc
//
//  Created by Jesse Clark on 12/3/18.
//  Copyright © 2018 UTS. All rights reserved.
//

import Foundation

var args = ProcessInfo.processInfo.arguments
args.removeFirst() // remove the name of the program

// Initialize a Calculator object
let calculator = Calculator();

do {
    // Calculate the result
    let result = try calculator.calculate(args: args)
    print(result)
} catch CalculatorError.invalidInteger(let errorInfo) {
    print("Error: Provided value (\(errorInfo.input)) is not of type integer at argument position \(errorInfo.argIndex)");
    exit(1)
} catch CalculatorError.invalidOperator(let errorInfo) {
    print("Error: Provided operator (\(errorInfo.input)) is not supported at argument position \(errorInfo.argIndex)");
    exit(2)
} catch CalculatorError.invalidDivision {
    print("Error: Divide by zero is invalid");
    exit(3)
} catch {
    print("Unexpected error \(error)")
    exit(4)
}


