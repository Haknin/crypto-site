#!/bin/bash

# Check if the site is running by making a GET request to the homepage
response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5000)

# If the response code is 200, the site is running
if [[ $response -eq 200 ]]; then
    echo "Site is running"
    exit 0  # Exit with success status
else
    echo "Site is not running"
    exit 1  # Exit with failure status
fi
