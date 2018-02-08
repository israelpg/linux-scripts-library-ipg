#!/bin/bash

read -p 'Enter url for wget to start downloading: ' url

repeat_wget wget -c $url
