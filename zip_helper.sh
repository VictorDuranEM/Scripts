#!/bin/bash
# Define resources and destination directories variables and provide the
# option to initialize them by the user with the parameters -r and -d

install() {
	message="You can call the script globally now using the command zipthis"
	if [ "$1" == "update" ]; then
		message="Your global 'zipthis' has been updated";
	fi
	DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    cp $DIR/zip_helper.sh /usr/local/bin/zipthis
    chmod +x /usr/local/bin/zipthis
	echo $message
    exit 1
}

zipResources() {
	# Go to resources directory and prepare to zip its contents
	cd $resourcesPath
	# Validate that the current directory is not the home directory.
	# In case it is, finish the operation.
	if [ "$PWD" = "$HOME" ]; then
		echo "You should NOT zip your home directory. Aborting operation"
		exit 1
	fi

        # Delete the zip file if it already exists
	if [ -f $destinationPath/$zipName.zip ]; then
		echo "Removing existing zip file"
        	rm $destinationPath/$zipName.zip	
	fi

        # Create the zip file concatenating the current date and time
	zip -r $destinationPath/$zipName.zip * -x "*.svn*" -x "*.DS_Store*" -x "*__MACOSX*"
	echo "Hi there!, your zip has been created! :)"
	open $destinationPath
}

validateUserInputs() {
	if [ ! -d $resourcesPath ]; then
	echo "Invalid resources directory. Aborting operation"
	exit 1
	fi
	if [ ! -d $destinationPath ]; then
		echo "Invalid destination directory. Aborting operation"
		exit 1
	fi
	if [[ $zipName =~ .*\.zip ]]; then
		zipName=${zipName%.zip}
	fi
}

printVariablesValues() {
	echo "Your resources directory is: "$resourcesPath
	echo "Your destination directory is: "$destinationPath
	echo "Your zip file name is :"$zipName.zip
}

# Install or update script globally
if [ "$1" == "install" ] || [ "$1" == "update" ]; then
	install "update"
fi

# Define global variables
resourcesPath=$PWD
destinationPath=~/Desktop
zipName="ZippedResources"

# Handle options
while getopts r:d:n: option
do
    case "${option}"
    in
    r) resourcesPath=${OPTARG};;
    d) destinationPath=${OPTARG};;
	n) zipName=${OPTARG};;
    esac
done

# currentDate="'date +%Y'"
# echo $currentDate

printVariablesValues;

validateUserInputs;

zipResources;
