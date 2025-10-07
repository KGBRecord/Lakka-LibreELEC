# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2025-present KGB Record

PKG_NAME="openjdk"
PKG_VERSION="8u422-b05"
PKG_SHA256=""
PKG_LICENSE="GPLv2"
PKG_SITE="https://adoptium.net/"
PKG_LONGDESC="Eclipse Temurin OpenJDK 8u422 for LibreELEC/Lakka with BusyBox compatibility"
PKG_TOOLCHAIN="manual"

# Architecture-specific JDK packages - Eclipse Temurin OpenJDK 8u422
if [ "${TARGET_ARCH}" = "x86_64" ]; then
  PKG_URL="https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u422-b05/OpenJDK8U-jdk_x64_linux_hotspot_8u422b05.tar.gz"
  PKG_SHA256=""  # Will be calculated during build
elif [ "${TARGET_ARCH}" = "aarch64" ]; then
  PKG_URL="https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u422-b05/OpenJDK8U-jdk_aarch64_linux_hotspot_8u422b05.tar.gz"
  PKG_SHA256=""  # Will be calculated during build
elif [ "${TARGET_ARCH}" = "arm" ]; then
  PKG_URL="https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u422-b05/OpenJDK8U-jdk_arm_linux_hotspot_8u422b05.tar.gz"
  PKG_SHA256=""  # Will be calculated during build
else
  # For other architectures, we'll need to handle separately or skip
  echo "Unsupported architecture for OpenJDK: ${TARGET_ARCH}"
  exit 1
fi

post_unpack() {
  # Remove source zip file if present
  rm -f ${PKG_BUILD}/src.zip
  
  # Eclipse Temurin extracts to jdk8u422-b05 directory, move contents up
  if [ -d ${PKG_BUILD}/jdk8u422-b05 ]; then
    mv ${PKG_BUILD}/jdk8u422-b05/* ${PKG_BUILD}/
    rmdir ${PKG_BUILD}/jdk8u422-b05
  fi
  
  # For ARM, adjust library paths for compatibility if needed
  if [ "${TARGET_ARCH}" = "arm" ]; then
    if [ -d ${PKG_BUILD}/jre/lib/aarch32 ]; then
      mv ${PKG_BUILD}/jre/lib/aarch32    ${PKG_BUILD}/jre/lib/arm
      mv ${PKG_BUILD}/jre/lib/arm/client ${PKG_BUILD}/jre/lib/arm/server
    fi
  fi
}

makeinstall_target() {
  # Install full JDK to system (includes both JRE and development tools)
  mkdir -p ${INSTALL}/usr/lib/java
  cp -PR ${PKG_BUILD}/* ${INSTALL}/usr/lib/java/
  
  # Create symlinks for java executables in /usr/bin
  mkdir -p ${INSTALL}/usr/bin
  ln -sf /usr/lib/java/bin/java ${INSTALL}/usr/bin/java
  ln -sf /usr/lib/java/bin/javac ${INSTALL}/usr/bin/javac
  ln -sf /usr/lib/java/bin/jar ${INSTALL}/usr/bin/jar
  ln -sf /usr/lib/java/bin/javap ${INSTALL}/usr/bin/javap
  ln -sf /usr/lib/java/bin/javadoc ${INSTALL}/usr/bin/javadoc
  ln -sf /usr/lib/java/bin/jdb ${INSTALL}/usr/bin/jdb
  ln -sf /usr/lib/java/bin/keytool ${INSTALL}/usr/bin/keytool
  
  # LibreELEC uses /etc/profile which is sourced by BusyBox ash shell
  # Add Java environment to the main profile
  mkdir -p ${INSTALL}/etc
  cat >> ${INSTALL}/etc/profile << 'EOF'

# Java Environment Variables - added by OpenJDK package
JAVA_HOME="/usr/lib/java"
JRE_HOME="/usr/lib/java/jre"
PATH="/usr/lib/java/bin:${PATH}"
CLASSPATH=".:${JAVA_HOME}/lib:${JRE_HOME}/lib"
export JAVA_HOME JRE_HOME PATH CLASSPATH
EOF
  
  # Create LibreELEC autostart script (runs after boot)
  mkdir -p ${INSTALL}/storage/.config
  cat > ${INSTALL}/storage/.config/autostart.sh << 'EOF'
#!/bin/sh
# Java environment setup for LibreELEC/Lakka
# This script runs automatically after system startup

# Set Java environment variables
JAVA_HOME="/usr/lib/java"
JRE_HOME="/usr/lib/java/jre"
PATH="/usr/lib/java/bin:${PATH}"
CLASSPATH=".:${JAVA_HOME}/lib:${JRE_HOME}/lib"
export JAVA_HOME JRE_HOME PATH CLASSPATH

# Make sure these are available for all subsequent processes
echo "export JAVA_HOME=\"${JAVA_HOME}\"" >> /storage/.profile
echo "export JRE_HOME=\"${JRE_HOME}\"" >> /storage/.profile
echo "export PATH=\"${PATH}\"" >> /storage/.profile
echo "export CLASSPATH=\"${CLASSPATH}\"" >> /storage/.profile

# Create Java temp directory
mkdir -p /tmp/java
chmod 1777 /tmp/java 2>/dev/null || true

# Log setup completion
echo "Java environment configured successfully" > /tmp/java-setup.log
EOF
  chmod +x ${INSTALL}/storage/.config/autostart.sh
  
  # Create systemd environment file for services (if systemd exists)
  mkdir -p ${INSTALL}/usr/lib/systemd/system.conf.d
  cat > ${INSTALL}/usr/lib/systemd/system.conf.d/java.conf << 'EOF'
[Manager]
DefaultEnvironment="JAVA_HOME=/usr/lib/java"
DefaultEnvironment="JRE_HOME=/usr/lib/java/jre"
DefaultEnvironment="PATH=/usr/lib/java/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
DefaultEnvironment="CLASSPATH=.:/usr/lib/java/lib:/usr/lib/java/jre/lib"
EOF
}

post_install() {
  # LibreELEC-specific: No systemd service enablement needed
  # The autostart.sh script will handle Java environment setup
  echo "Java environment will be automatically configured on first boot"
}