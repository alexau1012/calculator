//
//  Calculator.swift
//  calc
//
//  Created by Jacktator on 31/3/20.
//  Copyright © 2020 UTS. All rights reserved.
//

import Foundation

class Calculator {
    
    /// For multi-step calculation, it's helpful to persist existing result
    var currentResult = 0;
    
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
    
    func divide(no1: Int, no2: Int) -> Int {
        return no1 / no2;
    }
    
    func modulo(no1: Int, no2: Int) -> Int {
        return no1 % no2;
    }
    
    func calculate(args: [String]) -> String {
        // Todo: Calculate Result from the arguments. Replace dummyResult with your actual result;
        // This array should only hold addition and subtraction
        var intermediateResults: [String] = [];
        var skipNextVal: Bool = false;
        
        for (index, element) in args.enumerated() {
            if skipNextVal == true {
                skipNextVal = false;
                continue;
            }
            
            var lastValue: String;
            switch element {
            case "*":
                lastValue = intermediateResults.removeLast();
                intermediateResults.append(
                    String(multiply(no1: Int(lastValue)!, no2: Int(args[index+1])!)));
                skipNextVal = true;
                break;
            case "/":
                lastValue = intermediateResults.removeLast();
                intermediateResults.append(
                    String(divide(no1: Int(lastValue)!, no2: Int(args[index+1])!)));
                skipNextVal = true;
                break;
            case "%":
                lastValue = intermediateResults.removeLast();
                intermediateResults.append(
                    String(modulo(no1: Int(lastValue)!, no2: Int(args[index+1])!)));
                skipNextVal = true;
                break;
            default:
                intermediateResults.append(element);
                break;
            }
        }
            
        print(intermediateResults);
        
        var result: Int = Int(intermediateResults[0])!;
        
        for (index, element) in intermediateResults.enumerated() {
            switch element {
            case "+":
                result = add(no1: result, no2: Int(intermediateResults[index+1])!);
                break;
            case "-":
                result = subtract(no1: result, no2: Int(intermediateResults[index+1])!);
                break;
            default:
                break;
            }
        }
        
        return(String(result))
    }
}
