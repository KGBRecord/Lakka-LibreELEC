#!/bin/bash
set -e

# Fix permissions for mounted volumes
echo "Fixing permissions for build directories..."

# List of all build directories that might be mounted as volumes
BUILD_DIRS=(
    "build.Lakka-Generic.x86_64"
    "build.Lakka-Generic.i386"
    "build.Lakka-wayland.x86_64"
    "build.Lakka-x11.x86_64"
    "build.Lakka-RPi.arm"
    "build.Lakka-RPi2.arm"
    "build.Lakka-RPi3.aarch64"
    "build.Lakka-RPi4.aarch64"
    "build.Lakka-RPi5.aarch64"
    "build.Lakka-RPiZero-GPiCase.arm"
    "build.Lakka-RPiZero2-GPiCase.arm"
    "build.Lakka-RPiZero2-GPiCase2W.aarch64"
    "build.Lakka-RPi4-GPiCase2.aarch64"
    "build.Lakka-RPi4-PiBoyDmg.aarch64"
    "build.Lakka-RPi4-RetroDreamer.aarch64"
    "build.Lakka-A64.aarch64"
    "build.Lakka-H2-plus.arm"
    "build.Lakka-H3.arm"
    "build.Lakka-H5.aarch64"
    "build.Lakka-H6.aarch64"
    "build.Lakka-H616.aarch64"
    "build.Lakka-R40.arm"
    "build.Lakka-AMLGX.aarch64"
    "build.Lakka-Switch.aarch64"
    "build.Lakka-iMX6.arm"
    "build.Lakka-iMX8.aarch64"
    "build.Lakka-RK3288.arm"
    "build.Lakka-RK3328.aarch64"
    "build.Lakka-RK3399.aarch64"
    "build.Lakka-Exynos.arm"
    "build.Lakka-Odin.aarch64"
)

# Create and fix permissions for build directories
for dir in "${BUILD_DIRS[@]}"; do
    if [ -d "/lakka-libreelec/$dir" ]; then
        echo "Fixing permissions for $dir..."
        sudo chown -R builder:builder "/lakka-libreelec/$dir"
        sudo chmod -R 755 "/lakka-libreelec/$dir"
    fi
done

# Create and fix permissions for shared resources
for dir in "sources" "toolchain" ".ccache"; do
    sudo mkdir -p "/lakka-libreelec/$dir"
    sudo chown -R builder:builder "/lakka-libreelec/$dir"
    sudo chmod -R 755 "/lakka-libreelec/$dir"
done

# Special handling for target directory - needs full write permissions for subdirectories
sudo mkdir -p "/lakka-libreelec/target"
sudo chown -R builder:builder "/lakka-libreelec/target"
# Set full permissions: owner=rwx, group=rwx, other=rx for target directory and all contents
sudo chmod -R 775 "/lakka-libreelec/target"
# Set sticky bit so new files inherit group ownership
sudo chmod g+s "/lakka-libreelec/target"

echo "Permissions fixed. Starting build environment..."

# Set umask for builder user to ensure new files have proper permissions
export UMASK=002
umask 002

# Execute the command passed to docker run
exec "$@"