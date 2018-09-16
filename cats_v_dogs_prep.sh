#!/bin/bash
# Put together a subset of train / test / validation for cats and dogs

# parameters (note, there is a total of 25,000 images)
n_train=1000
n_test=500
n_validation=500

# calculate the total number of samples required
total_sample=$(( $n_train+$n_test+$n_validation ))

# get the total number of images
total_images=$(ls train/ | wc -l | tr -d [:space:])

# check the numbers
if [ total_sample -gt $total_images ]; then
    echo "the total sample of train, test, validation data exceeds the number of available images ($total_images)"
    exit

# to  be safe, prompt user to remove the folder manually instead of adding rm -rf into the script
# rm -r subset
if [ -d "subset" ]; then
    echo "The subset directory already exists, remove it if you wish to rerun this script"
    exit

# generate relevant directories
mkdir -p subset/{train,test,validation}/{cat,dog}

# copy subsets to corresponding durectories
index_start=0
for segment in train test validation; do
    
    index_end=$(($((n_${segment}))+$index_start))
    
    for animal in cat dog; do
        file_array=($(ls train/ | grep "${animal}*" | head -n ${total_sample} | awk '{print "train/"$0}')) # this will be unnecessarily done several times, but it is quick anyway
        echo ANIMAL: $animal echo START: $index_start and TAKE N: $((n_${segment}))
        cp ${file_array[@]:$index_start:$((n_${segment}))} subset/$segment/$animal/
    done

    index_start=$index_end

done