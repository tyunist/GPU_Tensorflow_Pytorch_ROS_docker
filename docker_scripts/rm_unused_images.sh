#!/usr/bin/bash
docker rmi -f $(docker images -q -f dangling=true)
