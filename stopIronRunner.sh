#!/bin/sh
CONTAINER=$1

if [ -z $CONTAINER ]; then
	echo "Please specify container id or name\n"
	echo "./stopIronRunner ironrunner or ./stopIronRunner a5339beaf"
	exit 1
else
	echo "Creating stop file"
	sudo docker exec $CONTAINER mkdir -p /home/ubuntu
	sudo docker exec $CONTAINER touch /home/ubuntu/runner.die

	echo "Checking for active runners"
	RUNNERS=`docker exec $CONTAINER ps -a | grep -c "ruby run.rb"`
	while [ $RUNNERS -gt 0 ]
	do
		sleep 10
		RUNNERS=`docker exec $CONTAINER ps -a | grep -c "ruby run.rb"`
		echo "Currently stil $RUNNERS running, sleeping for 10 seconds"
	done
	echo "All runners stopped, stopping container"
	docker exec $CONTAINER rm -rf /home/ubuntu/runner.die
	docker stop $CONTAINER
	RET=$?
	if [ $RET -ne 0 ]; then
		echo "Error ($RET), unable to stop container"
		exit $RET
	fi
fi
