#!/bin/sh
# to replicate in case of recreation as template
if [ "x$(git remote|grep upstream)" == "x" ] ; then
    git remote add upstream git@github.com:faisalmaqbool94/dbt-exercise.git
fi
git pull upstream main