#!/usr/bin/env sh
set -eu

mkdir -p public/videos
ffprobe -v error -show_streams -show_format webpage/videos/release-short.avi
ffprobe -v error -show_streams -show_format webpage/videos/release-long.avi
ffmpeg -y -i webpage/videos/release-short.avi -vf "trim=start=2.5:end=4.0,setpts=4.0*(PTS-STARTPTS)" -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p -movflags +faststart -an public/videos/release-short.mp4
ffmpeg -y -i webpage/videos/release-long.avi -vf "trim=start=1.5:end=3.0,setpts=4.0*(PTS-STARTPTS)" -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p -movflags +faststart -an public/videos/release-long.mp4
