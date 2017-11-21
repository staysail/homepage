#!/bin/bash
#
# Copyright 2017 Garrett D'Amore <garrett@damore.org>
# Copyright 2017 Capitar IT Group BV <info@capitar.com>
# This software is supplied under the terms of the MIT License, a
# copy of which should be located in the distribution where this
# file was obtained (LICENSE.txt).  A copy of the license may also be
# found online at https://opensource.org/licenses/MIT.
#
# 
# This program attempts to publish updated documentation to nanomsg
# gh-pages branch, in the rfcs directory.
# 
# This script requires asciidoctor, pygments, git, asciidoctor-diagram,
# ditaa, packetdiag (from nwdiag) and a UNIX shell.
# 

tmpdir=$(mktemp -d)
srcdir=$(dirname $0)
dstdir=${tmpdir}/docs
cd ${srcdir}

giturl="${GITURL:-git@github.com:staysail/staysail}"

cleanup() {
	echo "DELETING ${tmpdir}"
	rm -rf ${tmpdir}
}

mkdir -p ${tmpdir}

rm -f docs
ln -s ${tmpdir}/docs docs

trap cleanup 0


echo git clone ${giturl} ${dstdir} || exit 1
git clone ${giturl} ${dstdir} || exit 1

(cd ${dstdir}; git checkout)

hugo


if [ -n "$dirty" ]
then
	echo "Repository has uncommited documentation.  Aborting."
	exit 1
fi

if [ -n "$fails" ]
then
	echo "Failures formatting documentation. Aborting."
	exit 1
fi

(cd ${dstdir}; git add -A .; git commit -m 'homedir update'; git push origin)
