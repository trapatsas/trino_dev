#!/bin/bash

set -e

# Install Java 22
apt-get update && apt-get install -y wget tar libc6 libstdc++6
wget https://download.oracle.com/java/22/latest/jdk-22_linux-aarch64_bin.tar.gz -O /tmp/openjdk-22.tar.gz
mkdir -p /usr/lib/jvm
tar -xzf /tmp/openjdk-22.tar.gz -C /usr/lib/jvm
rm /tmp/openjdk-22.tar.gz

# Set JAVA_HOME and update PATH
JAVA_HOME=/usr/lib/jvm/jdk-22.0.1
echo "export JAVA_HOME=$JAVA_HOME" >> /etc/zsh/zshrc
echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/zsh/zshrc

# Apply the environment changes for the current session
export JAVA_HOME=$JAVA_HOME
export PATH=$JAVA_HOME/bin:$PATH
