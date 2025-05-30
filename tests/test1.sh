#!/usr/bin/env bash

## test1.sh

APP="pnyn"

sudo apt autoremove $APP -y

rm -rfv pkg
cp -rv src pkg

fn=$(find pkg -type f -name ${APP}.sh)
fx=${fn%%.sh}
mv -v $fn $fx
sudo chmod +x $fx

gzip -v $(find pkg -type f -name ${APP}.1)

dpkg -b pkg ${APP}-test.deb
sudo apt install ./${APP}-test.deb

## simple command tests

pnyn version
echo

pnyn help
echo

echo '$ pnyn tonemarks ni3 hao3'
pnyn tonemarks ni3 hao3
echo

echo '$ pnyn tm ni3 hao3'
pnyn tm ni3 hao3
echo

echo '$ pnyn tonemarksiso ni3 hao3'
pnyn tonemarksiso ni3 hao3
echo

echo '$ pnyn tmiso ni3 hao3'
pnyn tmiso ni3 hao3
echo


echo '$ pnyn tonesremoved ni3 hao3'
pnyn tonesremoved ni3 hao3
echo


echo '$ pnyn notones ni3 hao3'
pnyn notones ni3 hao3
echo

echo '$ pnyn tr ni3 hao3'
pnyn tr ni3 hao3
echo

echo '$ pnyn pmash ni3 hao3'
pnyn pmash ni3 hao3
echo

echo '$ pnyn pbash ni3 hao3'
pnyn pbash ni3 hao3
echo

man pnyn > man-pnyn.log
