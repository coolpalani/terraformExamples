#! /bin/bash

# Display usage instructions of this shell script
usage()
{
	echo "This file creates three separate folders for different 'environments' "
	echo "The environments created are: stage, prod, mgmt, global"
	echo "Usage: $0 [-p <Playbook Path>] [-t <Playbook Title>]" 1>&2; exit 1;
}

# Variables for file names
MAIN="main.tf"
VARS="var.tf"
OUTPUT="outputs.tf "

# Gather the user options
while getopts ":p:" OPTION; do
	case "${OPTION}" in
	p)
		PROJECT_PATH=${OPTARG}
		;;
	*)
		usage
		;;
	esac
done

# Creating overall structure for project
mkdir -p ${PROJECT_PATH}/stage
mkdir -p ${PROJECT_PATH}/prod
mkdir -p ${PROJECT_PATH}/mgmt
mkdir -p ${PROJECT_PATH}/global

cd ${PROJECT_PATH}

for Dir in *; do
	# As global directory is different from the rest, other folders are created
	if [ ${Dir} =  global ]; then
		mkdir -p global/iam
		touch ${Dir}/iam/${MAIN} ${Dir}/iam/${VARS} ${Dir}/iam/${OUTPUT}
		mkdir -p global/s3
		touch ${Dir}/s3/${MAIN} ${Dir}/s3/${VARS} ${Dir}/s3/${OUTPUT}
		continue
	fi
	# Creating substructure 
	mkdir -p ${Dir}/vpc
	touch ${Dir}/vpc/${MAIN} ${Dir}/vpc/${VARS} ${Dir}/vpc/${OUTPUT}
	mkdir -p ${Dir}/services/frontend-app
	touch ${Dir}/services/frontend-app/${MAIN} ${Dir}/services/frontend-app/${VARS} ${Dir}/services/frontend-app/${OUTPUT}
	mkdir -p ${Dir}/services/backend-app
	touch ${Dir}/services/backend-app/${MAIN} ${Dir}/services/backend-app/${VARS} ${Dir}/services/backend-app/${OUTPUT}
	mkdir -p ${Dir}/data-storage/mysql
	touch ${Dir}/data-storage/mysql/${MAIN} ${Dir}/data-storage/mysql/${VARS} ${Dir}/data-storage/mysql/${OUTPUT}
	mkdir -p ${Dir}/data-storage/redis
	touch ${Dir}/data-storage/redis/${MAIN} ${Dir}/data-storage/redis/${VARS} ${Dir}/data-storage/redis/${OUTPUT}
done
