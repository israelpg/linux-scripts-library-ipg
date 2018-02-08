#!/bin/bash

# In order to broadcast a message to all users in the different tty(s) .. use the wall function

echo "This is a message for all users" | wall

# or use a file:

cat filename | wall
