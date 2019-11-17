#!/usr/bin/env bash

for dir in */ ; do
  isoname=$(echo "${dir}" | sed 's/\///g')
  mkisofs -o "${isoname}.iso" "${dir}"
done

