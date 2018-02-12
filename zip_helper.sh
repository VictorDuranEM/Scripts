# !/bin/bash
# Define resources and destination directories variables and provide the
# option to initialize them by the user with the parameters -r and -d

install() {
	DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    cp $DIR/zip_helper.sh /usr/local/bin/zipthis
    chmod +x /usr/local/bin/zipthis
	echo "You can call the script globally now using the command zipthis"
    exit 1
}

if [ "$1" = "install" ]; then
	install;
fi

resourcesPath=$PWD
destinationPath=~/Desktop
while getopts r:d: option
do
    case "${option}"
    in
    r) resourcesPath=${OPTARG};;
    d) destinationPath=${OPTARG};;
    esac
done
echo "Your resources directory is: "$resourcesPath
echo "Your destination directory is: "$destinationPath

# Validate directories provided exist
if [ ! -d $resourcesPath ]; then
	echo "Invalid resources directory. Aborting operation"
	exit 1
fi
if [ ! -d $destinationPath ]; then
	echo "Invalid destination directory. Aborting operation"
	exit 1
fi

# Go to resources directory and prepare to zip its contents
cd $resourcesPath
# Validate that the current directory is not the home directory.
# In case it is, finish the operation.
if [ "$PWD" = "$HOME" ]; then
	echo "You should NOT zip your home directory. Aborting operation"
	exit 1
fi

# Remove the zip file in case it exists and create a new one that contains the
# resources found in the resources directory.
rm $destinationPath/ZippedResources.zip
zip -r $destinationPath/ZippedResources.zip * -x "*.svn*" -x "*.DS_Store*" -x "*__MACOSX*"
echo "Hi there!, your zip has been created! :)"
open $destinationPath

