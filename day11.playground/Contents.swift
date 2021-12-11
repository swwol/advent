import UIKit

let input = """
4585612331
5863566433
6714418611
1746467322
6161775644
6581631662
1247161817
8312615113
6751466142
1161847732
"""
extension Array where Element == [Int] {
  func render() {
    for row in self {
      let strings = row.map {String($0)}.joined()
      print(strings)
    }
  }
}
extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

var intArray = input.split(whereSeparator: \.isNewline).map { Array($0).map { Int(String($0))!} }

var flashes = 0

func iterate( perform: (Int, Int) -> Void) {
  for row in 0..<intArray.count {
    for column in 0..<intArray[0].count {
      perform(row, column)
    }
  }
}

func flash(row: Int, column: Int) {
  if intArray[row][column] > 9 {
    intArray[row][column] = 0
    flashes += 1
    //iterate neighbours
    //right
    if let right = intArray[row][safe: column + 1], right != 0 {
      intArray[row][column + 1] += 1
    }
    //left
    if let left = intArray[row][safe: column - 1], left != 0 {
      intArray[row][column - 1] += 1
    }
    //up
    if let up = intArray[safe: row - 1]?[column], up != 0 {
      intArray[row - 1][column] += 1
    }
    //down
    if let down = intArray[safe: row + 1]?[column], down != 0 {
      intArray[row + 1][column] += 1
    }
    //downright
    if let downRight = intArray[safe: row + 1]?[safe: column + 1], downRight != 0 {
      intArray[row + 1][column + 1] += 1
    }
    //downLeft
    if let downLeft = intArray[safe: row + 1]?[safe: column - 1], downLeft != 0 {
      intArray[row + 1][column - 1] += 1
    }
    //upright
    if let upRight = intArray[safe: row - 1]?[safe: column + 1], upRight != 0 {
      intArray[row - 1][column + 1] += 1
    }
    //upLeft
    if let upLeft = intArray[safe: row - 1]?[safe: column - 1], upLeft != 0 {
      intArray[row - 1][column - 1] += 1
    }
  }
}

func step() {
// add one to all elements
  iterate { intArray[$0][$1] += 1}
  while intArray.flatMap({$0}).contains(where: { $0 > 9 }) {
    iterate(perform: flash)
  }
  intArray.render()
}

for n in 0..<2000 {
  step()
  if intArray.flatMap({$0}).allSatisfy({ $0 == 0 }) {
    print(n)
    break
  }
}
