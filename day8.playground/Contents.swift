import UIKit

let input = """
"""

extension String {
  var isUniqueCharacter: Bool {
    return [2,3,4,7].contains(count)
  }

  func removingCharacters(from input: String) -> String {
    var result: String = self
    for character in input {
      result = result.replacingOccurrences(of: String(character), with: "")
    }
    return result
  }

  func contains(input: String) -> Bool {
    Set(self).isSuperset(of: input)
  }
}

let lines = input.split(whereSeparator: \.isNewline).map { String($0).split(separator: "|").map { String($0)} }

let digits = lines.map{ $0[1] }.map { $0.split(whereSeparator: \.isWhitespace ).map{ String($0) }}
let signals = lines.map{ $0[0] }.map { $0.split(whereSeparator: \.isWhitespace ).map { String($0)}}


extension Array where Element == String {

  var one: String {
    first { $0.count == 2 }!
  }

  var seven: String {
    first { $0.count == 3 }!
  }

  var four: String {
    first { $0.count == 4 }!
  }

  var eight: String {
    first { $0.count == 7 }!
  }

  var top: String {
    seven.removingCharacters(from: one)
  }

  var topleftAndMiddle: String {
    four.removingCharacters(from: one)
  }

  var bottomLeftAndBottom: String {
    eight.removingCharacters(from: four).removingCharacters(from: top)
  }

  var nine: String {
    first { $0.contains(input: four + top) && $0 != eight }!
  }

  var bottomLeft: String {
    eight.removingCharacters(from: nine)
  }

  var bottom: String {
    bottomLeftAndBottom.removingCharacters(from: bottomLeft)
  }

  var six: String {
    first { $0.contains(input: top  + topleftAndMiddle + bottomLeftAndBottom ) && $0 != eight}!
  }

  var topRight: String {
    eight.removingCharacters(from: six)
  }

  var zero: String {
    first { $0.contains(input: seven + bottomLeftAndBottom ) && $0 != eight }!
  }

  var topLeft: String {
    zero.removingCharacters(from: seven + bottomLeftAndBottom)
  }

  var middle: String {
    topleftAndMiddle.removingCharacters(from: topLeft)
  }

  var two: String {
    first { $0.contains(input: top + bottomLeftAndBottom + topRight + middle) && $0 != eight }!
  }

  var three: String {
    first { $0.contains(input: seven + bottom + middle ) && $0 != eight && $0 != nine }!
  }

  var five: String {
    six.removingCharacters(from: bottomLeft)
  }

  func intValue(for input: String) -> Int {
    switch Set(input) {
    case Set(zero):
      return 0
    case Set(one):
      return 1
    case Set(two):
      return 2
    case Set(three):
      return 3
    case Set(four):
      return 4
    case Set(five):
      return 5
    case Set(six):
      return 6
    case Set(seven):
      return 7
    case Set(eight):
      return 8
    default:
      return 9
    }
  }
}

extension Array where Element == Int {
  var number: Int {
   let string =  map { String($0)}.joined()
    return Int(string)!
  }
}

var total: Int = 0
for signalAndDigit in zip(signals, digits) {
  print(signalAndDigit.1)
  let decoded = signalAndDigit.1.map { signalAndDigit.0.intValue(for: $0) }
  print(decoded.number)
  total += decoded.number
}

print(total)

