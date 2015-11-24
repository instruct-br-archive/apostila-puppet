#!/bin/bash

which libreoffice &> /dev/null

if [ $? -ne 0 ]; then
  echo 'Libre Office nao detectado'
  exit 1
fi

which rst2pdf &> /dev/null

if [ $? -ne 0 ]; then
  echo 'rst2pdf nao detectado'
  exit 1
fi

libreoffice --headless --invisible --convert-to pdf capa.odt

rst2pdf --custom-cover cover.tmpl -b 1 -s manual.style -l pt_br index.rst -o apostila-puppet.pdf
