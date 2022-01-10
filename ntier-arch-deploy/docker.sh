#!/usr/bin/env bash

docker build -t ioram/ntier-build-runner:latest .
docker push ioram/ntier-build-runner:latest
