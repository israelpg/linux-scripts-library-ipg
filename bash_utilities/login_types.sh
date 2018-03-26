#!/bin/bash

# Scenario: I am connected as ip14aai, and I want to login as pepe, two ways:

# 1/ Keeping the session of main user (ip14aai, incl home):
su pepe

# 2/ login with the other user, with the home and so on:
su -l pepe

## then to login as root:

su
