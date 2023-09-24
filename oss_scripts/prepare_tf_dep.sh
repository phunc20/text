#!/bin/bash
set -e  # fail and exit on any command erroring

if (which python) | grep -q "python"; then
  installed_python="python"
elif (which python3) | grep -q "python3"; then
  installed_python="python3"
fi

ext=""
osname="$(uname -s | tr 'A-Z' 'a-z')"
if [[ "${osname}" == "darwin" ]]; then
  ext='""'
fi

# update setup.nightly.py with tf version
tf_version=$($installed_python -c 'import tensorflow as tf; print(tf.__version__)')
echo "$tf_version"
sed -i $ext "s/project_version = 'REPLACE_ME'/project_version = '${tf_version}'/" oss_scripts/pip_package/setup.nightly.py
# update __version__
sed -i $ext "s/__version__ = .*\$/__version__ = \"${tf_version}\"/" tensorflow_text/__init__.py
