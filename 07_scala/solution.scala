import scala.io.Source;

object Solution {
  def traverse_program(id: String, values: Map[String, Int], connections: Map[String, Set[String]]): Tuple2 = {
	if (connections contains id) {
    var child_weight: Int = 0
    var weight_sum: Int = 0
    for (child <- connections(id)) {
      val weight = traverse_program(child, values, connections)
      if (child_weight > 0) {
        if (weight != child_weight) {
          val difference = child_weight - weight
          System.exit(0)
        }
      } else {
        child_weight = weight
      }
      weight_sum += weight
    }
    weight_sum + values(id)
  } else {
    values(id)
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
