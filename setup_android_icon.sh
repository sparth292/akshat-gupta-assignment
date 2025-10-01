#!/bin/bash

# Create necessary directories if they don't exist
mkdir -p android/app/src/main/res/mipmap-hdpi
mkdir -p android/app/src/main/res/mipmap-mdpi
mkdir -p android/app/src/main/res/mipmap-xhdpi
mkdir -p android/app/src/main/res/mipmap-xxhdpi
mkdir -p android/app/src/main/res/mipmap-xxxhdpi

# Copy the logo to all density directories
cp assets/logo.png android/app/src/main/res/mipmap-mdpi/ic_launcher.png
cp assets/logo.png android/app/src/main/res/mipmap-hdpi/ic_launcher.png
cp assets/logo.png android/app/src/main/res/mipmap-xhdpi/ic_launcher.png
cp assets/logo.png android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png
cp assets/logo.png android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png

# Make the script executable
chmod +x setup_android_icon.sh
