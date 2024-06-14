import Foundation

struct CreditFormatter {
    func string(for credits: Int) -> String {
        if credits <= 1 {
            return "\(credits) credit"
        } else {
            return "\(credits) credits"
        }
    }
}
