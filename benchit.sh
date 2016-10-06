#!/bin/sh
indir="$(/usr/bin/uuidgen)"
outdir="$(/usr/bin/uuidgen)"
repdir="$(/usr/bin/uuidgen)"

printUsage() {
 echo "Usage: ./$0 -d <data size in 100byte increments> -m <number of mappers> -r <number of reducers> -I <number of iterations> | -h 
	d - data size in 100 byte increments. Defaults to 100GB
	m - number of mappers - defaults to 40
	r - number of reducers - defaults to 40
	I - number of times to run the benchmarks
	h - print this message\n";
}

while getopts d:m:r:I:h switch
do
    case $switch in
	d) data_size=$OPTARG;;
	m)map_tasks=$OPTARG;;
	r)reduce_tasks=$OPTARG;;
	I)iterations=$OPTARG;;
	h) printUsage && exit 0;;
	*) printUsage && exit 1;;
    esac
done
shift $(( $OPTIND - 1 ))

if [ -z $data_size ]; then
     data_size="1000000000";
fi
if [ -z $map_tasks ]; then
    map_tasks="40";
fi
if [ -z $reduce_tasks ]; then
    reduce_tasks="40";
fi
if [ -z $iterations ]; then
    iterations="20";
fi

# Change the number mappers, reducers, size etc here
# The directories are generated using uuidgen

bmarks="teragen terasort teravalidate"
# First run has to be a teragen

./terabench.sh -p teragen -x 3 -d $data_size -m $map_tasks -r $reduce_tasks -i $indir -o $outdir -O $repdir

for i in $(seq $iterations)
do
    # Randomize which benchmark to run
    for bm in $bmarks
    do
        runthis="$(echo $RANDOM $bm|sort -n|awk '{print $2}')"
	./terabench.sh -p $runthis -x 3 -d $data_size -m $map_tasks -r $reduce_tasks -i $indir -o $outdir -O $repdir
	# sleep for random period of time before running the next benchmark
	sleep $(( $RANDOM % 900 ))
    done  
done
