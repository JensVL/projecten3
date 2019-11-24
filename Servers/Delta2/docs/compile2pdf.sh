#!/usr/bin/env bash

compile() {
  local src="${1}"
  local dest="$(echo "${src}" | sed 's/\.md$/\.pdf/')"

  pandoc "${src}" --pdf-engine=xelatex -o "${dest}"
}


for param in "${@}"
do
  compile "${param}"
done
