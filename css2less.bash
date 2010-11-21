#!/bin/bash
rbscript=`dirname $0`/`basename $0 | sed 's/\.bash$/.rb/'`
find . -iname '*.css' | while read cssfile
do
  test -f $cssfile && echo $rbscript `echo $cssfile | sed 's/\.css$/.{css,less}/'` && echo echo $cssfile
done | bash