#!/bin/sh
indir="$(/usr/bin/uuidgen)"
outdir="$(/usr/bin/uuidgen)"
repdir="$(/usr/bin/uuidgen)"

# Change the number mappers, reducers, size etc here
# The directories are generated using uuidgen
for i in $(seq 20)
do
 ./terabench.sh -p teragen -x 3 -d 10000000000 -m 59 -r 59 -s regular -i $indir -o $outdir -O $repdir
 sleep $(( $RANDOM % 900 ))
 ./terabench.sh -p terasort -x 3 -d 10000000000 -m 59 -r 59 -s regular -i $indir -o $outdir -O $repdir
 sleep $(( $RANDOM % 900 ))
 ./terabench.sh -p teravalidate -x 3 -d 10000000000 -m 59 -r 59 -s regular -i $indir -o $outdir -O $repdir
 sleep $(( $RANDOM % 900 ))
done

