#!/bin/bash

VERSION=0.16.129390
DATE=`date +%Y%m%d`

docker build --pull -t bluet/jottacloud .
# docker scan bluet/jottacloud:latest
docker scout quickview bluet/jottacloud:latest
grype bluet/jottacloud:latest | grep -i -E '(High|Critical)'

docker tag bluet/jottacloud:latest bluet/jottacloud:${VERSION}
# git tag moved to the last step
#git tag "${VERSION}" -a -m "jotta-cli ${VERSION}"
#git push --tags


# Fixes busybox trigger error https://github.com/tonistiigi/xx/issues/36#issuecomment-926876468
# docker run --pull always --privileged -it --rm tonistiigi/binfmt --install all

# docker buildx create --use

while true; do
        read -p "Is VERSION=${VERSION}-${DATE} the current latest version? (We're going to build multi-platform images and push) [y/N]" yn
        case $yn in
                [Yy]* ) docker buildx build --builder cloud-bluet-test -t bluet/jottacloud:latest -t bluet/jottacloud:${VERSION}-${DATE} --platform linux/amd64,linux/arm64/v8 --pull --push .; break;;
                [Nn]* ) break;;
                * ) echo "";;
        esac
done


read -p "Tag the version of code as ${VERSION}-${DATE} in git? [y/N]" yn
case $yn in
	[Yy]* ) git tag "${VERSION}-${DATE}" -a -m "jotta-cli ${VERSION}-${DATE}" && git push --tags;;
	* ) echo "";;
esac

