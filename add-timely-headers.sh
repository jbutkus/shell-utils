#!/bin/bash

for f in *.php; do package=`basename $(pwd) | perl -ne 'print ucfirst'`; tmpf=`mktemp`; offset=`grep -m1 -n class $f | awk -F ':' '{print $1}'`; cn=`echo $f | perl -pe 's|^class-(.+)\.php$|$1|' | perl -ne 'print join "_", map ucfirst, split "-"' `; echo -e '<?php\n//\n//  '$f'\n//  timely-enterprise-login\n//\n//  Created by The Seed Studio on '$(date +%Y-%m-%d)'.\n//\n\n\n/**\n * '$cn' class\n *\n * @package '$package'\n * @author  time.ly\n */' | cat - <( tail -n+$offset $f) >$tmpf; mv $tmpf $f; done
