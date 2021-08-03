#!/bin/bash
### conf ###

# Name of the dataset.
DATASET="Pool1/Downloads"

# Leave N of the newest snapshots.
LEAVE_N_SNAPSHOTS=1

# Set this to 1 to see what snapshots would be deleted without actually deleting them.
DRY_RUN=0

### conf end ###

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
                        zfs list -t snapshot -o name -S creation | grep $DATASET | tail -n 1 | xargs -n 1 zfs destroy
                        sleep 1
                        CURRENT_SNAPSHOT_COUNT=`zfs list -t snapshot -o name -S creation | grep $DATASET | wc -l`
                fi

done
