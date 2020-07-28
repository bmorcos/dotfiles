# Place this in ~/miniconda/etc/conda/activate.d
# To remove (base) env from prompt
# https://stackoverflow.com/a/55172508
PS1="$(echo "$PS1" | sed 's/(base) //')"
