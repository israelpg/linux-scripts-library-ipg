#!/bin/bash

ifconfig | cut -c-10 | tr -d ' ' | tr -s '\n'
