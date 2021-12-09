import UIKit

let input = """
2199943210
3987894921
9856789892
8767896789
9899965678
"""

let map = input.split(whereSeparator: \.isNewline).map { Array($0).map { String($0) }.map { Int($0)!} }

struct Coord {
  let x: Int
  let y: Int
  let value: Int
}

print(map.count)

var lowPoint: [Int] = []
var lowPointCoord: [Coord] = []

for row in map.enumerated() {

  for height in row.element.enumerated() {
    //check if previous row has lower value
    if row.offset > 0 {
      if map[row.offset - 1][height.offset] <= height.element {
        continue
      }
    }

    //check if next row has lower value
    if row.offset < (map.count - 1) {
      if map[row.offset + 1][height.offset] <= height.element {
        continue
      }
    }

    //check if prev element has lower value
    if height.offset > 0 {
      if row.element[height.offset - 1] <= height.element {
        continue
      }
    }

    //check if next element has lower value
    if height.offset < (row.element.count - 1){
      if row.element[height.offset + 1] <= height.element {
        continue
      }
    }

    lowPoint.append(height.element)
    lowPointCoord.append(Coord(x: height.offset, y: row.offset, value: height.element))
  }
}

print(lowPoint)
print(lowPointCoord)

let score = lowPoint.map { $0 + 1}.reduce(0, +)
print(score)

func higherCoords(from coord: Coord) -> [Coord] {

  var higher: [Coord] = []

//values to the left
  if coord.x > 0 {
    for x in (coord.x - 1)...0 {
      if map[coord.y][x] <= coord.value || map[coord.y][x] == 9 {
        break
      }
      higher.append(Coord(x: x, y: coord.y, value: map[coord.y][x]))
    }
  }

  //values to the right
  if coord.x < (map[0].count - 1)  {
    for x in (coord.x + 1)...map[0].count {
      if map[coord.y][x] <= coord.value || map[coord.y][x] == 9{
          break
        }
      higher.append(Coord(x: x, y: coord.y, value: map[coord.y][x]))
      }
    }

  //values above
  if coord.y > 0 {
    for y in (coord.y - 1)...0 {
      if map[y][coord.x] <= coord.value || map[y][coord.x] == 9 {
        break
      }
      higher.append(Coord(x: coord.x, y: y, value: map[y][coord.x]))
    }
  }

  //values below
  if coord.y < (map.count - 1)  {
    for y in (coord.y + 1)...map.count {
      print(y)
      if map[y][coord.x] <= coord.value || map[y][coord.x] == 9 {
        break
      }
      higher.append(Coord(x: coord.x, y: y, value: map[y][coord.x]))
    }
  }

  return higher
}

print(higherCoords(from: lowPointCoord[0]))

func basinSize(for startCoord: Coord) -> Int {

  var coords: [Coord] = higherCoords(from: startCoord)

  for coord in coords {
    coords += higherCoords(from: coord)
  }

  return coords.count + 1
}

print(basinSize(for: lowPointCoord[1]))
