#!/bin/bash

# prepare a new Ubuntu 13.10 image
pushd prepare_ubuntu
  docker build -rm -t prepared_ubuntu .
popd

# install OpenProject in that prepared image
pushd install_openproject
  docker build -rm -t openproject_evaluation .
popd
