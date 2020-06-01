load ../test_helper/bats-support/load
load ../test_helper/bats-assert/load

ROOT_FOLDER="../../"

source "$ROOT_FOLDER/src/extract_related_hooks.sh"


@test "Should throw an error when hooks.ini file is missing" {

  #Arrange
  local candidate_file="../assets/hooks_ini.files/missing.hooks.ini"
  local commit_group_lbl="pre-commit"
  #Act
  run extract_related_hooks $candidate_file $commit_group_lbl
  #Assert
  assert_failure 2
}


@test "Should throw an error when hooks.ini file is empty" {

  #Arrange
  local candidate_file="../assets/hooks_ini.files/hooks.ini.empty"
  local commit_group_lbl="pre-commit"
  #Act
  run extract_related_hooks $candidate_file $commit_group_lbl
  #Assert
  assert_failure 3
}

@test "When hooks.ini file contains only one hooks block and is the searched one, should return all hooks related" {

  #Arrange
  local candidate_file="../assets/hooks_ini.files/hooks.ini.one.valid.block"
  local commit_group_lbl="pre-commit"

  #Act
  run extract_related_hooks $candidate_file $commit_group_lbl

  #Assert
  assert_output  "task=hooks/precommit/task dummy=hooks/precommit/dummy"
}

@test "When hooks.ini file contains only one hooks block and is NOT the searched one, should return an empty string" {

  #Arrange
  local candidate_file="../assets/hooks_ini.files/hooks.ini.one.valid.block"
  local commit_group_lbl="not-found"

  #Act
  run extract_related_hooks $candidate_file $commit_group_lbl

  #Assert
  assert_output  ""
}

@test "When hooks.ini file contains more than one hooks block and first ones the searched one, should return list with candidate hooks" {

  #Arrange
  local candidate_file="../assets/hooks_ini.files/hooks.ini.two.valid.blocks"
  local commit_group_lbl="pre-commit"

  #Act
  run extract_related_hooks $candidate_file $commit_group_lbl

  #Assert
  assert_output  "task=hooks/precommit/task dummy=hooks/precommit/dummy"
}

@test "When hooks.ini file contains more than one hooks block and first ones the searched one, should return list with candidate hooks" {

  #Arrange
  local candidate_file="../assets/hooks_ini.files/hooks.ini.two.valid.blocks"
  local commit_group_lbl="post-commit"

  #Act
  run extract_related_hooks $candidate_file $commit_group_lbl

  #Assert
  assert_output  "task2=hooks/precommit/task2 dummy2=hooks/precommit/dummy2"
}

@test "When hooks.ini file contains more than hooks block and is NOT the searched one, should return an empty string" {

  #Arrange
  local candidate_file="../assets/hooks_ini.files/hooks.ini.two.valid.blocks"
  local commit_group_lbl="not-found"

  #Act
  run extract_related_hooks $candidate_file $commit_group_lbl

  #Assert
  assert_output  ""
}

@test "When hooks.ini file contains one repeated hooks block should return an error" {
  #Arrange
  local candidate_file="../assets/hooks_ini.files/hooks.ini.repeated.valid.blocks"
  local commit_group_lbl="pre-commit"

  #Act
  run extract_related_hooks $candidate_file $commit_group_lbl

  #Assert
  assert_failure 1
}

