import 'dart:io';

enum State {
  group, garbage, garbage_skip
}

var current_state = State.group;
var current_depth = 0;
var groups_sum = 0;
var n_noncanceled_chars = 0;

void evaluate_char(String char) {
  switch (current_state) {
    case State.group:
      group_state(char);
      break;
    case State.garbage:
      garbage_state(char);
      break;
    case State.garbage_skip:
      garbage_skip_state(char);
      break;
  }
}

void group_state(String char) {
  switch (char) {
    case '<':
      current_state = State.garbage;
      break;
    case '{':
      current_depth++;
      break;
    case '}':
      groups_sum += current_depth;
      current_depth--;
      break;
  }
}


void garbage_state(String char) {
  switch (char) {
    case '>':
      current_state = State.group;
      break;
    case '!':
      current_state = State.garbage_skip;
      break;
    default:
      n_noncanceled_chars++;
  }
}

void garbage_skip_state(String char) {
  current_state = State.garbage;
}

void main() {
  File file = new File('input.txt');
  var stream = file.readAsStringSync().split('');
  for (var char in stream) {
    evaluate_char(char);
  }
  print(groups_sum);
  print(n_noncanceled_chars);
}
