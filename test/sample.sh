load "./test_helper/bats-assert/load"

@test "addition using bc" {
  result="$(echo 2+2 | bc)"
  assert_equal "$result" 4
}

@test "addition using dc" {
  result="$(echo 2 2+p | dc)"
  assert_equal "$result" 4
}
