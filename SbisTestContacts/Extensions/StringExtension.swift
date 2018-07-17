//
//  StringExtension.swift
//  SbisTestContacts
//
//  Created by Евгений Стадник on 12.07.2018.
//  Copyright © 2018 Евгений Стадник. All rights reserved.
//

import Foundation

extension String {
    
    func removeAllWhiteSpases() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    func removeAllDashes() -> String {
        return self.replacingOccurrences(of: "-", with: "")
    }
    
    func removeAllBrackets() -> String {
        return self.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
    }
    
    func removeFirtCharactersPlusOrSevenSighn() -> String {
        let unicodeScalarsdPhone = self.unicodeScalars
        var formatedPhone: [UnicodeScalar] = []
        for value in unicodeScalarsdPhone {
            if value == UnicodeScalar(43) {
            } else {
                formatedPhone.append(value)
            }
        }
        return String(String.UnicodeScalarView(formatedPhone))
    }
    
    private func deleteAllUnused() -> String {
        return self.removeAllWhiteSpases().removeAllDashes().removeAllBrackets().removeFirtCharactersPlusOrSevenSighn()
    }
    
    func stringExtensioncustomReduce<T>(_ initialValue: T, combine: (T, Element, Int) -> T) -> T {
        var result = initialValue
        var count = 0
        for value in self {
            result = combine(result, value, count)
            count += 1
        }
        return result
    }
    
    func createTruePhoneNumber() -> String {
        let returnedString = String(self.deleteAllUnused().dropFirst()).stringExtensioncustomReduce("8 (") { (result, next, count) -> String in
            
            if count < 3 {
                return result + String(next)
            } else if count == 3 {
                return result + ") " + String(next)
            } else if count == 4 {
                return result + String(next)
            } else if count == 5 {
                return result + String(next) + "-"
            } else if count == 6 {
                return result + String(next)
            } else if count == 7 {
                return result + String(next) + "-"
            } else if count == 8 {
                return result + String(next)
            } else if count == 9 {
                return result + String(next)
            }
            return result
        }
        return returnedString
    }
    
}
