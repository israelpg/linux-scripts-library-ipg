#!/bin/bash

sudo cat mate.txt | xargs -I {} mkdir {}
