pe-chip-tools
=============

Tools created for the PE CHIP Team for various purposes
Initial update. 

The cdhtestv3.sh script is to automate and better handle teragen/terasort options

s3bench.pl is to use the aws cli tool to benchmark S3 instances' throughput in serial as well as parallel mode
the python scripts are deconstructions of an existing cm_api automation script (https://github.com/cloudera/cm_api/tree/master/python/examples/auto-deploy)
More stuff to come

diskbench.pl script is to benchmark (using dd(1m)) disks on any hadoop node (or any other node for that matter). Pre-requisites are as follows -

1) disks should be formatted and mounted
2) ensure there is sufficient space on the disks to run the tests

The script details are here --

```$ ~/diskbench.pl --help
Usage: /home/user/diskbench.pl --help|--bs=1M --count=1000 --vector=<readSpeed|writeSpeed> --mode=serial --dir=/data/1/,/data/2,/data/3,/data/4,/data/5 
--logfile=/my/log/file --ddopt=<iflag=direct|oflag=direct|conv=fdatasync> 
	--help 	- print this message
	--bs - Block size in K or M, defaults to 64K, to match HDFS write chunk size
	--count - number of blocks
	--vector - options are readSpeed and writeSpeed 
	--mode - options are serial or parallel. Defaults to serial. Parallel mode will try to launch multiple read or write operations in parallel
	--logfile - pass the name of the logfile you want to capture your output to
	--ddopt - pass the dd(1m) option you want to use. for eg: oflag=direct for direct write, iflag=direct for direct read, defaults to conv=fdatasync
	--filelist - list of input files to read from
	--dir - directores where to run this benchmarks. Assumption is that each directory is a disk mountpoint to be benchmarked```

To run disk write tests in parallel --

```sudo ~/diskbench.pl --bs=64K --count=10000 --vector=writeSpeed --mode=parallel --dir=/data1,/data2,/data3,/data4,/data5,/data6,/data7,/data8 --logfile=/var/tmp/diskbench.log --ddopt="oflag=direct"```

This will generate verbose output to stdout --

```Running writeSpeed in parallel...
/data1 
/data2 
Running /bin/dd if=/dev/zero of=/data1/4b979124-6394-4b5b-8502-10ec7ff31247.dat bs=65536 count=10000 oflag=direct 
/data3 
Running /bin/dd if=/dev/zero of=/data2/10642c67-6b73-4708-a79c-2ec30b819f2d.dat bs=65536 count=10000 oflag=direct 
/data4 
Running /bin/dd if=/dev/zero of=/data3/92d6f47b-a1f1-49b8-ad89-f4e8625c0edd.dat bs=65536 count=10000 oflag=direct 
/data5 
Running /bin/dd if=/dev/zero of=/data4/77293501-17a9-4deb-a80b-bbf8111fe05e.dat bs=65536 count=10000 oflag=direct 
/data6 
Running /bin/dd if=/dev/zero of=/data5/79cd0e90-f662-4d7b-9b4e-bde6e0019df9.dat bs=65536 count=10000 oflag=direct 
/data7 
Running /bin/dd if=/dev/zero of=/data6/c8a05323-69c7-4e24-94a6-c297ca7f5cb3.dat bs=65536 count=10000 oflag=direct 
/data8 
Running /bin/dd if=/dev/zero of=/data7/b8ebd38b-47d9-4227-b9c8-6ada16489af2.dat bs=65536 count=10000 oflag=direct 
Running /bin/dd if=/dev/zero of=/data8/fec5d33d-931a-4f7f-a487-15232f4d93db.dat bs=65536 count=10000 oflag=direct 
10000+0 records in
10000+0 records out
655360000 bytes (655 MB) copied, 31.0294 s, 21.1 MB/s
10000+0 records in
10000+0 records out
655360000 bytes (655 MB) copied, 31.19 s, 21.0 MB/s
10000+0 records in
10000+0 records out
655360000 bytes (655 MB) copied, 31.4105 s, 20.9 MB/s
10000+0 records in
10000+0 records out
655360000 bytes (655 MB) copied, 32.5578 s, 20.1 MB/s
10000+0 records in
10000+0 records out
655360000 bytes (655 MB) copied, 33.0589 s, 19.8 MB/s
10000+0 records in
10000+0 records out
655360000 bytes (655 MB) copied, 35.9343 s, 18.2 MB/s
10000+0 records in
10000+0 records out
655360000 bytes (655 MB) copied, 45.3664 s, 14.4 MB/s
10000+0 records in
10000+0 records out
655360000 bytes (655 MB) copied, 48.2747 s, 13.6 MB/s```

