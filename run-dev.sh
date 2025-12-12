#!/bin/bash
# Bash script to run the GUI wallet in development mode
# This sets the OpenSSL legacy provider before running npm

export NODE_OPTIONS=--openssl-legacy-provider
npm run dev

