#!/usr/bin/env bats

ROOT_FOLDER=`git rev-parse --show-toplevel`
TEST_FOLDER="$ROOT_FOLDER/test"

source "$ROOT_FOLDER/test/test_helper/bats-support/load.bash"
source "$ROOT_FOLDER/test/test_helper/bats-file/load.bash"

function setup() {
    local sample_project="/tmp/bats_sample_project"
    echo ${sample_project}
    mkdir -p "${sample_project}"
    (
	cd ${sample_project}
	git init
    )
}

function teardown() {
    local sample_project="/tmp/bats_sample_project"
    rm -r "${sample_project}"
}

@test " gittem -i should install git hooks inside destination repo once called one time" {

  #Arrange
  local sample_project="/tmp/bats_sample_project"   

  #Act
  pushd ${sample_project}
  ${ROOT_FOLDER}/gittem.sh -i
  popd

  #Assert
  assert_file_exist ${sample_project}/.git/gittem/.config
  assert_file_exist ${sample_project}/.git/gittem/hooks/

}

@test " gittem -i should install git hooks inside destination correctly repo once called twice" {

  #Arrange
  local sample_project="/tmp/bats_sample_project"   

  #Act
  pushd ${sample_project}
  ${ROOT_FOLDER}/gittem.sh -i
  ${ROOT_FOLDER}/gittem.sh -i
  popd

  #Assert
  assert_file_exist ${sample_project}/.git/gittem/.config
  assert_file_exist ${sample_project}/.git/gittem/hooks/
  assert_file_not_exist ${sample_project}/.git/gittem/hooks/hooks
}