and also generate entries in the logfile specified --

``` $ more diskbench.log 
/data1/b5e9296c-1054-4e7c-9c3b-f90fe58cffa6.dat sized 640000 KB written in 8 seconds, Thruput 80000.00 KB/s
/data4/dbeb6008-0325-4490-afd7-7a4a20822185.dat sized 640000 KB written in 9 seconds, Thruput 71111.11 KB/s
/data6/18082323-608b-4ebd-99ce-6fe87727b8db.dat sized 640000 KB written in 9 seconds, Thruput 71111.11 KB/s
/data2/5cec6d5d-a24c-424f-a693-e745514e3e69.dat sized 640000 KB written in 10 seconds, Thruput 64000.00 KB/s
/data8/3b94f18f-99d2-41d5-a3de-a58e472fb5cc.dat sized 640000 KB written in 10 seconds, Thruput 64000.00 KB/s
/data3/a9c63a53-3896-4172-8e1e-dee7436e65d0.dat sized 640000 KB written in 10 seconds, Thruput 64000.00 KB/s
/data7/94967d91-3769-45c9-9cd4-2845e190cd71.dat sized 640000 KB written in 10 seconds, Thruput 64000.00 KB/s
/data5/bc4a59b0-7e2b-483c-9907-8ccdefc5ed3d.dat sized 640000 KB written in 11 seconds, Thruput 58181.82 KB/s ```

Running in read mode

```$ sudo ~/diskbench.pl --bs=64K --count=10000 --vector=readSpeed --mode=parallel --filelist=/var/tmp/flist.txt --logfile=/var/tmp/diskbench.log```


and corresponding logfile entries --

``` /data3/a9c63a53-3896-4172-8e1e-dee7436e65d0.dat sized 640000 KB read in 32 seconds, Thruput 20000.00 KB/s
/data2/5cec6d5d-a24c-424f-a693-e745514e3e69.dat sized 640000 KB read in 32 seconds, Thruput 20000.00 KB/s
/data7/94967d91-3769-45c9-9cd4-2845e190cd71.dat sized 640000 KB read in 33 seconds, Thruput 19393.94 KB/s
/data4/dbeb6008-0325-4490-afd7-7a4a20822185.dat sized 640000 KB read in 33 seconds, Thruput 19393.94 KB/s
/data6/18082323-608b-4ebd-99ce-6fe87727b8db.dat sized 640000 KB read in 35 seconds, Thruput 18285.71 KB/s
/data1/b5e9296c-1054-4e7c-9c3b-f90fe58cffa6.dat sized 640000 KB read in 41 seconds, Thruput 15609.76 KB/s
/data8/3b94f18f-99d2-41d5-a3de-a58e472fb5cc.dat sized 640000 KB read in 63 seconds, Thruput 10158.73 KB/s
/data5/bc4a59b0-7e2b-483c-9907-8ccdefc5ed3d.dat sized 640000 KB read in 73 seconds, Thruput 8767.12 KB/s ```

Also added code to run collectl -sdDmnc -i 5 -P -f /var/tmp/<dirname> after forking a child process. When diskbench.pl finishes, the collectl instance will get killed, thereby collecting data at 5 second intervals during the duration of the benchmark.
