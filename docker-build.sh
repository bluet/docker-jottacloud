#!/bin/bash

VERSION=0.15.110283
DATE=`date +%Y%m%d`

docker build --pull -t bluet/jottacloud .
docker scan bluet/jottacloud:latest

docker tag bluet/jottacloud:latest bluet/jottacloud:${VERSION}
# git tag moved to the last step
#git tag "${VERSION}" -a -m "jotta-cli ${VERSION}"
#git push --tags


# Fixes busybox trigger error https://github.com/tonistiigi/xx/issues/36#issuecomment-926876468
docker run --pull always --privileged -it --rm tonistiigi/binfmt --install all

docker buildx create --use

while true; do
        read -p "Everything ready? (We're going to build multi-platform images and push) [y/N]" yn
        case $yn in
                [Yy]* ) docker buildx build -t bluet/jottacloud:latest -t bluet/jottacloud:${VERSION}-${DATE} --platform linux/amd64,linux/arm64/v8 --pull --push .; break;;
                [Nn]* ) break;;
                * ) echo "";;
        esac
done


read -p "Tag the version of code as ${VERSION} in git? [y/N]" yn
case $yn in
	[Yy]* ) git tag "${VERSION}" -a -m "jotta-cli ${VERSION}" && git push --tags;;
	* ) echo "";;
esac

