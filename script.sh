#!/bin/sh
# Project: Photo Archive Script
# Author: Christopher Johnson [40275286]
# Date Last Modified: 29/11/2017


# Check to see if there are two arguments given
if [ $# -ne 2 ];
	then
		echo "Usage: phar flash_pathname archive_dir_path"
		exit 1
	else
		# Check to see if the first directory exists
		if [ -d $1 ]; 
			then
				echo "Flash directory found.."
				# Check to see if second directory exists
				if [ -d $2 ]; 
					then
						# Check to see if the second directory is not empty
						target=$2
						if find "$target" -mindepth 1 -print -quit | grep -q .;
							then
								echo "Archive directory is not empty. Terminating Script"
								exit 1
							else
								echo "Archive directory found and empty.."
						fi
					else
						echo "Archive directory not found.."
						echo "Creating archive directory.."
						mkdir $2
				fi
			else
				echo "Usage: phar flash_pathname archive_dir_path"
				exit 1
		fi
fi

# Now that the arguments have been validated and archive is ready run the archive script
echo "Running.."
# For every directory/subdirectory in the flash directory
flash=$1
for i in $(find $flash -name 'IMG_????.JPG')
do
    # Check for correct filename format
	if [  ${i: -8:4} -eq ${i: -8:4} ] 2>/dev/null;
		then
			# Check if filename already exists
			if [ -e $2/"${i: -12:12}" ] 
				then
					# Compare the duplicate filename
					if cmp -s $i $2/"${i: -12:12}"
						then
							# If the picture is identicle print duplicate location into txt doc
							echo "$i" >> $2/duplicates.txt
						else
							# If they images are different add to archive with ".JPG appended"
							cp $i $2/${i: -12:12}.JPG
					fi
				else
					# If the file doesnt exist copy to archive file
					cp $i $2
			fi
	fi
done
echo "Archive created. Script terminating."
	