#!/bin/bash

# This script installs necessary tools for kernel development

# Update and install build tools and libraries
sudo apt-get update
sudo apt-get install -y build-essential vim git cscope libncurses-dev libssl-dev libelf-dev bison flex

# Install git-email for patch handling
sudo apt-get install -y git-email

