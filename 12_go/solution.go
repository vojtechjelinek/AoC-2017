package main

// Import declaration declares library packages referenced in this file.
import (
    "fmt"       // A package in the Go standard library.
    "io/ioutil" // Implements some I/O utility functions.
    //m "math"    // Math library with local alias m.
    "strconv"   // String conversions.
    "strings"
)

func part1(connectionsMap map[int][]int) {
    visitedPrograms := map[int]bool {}
    toVisit := []int {0}
    var nextToVisit []int
    for {
        if len(toVisit) == 0 {
            break
        }
        nextToVisit := make([]int, 0)
        for _, program := range toVisit {
            visitedPrograms[program] = true
            connectedPrograms := connectionsMap[program]
            for _, connectedProgram := range connectedPrograms {
                _, beenVisited := visitedPrograms[connectedProgram]
                if !beenVisited {
                    nextToVisit = append(nextToVisit, connectedProgram)
                }
            }
        }
        toVisit = nextToVisit
    }
    _ = nextToVisit
    fmt.Println(len(visitedPrograms))
}

func part2(connectionsMap map[int][]int) {
  visitedPrograms := map[int]bool {}
  nGroups := 0
  for i := 0; i < len(connectionsMap); i++ {
      _, visited := visitedPrograms[i]
      if visited {
          continue
      }
      nGroups++
      toVisit := []int {i}
      var nextToVisit []int
      for {
          if len(toVisit) == 0 {
              break
          }
          nextToVisit := make([]int, 0)
          for _, program := range toVisit {
              visitedPrograms[program] = true
              connectedPrograms := connectionsMap[program]
              for _, connectedProgram := range connectedPrograms {
                  _, visited := visitedPrograms[connectedProgram]
                  if !visited {
                      nextToVisit = append(nextToVisit, connectedProgram)
                  }
              }
          }
          toVisit = nextToVisit
      }
      _ = nextToVisit
  }
  fmt.Println(nGroups)
}

func main() {
    b, _ := ioutil.ReadFile("input.txt")
    connections := strings.Split(strings.TrimSpace(string(b)), "\n")

    connectionsMap := map[int][]int {}
    for _, connection := range connections {
        connection := strings.Split(connection, " <-> ")
        from, _ := strconv.Atoi(connection[0])
        toStringList := strings.Split(connection[1], ", ")
        toIntList := []int {}
        for _, toString := range toStringList {
            toInt, _ := strconv.Atoi(toString)
            toIntList = append(toIntList, toInt)
        }
        connectionsMap[from] = toIntList
    }
    part1(connectionsMap)
    part2(connectionsMap)

}
