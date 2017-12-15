import scala.io.Source;

object Solution {
  def traverse_program(id: String, values: Map[String, Int], connections: Map[String, Set[String]]): Tuple2[Int, Int] = {
	if (connections contains id) {
    var possible_child_weights: Tuple2[Int, Int] = (-1, -1)
    var possible_child_weights_sums: Tuple2[Int, Int] = (-1, -1)
    var childs_sums = 0
    for ((child, i) <- connections(id).zipWithIndex) {
      val weight_info: Tuple2[Int, Int] = traverse_program(child, values, connections)
      val weight_sum: Int = weight_info._1 + weight_info._2
      childs_sums += weight_sum
      if (possible_child_weights_sums._1 == -1) {
        possible_child_weights = possible_child_weights.copy(_1 = weight_info._2)
        possible_child_weights_sums = possible_child_weights_sums.copy(_1 = weight_sum)
      } else if (possible_child_weights_sums._2 == -1) {
        possible_child_weights = possible_child_weights.copy(_2 = weight_info._2)
        possible_child_weights_sums = possible_child_weights_sums.copy(_2 = weight_sum)
      } else if (possible_child_weights_sums._2 == possible_child_weights_sums._1) {
        if (weight_sum != possible_child_weights_sums._1) {
          val difference = weight_sum - possible_child_weights._1
          println(weight_sum + difference)
          System.exit(0)
        }
      } else {
        if (weight_sum == possible_child_weights_sums._1) {
          val difference = possible_child_weights_sums._2 - weight_sum
          println(possible_child_weights._2 - difference)
          System.exit(0)
        } else if (weight_sum == possible_child_weights_sums._2) {
          val difference = possible_child_weights_sums._1 - weight_sum
          println(possible_child_weights._1 - difference)
          System.exit(0)
        }
      }
    }
    (childs_sums, values(id))
  } else {
    (0, values(id))
  }
}

  def main(args: Array[String]) {
    val lines = Source.fromFile("input.txt").getLines
    var values: Map[String, Int] = Map()
    var connections: Map[String, Set[String]] = Map()
    var has_childs: Set[String] = Set()
    var is_child: Set[String] = Set()
    for (line <- lines) {
      var id_weight = line
      var childs: Set[String] = Set()
      if (line matches ".*->.*") {
        val splited = line split " -> "
        id_weight = splited(0)
        childs = (splited(1) split ", ").toSet
      }
      val open_bracket = (id_weight indexOf "(")
      val close_bracket = id_weight indexOf ")"
      val id = id_weight slice (0, open_bracket - 1)
      val weight = (id_weight slice (open_bracket + 1, close_bracket)).toInt
      values = values + (id -> weight)
      if (childs.nonEmpty) {
        has_childs = has_childs + id
        childs foreach {
          child_id => is_child = is_child + child_id
        }
      	connections = connections + (id -> childs)
      }
    }
    val root_node_id = (has_childs -- is_child).head
    println(root_node_id)
    traverse_program(root_node_id, values, connections)
  }
}
