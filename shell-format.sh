#!/usr/bin/env bash

shfmt -i 4 --bn -ci -kp "$1" || exit 1
