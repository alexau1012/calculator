//
//  Calculator.swift
//  calc
//
//  Created by Jacktator on 31/3/20.
//  Copyright © 2020 UTS. All rights reserved.
//

import Foundation

struct ErrorInfo {
    var input: String;
    var argIndex: Int;
}

enum CalculatorError: Error {
    case invalidInteger(errorInfo: ErrorInfo);
    case invalidOperator(errorInfo: ErrorInfo);
    case invalidDivision;
};

class Calculator {
    
    /// For multi-step calculation, it's helpful to persist existing result
    var currentResult: Int = 0;
    /// This array hold values that requires either addition or subtraction
    var intermediateResults: [String] = [];
    /// This array contains all supported operations
    var supportedOperations: [String] = ["+", "-", "x", "/", "%"];
    /// Store error information for throwing errors
    var errorInfo: ErrorInfo = ErrorInfo(input: "", argIndex: -1);
    
    /// Perform Addition
    ///
    /// - Author: Jacktator
    /// - Parameters:
    ///   - no1: First number
    ///   - no2: Second number
    /// - Returns: The addition result
    ///
    /// - Warning: The result may yield Int overflow.
    /// - SeeAlso: https://developer.apple.com/documentation/swift/int/2884663-addingreportingoverflow
    func add(no1: Int, no2: Int) -> Int {
        return no1 + no2;
    }
    
    func subtract(no1: Int, no2: Int) -> Int {
        return no1 - no2;
    }
    
    func multiply(no1: Int, no2: Int) -> Int {
        return no1 * no2;
    }
    
    func divide(no1: Int, no2: Int) throws -> Int {
        try validateNonZeroValOnDivision(num: no2);
        return no1 / no2;
    }
    
    func modulus(no1: Int, no2: Int) -> Int {
        return no1 % no2;
    }
    
    func validateValue(num: String, argIndex: Int) throws {
        guard Int(num) != nil else {
            errorInfo.input = num;
            errorInfo.argIndex = argIndex;
            throw CalculatorError.invalidInteger(errorInfo: errorInfo);
        };
    }
    
    func validateOperator(operatorSymbol: String, argIndex: Int) throws {
        guard supportedOperations.contains(operatorSymbol) else {
            errorInfo.input = operatorSymbol;
            errorInfo.argIndex = argIndex;
            throw CalculatorError.invalidOperator(errorInfo: errorInfo);
        }
    }
    
    func validateNonZeroValOnDivision(num: Int) throws {
        guard num != 0 else {
            throw CalculatorError.invalidDivision;
        }
    }
    
    func calculate(args: [String]) throws -> String {
        // Calculate Result from the arguments.

        for (index, element) in args.enumerated() {
            if index % 2 == 0 {
                try validateValue(num: element, argIndex: index);
            } else {
                try validateOperator(operatorSymbol: element, argIndex: index);
            }
        }

        // This flag is true when an operation is performed so that processed values
        // are not calculated again
        var skipNextVal: Bool = false;
        
        for (index, element) in args.enumerated() {
            if skipNextVal == true {
                skipNextVal = false;
                continue;
            }
            
            var lastValue: String;
            switch element {
            case "x":
                lastValue = intermediateResults.removeLast();
                intermediateResults.append(
                    String(multiply(no1: Int(lastValue)!, no2: Int(args[index+1])!)));
                skipNextVal = true;
                break;
            case "/":
                lastValue = intermediateResults.removeLast();
                intermediateResults.append(
                    String(try divide(no1: Int(lastValue)!, no2: Int(args[index+1])!)));
                skipNextVal = true;
                break;
            case "%":
                lastValue = intermediateResults.removeLast();
                intermediateResults.append(
                    String(modulus(no1: Int(lastValue)!, no2: Int(args[index+1])!)));
                skipNextVal = true;
                break;
            default:
                intermediateResults.append(element);
                break;
            }
        }
            
//        print(intermediateResults);
        
        currentResult = Int(intermediateResults[0])!;
        
        for (index, element) in intermediateResults.enumerated() {
            switch element {
            case "+":
                currentResult = add(no1: currentResult, no2: Int(intermediateResults[index+1])!);
                break;
            case "-":
                currentResult = subtract(no1: currentResult, no2: Int(intermediateResults[index+1])!);
                break;
            default:
                break;
            }
        }
        
        return(String(currentResult))
    }
}
