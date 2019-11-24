#!/usr/bin/env bash

for dir in */ ; do
  isoname=$(echo "${dir}" | sed 's/\///g')
  mkisofs -Jo "${isoname}.iso" "${dir}"
done

