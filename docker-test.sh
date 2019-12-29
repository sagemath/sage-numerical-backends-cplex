#! /bin/bash
# First run ./docker-setup.sh
set -e
for v in 12.10; do
    docker build --build-arg CPLEX_VERSION=$v -t private/sage-cplex-$v .
done
