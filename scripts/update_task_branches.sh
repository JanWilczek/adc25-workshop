#!/bin/bash

git checkout task4a && \
  git merge main && \
git checkout task3a && \
  git merge task4a && \
git checkout task2a && \
  git merge task3a && \
git checkout task1a && \
  git merge task2a && \
git checkout main

