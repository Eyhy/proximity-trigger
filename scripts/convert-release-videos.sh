#!/usr/bin/env sh
set -eu

mkdir -p public/videos
ffprobe -v error -show_streams -show_format webpage/videos/release-short.avi
ffprobe -v error -show_streams -show_format webpage/videos/release-long.avi
ffmpeg -i webpage/videos/release-short.avi -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p -movflags +faststart -an public/videos/release-short.mp4
ffmpeg -i webpage/videos/release-long.avi -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p -movflags +faststart -an public/videos/release-long.mp4
