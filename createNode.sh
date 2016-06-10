#!/bin/sh

IMAGE=$1
VERSION=$2
CLUSTERID=$3
CLUSTERTOKEN=$4

if [ -z $IMAGE ]; then
	echo "Docker image not specified please specify as the first argument"
	echo "Usage: DOCKERIMAGE DOCKERTAG CLUSTERID CLUSTERTOKEN"
	echo "DOCKERIMAGE: The name of the docker image to add as a node (i.e. iron/runner)"
	echo "DOCKERTAG: The tag, or version to use (i.e. test of latest)"
	echo "CLUSTERID: the cluster id from your my clusters page"
	echo "CLUSTERTOKEN: the cluster token from your my clusters page"
fi

if [ -z $VERSION ]; then
        echo "Docker DOCKERTAG  not specified please specify as the second argument"
        echo "Usage: DOCKERIMAGE DOCKERTAG CLUSTERID CLUSTERTOKEN"
        echo "DOCKERIMAGE: The name of the docker image to add as a node (i.e. iron/runner)"
        echo "DOCKERTAG: The tag, or version to use (i.e. test of latest)"
        echo "CLUSTERID: the cluster id from your my clusters page"
        echo "CLUSTERTOKEN: the cluster token from your my clusters page"
fi

if [ -z $CLUSTERID ]; then
        echo "Cluster ID not specified please specify as the third argument"
        echo "Usage: DOCKERIMAGE DOCKERTAG CLUSTERID CLUSTERTOKEN"
        echo "DOCKERIMAGE: The name of the docker image to add as a node (i.e. iron/runner)"
        echo "DOCKERTAG: The tag, or version to use (i.e. test of latest)"
        echo "CLUSTERID: the cluster id from your my clusters page"
        echo "CLUSTERTOKEN: the cluster token from your my clusters page"
fi

if [ -z $CLUSTERTOKEN ]; then
        echo "Cluster Tokene not specified please specify as the fourth argument"
        echo "Usage: DOCKERIMAGE DOCKERTAG CLUSTERID CLUSTERTOKEN"
        echo "DOCKERIMAGE: The name of the docker image to add as a node (i.e. iron/runner)"
        echo "DOCKERTAG: The tag, or version to use (i.e. test of latest)"
        echo "CLUSTERID: the cluster id from your my clusters page"
        echo "CLUSTERTOKEN: the cluster token from your my clusters page"
fi

docker ps -a | awk '{print $NF}' | grep -q ironrunner
RET=$?
echo $RET

if [ $RET -eq 0 ]; then
	echo "ironrunner already exists, stopping gracefully"
	sh stopIronRunner.sh ironrunner
	docker ps -a | grep "$IMAGE" | awk '{print $NF}' | while read line ; do docker rm $line ; done
	docker images | grep -v \<none\> | grep "$IMAGE" | awk '{print $1":"$2}' | while read line ; do docker rmi $line ; done
fi
echo "Starting new node"
docker run --name ironrunner -it --privileged -d -e "ENV=PRODUCTION" -e "CLUSTER_ID=$CLUSTERID" -e "CLUSTER_TOKEN=$CLUSTERTOKEN" --net=host $IMAGE:$VERSION

