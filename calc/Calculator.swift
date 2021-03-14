//
//  Calculator.swift
//  calc
//
//  Created by Jacktator on 31/3/20.
//  Copyright © 2020 UTS. All rights reserved.
//

import Foundation

// Structure for storing error input and argument's position
struct ErrorInfo {
    var input: String;
    var argIndex: Int;
};

// Calculator error types
enum CalculatorError: Error {
    case invalidInteger(errorInfo: ErrorInfo);
    case invalidOperator(errorInfo: ErrorInfo);
    case invalidDivision;
};

class Calculator {
    /// This array contains all supported operations
    var supportedOperations: [String] = ["+", "-", "x", "/", "%"];
    /// Store error information for throwing errors
    var errorInfo: ErrorInfo = ErrorInfo(input: "", argIndex: -1);
    
    /// Perform Addition
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
    
    /// Perform Subtraction
    /// - Parameters:
    ///   - no1: First number
    ///   - no2: Second number
    /// - Returns: The subtraction  result
    func subtract(no1: Int, no2: Int) -> Int {
        return no1 - no2;
    }
    
    /// Perform Multiplication
    /// - Parameters:
    ///   - no1: First number
    ///   - no2: Second number
    /// - Returns: The multiplication result
    func multiply(no1: Int, no2: Int) -> Int {
        return no1 * no2;
    }
    
    /// Perform Division
    /// - Parameters:
    ///   - no1: First number
    ///   - no2: Second number
    /// - Returns: The division result
    func divide(no1: Int, no2: Int) throws -> Int {
        // Throw error if no2 is zero
        try validateNonZeroValOnDivision(no: no2);
        return no1 / no2;
    }
    
    /// Perform Modulus
    /// - Parameters:
    ///   - no1: First number
    ///   - no2: Second number
    /// - Returns: The modulus result
    func modulus(no1: Int, no2: Int) -> Int {
        return no1 % no2;
    }
    
    /// Validate value can be cast to an integer
    /// - Parameters:
    ///   - no: number
    ///   - argIndex: Argument index of number
    /// - Returns: Void
    func validateValue(no: String, argIndex: Int) throws {
        guard Int(no) != nil else {
            errorInfo.input = no;
            errorInfo.argIndex = argIndex;
            throw CalculatorError.invalidInteger(errorInfo: errorInfo);
        };
    }
    
    /// Validate operator is in supported operators lists
    /// - Parameters:
    ///   - operatorSymbol: operator
    ///   - argIndex: Argument index of operator
    /// - Returns: Void
    func validateOperator(operatorSymbol: String, argIndex: Int) throws {
        guard supportedOperations.contains(operatorSymbol) else {
            errorInfo.input = operatorSymbol;
            errorInfo.argIndex = argIndex;
            throw CalculatorError.invalidOperator(errorInfo: errorInfo);
        }
    }
    
    /// Validate number is not zero
    /// - Parameters:
    ///   - no: number
    /// - Returns: Void
    func validateNonZeroValOnDivision(no: Int) throws {
        guard no != 0 else {
            throw CalculatorError.invalidDivision;
        }
    }
    
    /// Validate arguements conforms to the pattern of [ (Int), (supported operator), (Int), ... ]
    /// - Parameters:
    ///   - args: equation
    /// - Returns: Void
    func validateArguments(args: [String]) throws {
        for (index, element) in args.enumerated() {
            if index % 2 == 0 {
                try validateValue(no: element, argIndex: index);
            } else {
                try validateOperator(operatorSymbol: element, argIndex: index);
            }
        }
    }
    
    /// Perform multiplication, division and modulus operations on arguments
    /// - Parameters:
    ///   - args: equation
    /// - Returns: The array with only addition and subtraction operations
    func performHighPrecedenceCal(args: [String]) throws -> [String] {
        var intermediateResult: [String] = [];
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
                lastValue = intermediateResult.removeLast();
                intermediateResult.append(
                    String(multiply(no1: Int(lastValue)!, no2: Int(args[index+1])!)));
                skipNextVal = true;
                break;
            case "/":
                lastValue = intermediateResult.removeLast();
                intermediateResult.append(
                    String(try divide(no1: Int(lastValue)!, no2: Int(args[index+1])!)));
                skipNextVal = true;
                break;
            case "%":
                lastValue = intermediateResult.removeLast();
                intermediateResult.append(
                    String(modulus(no1: Int(lastValue)!, no2: Int(args[index+1])!)));
                skipNextVal = true;
                break;
            default:
                intermediateResult.append(element);
                break;
            }
        }
        return intermediateResult;
    }
    
    /// Perform addition and subtraction on arguments
    /// - Parameters:
    ///   - args: equation with only additon and subtraction operations
    /// - Returns: The result of the equation
    func performLowPrecedenceCal(args: [String]) -> Int {
        var result = Int(args[0])!;
        
        for (index, element) in args.enumerated() {
            switch element {
            case "+":
                result = add(no1: result, no2: Int(args[index+1])!);
                break;
            case "-":
                result = subtract(no1: result, no2: Int(args[index+1])!);
                break;
            default:
                break;
            }
        }
        return result;
    }
    
    /// Perform calculation
    /// - Parameters:
    ///   - args: equation
    /// - Returns: The final result
    func calculate(args: [String]) throws -> String {
        // Calculate finalResult from the arguments.

        // Validate arguments to ensure they conform before calculation
        try validateArguments(args: args);

        // Perform multiplication, division and modulus operations
        let intermediateResult: [String] = try performHighPrecedenceCal(args: args);
        
        // Perform addition and subtraction operations
        let finalResult = performLowPrecedenceCal(args: intermediateResult);
        
        return(String(finalResult))
    }
}
