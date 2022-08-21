#!/bin/bash

set -v
set -o errexit
source $rootfsDir/tmp/env.sh
source $rootfsDir/tmp/proxy.sh
echo "Running python installation"


useradd -r rhea -s /bin/false -M -G shadow

parallel --halt 2 -j1 -n1 --linebuffer --tagstring '{}' "pip3 install --upgrade $PYTHON_ARGS --prefix /usr --no-cache-dir '{}'" ::: <<EOF
jupyterhub
sudospawner
jupyter-fs
jhub_remote_user_authenticator
ipywidgets
ipycanvas
seaborn
calysto_bash
octave_kernel
ipympl
mpmath
sympy
ipyvolume
ipygany
voila
jupyterlab-git
jupyterlab-github
pandas
jupyterlab_latex
aquirdturtle_collapsible_headings
jupyter-dash
jupyter_bokeh
jupyterlab-fasta
jupyterlab-geojson
jupyterlab-mathjax3
jupyterlab-vega2
jupyterlab-vega3
ipysheet
bqplot
ipychart
pythreejs
RISE
ipython-sql
sqlalchemy
pandas-bokeh
mysql
pyodbc
psycopg2
jupytext
tensorflow
keras
EOF
#lckr-jupyterlab-variableinspector
jupyter serverextension enable voila
jupyter server extension enable voila

mkdir -p /usr/etc/jupyter
cat <<EOF > /usr/etc/jupyter/jupyter_notebook_config.py
c.LatexConfig.latex_command = 'pdflatex'
EOF
