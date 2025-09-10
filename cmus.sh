#!/usr/bin/env bash

cmus-remote -Q | grep 'stream ' | cut -d' ' -f2-
