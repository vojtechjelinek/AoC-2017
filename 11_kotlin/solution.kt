import java.io.File
import kotlin.math.*

data class Coords(val x: Int, val y: Int, val z: Int) {
  operator fun plus(other: Coords): Coords {
    return Coords(x + other.x, y + other.y, z + other.z)
  }

  val distanceToStart: Int =
    (abs(x) + abs(y) + abs(z)) / 2
}

fun getMoveCoords(move: String): Coords =
  when (move) {
      "n"  -> Coords( 0,  1, -1)
      "ne" -> Coords( 1,  0, -1)
      "nw" -> Coords(-1,  1,  0)
      "s"  -> Coords( 0, -1,  1)
      "se" -> Coords( 1, -1,  0)
      "sw" -> Coords(-1,  0,  1)
      else -> Coords( 0,  0,  0)
  }

fun main(args: Array<String>) {
    val moves = File("input.txt").readText().trim().split(",")
    var coords = Coords(0, 0, 0)
    var maxDistance = 0
    for (move in moves) {
      coords += getMoveCoords(move)
      if (coords.distanceToStart > maxDistance) {
        maxDistance = coords.distanceToStart
      }
    }

    println(coords.distanceToStart)
    println(maxDistance)
}
