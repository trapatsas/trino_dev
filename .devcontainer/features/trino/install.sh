#!/bin/bash

set -e

# Install Trino CLI
wget https://repo1.maven.org/maven2/io/trino/trino-cli/448/trino-cli-448-executable.jar -O /usr/local/bin/trino
chmod +x /usr/local/bin/trino

# Install libs for Trino server
apt update -y && apt install -y zlib1g-dev libjpeg-dev libxml2-dev libxslt-dev build-essential xsltproc

# Download and set up Trino server
wget https://repo1.maven.org/maven2/io/trino/trino-server/448/trino-server-448.tar.gz -O /tmp/trino-server.tar.gz
mkdir -p /opt/trino
tar -xzf /tmp/trino-server.tar.gz -C /opt/trino --strip-components=1
rm /tmp/trino-server.tar.gz

# Ensure directories exist
mkdir -p /opt/trino/etc
mkdir -p /var/trino/data
sudo chown -R vscode:vscode /opt/trino /var/trino

# Configuration files
cat <<EOF > /opt/trino/etc/node.properties
node.environment=production
node.id=ffffffff-ffff-ffff-ffff-ffffffffffff
node.data-dir=/var/trino/data
EOF

cat <<EOF > /opt/trino/etc/jvm.config
-server
-Xmx16G
-XX:InitialRAMPercentage=80
-XX:MaxRAMPercentage=80
-XX:G1HeapRegionSize=32M
-XX:+ExplicitGCInvokesConcurrent
-XX:+ExitOnOutOfMemoryError
-XX:+HeapDumpOnOutOfMemoryError
-XX:-OmitStackTraceInFastThrow
-XX:ReservedCodeCacheSize=512M
-XX:PerMethodRecompilationCutoff=10000
-XX:PerBytecodeRecompilationCutoff=10000
-Djdk.attach.allowAttachSelf=true
-Djdk.nio.maxCachedBufferSize=2000000
-Dfile.encoding=UTF-8
-XX:+EnableDynamicAgentLoading
EOF

cat <<EOF > /opt/trino/etc/config.properties
coordinator=true
node-scheduler.include-coordinator=true
http-server.http.port=9090
discovery.uri=http://localhost:9090
EOF

mkdir -p /opt/trino/etc/catalog
cat <<EOF > /opt/trino/etc/catalog/jmx.properties
connector.name=jmx
EOF

cat <<EOF > /opt/trino/etc/catalog/memory.properties
connector.name=memory
EOF

# Create a script to start Trino server
cat <<EOF > /usr/local/bin/start-trino
#!/bin/bash
/opt/trino/bin/launcher run
EOF
chmod +x /usr/local/bin/start-trino
