#!/bin/bash

# Usage: snapshot_purge.sh [ dataset_name ] [ snapshots count to leave ] (optional: dry run = 1 to enable)
# Example: snapshot_purge.sh Pool1/dataset1 5
# Example (dry run): snapshot_purge.sh Pool1/dataset1 5 1

if [[ -z $1 || -z $2 ]]
then
        printf  "Missing arguments.\n   Usage: snapshot_purge.sh [ dataset_name ] [ snapshots count to leave ] (optional: dry run = 1 to enable)"
        printf "\n      Example: snapshot_purge.sh Pool1/dataset1 5"
        exit 1
fi

if [ -z $3 ]
then
        DRY_RUN=$3
fi

LEAVE_N_SNAPSHOTS=$2
DRY_RUN=0
DATASET="$1"
CURRENT_SNAPSHOT_COUNT=`zfs list -t snapshot -o name -S creation | grep $DATASET | wc -l`

while [ $CURRENT_SNAPSHOT_COUNT -gt $LEAVE_N_SNAPSHOTS ]
do
        if [ $DRY_RUN -eq 1 ]
        then
                if [[ $CURRENT_SNAPSHOT_COUNT -ge 1 ]]
                then
                        echo "this would be deleted..."
                        zfs list -t snapshot -o name -S creation | grep $DATASET | tail -n 1
                        CURRENT_SNAPSHOT_COUNT=$((CURRENT_SNAPSHOT_COUNT-1))
                fi
                else
						echo "deleting snapshot..."
						zfs list -t snapshot -o name -S creation | grep $DATASET | tail -n 1
                        zfs list -t snapshot -o name -S creation | grep $DATASET | tail -n 1 | xargs -n 1 zfs destroy
                        CURRENT_SNAPSHOT_COUNT=`zfs list -t snapshot -o name -S creation | grep $DATASET | wc -l`
                fi

done
