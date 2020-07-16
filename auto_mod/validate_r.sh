#!/bin/bash
target_package=$1
dest_dir="/hpc/hpcswadm/cron-script/R_tmp/"
rm -fr $dest_dir/*

for r_ver in '4.0.2' '4.0.0' '3.6.2'
do
    module load ib R/${r_ver}
    dest_dir="/hpc/hpcswadm/cron-script/R_${r_ver//.}/tmp/"
    #installed=0, disblaed validation from R install.package 
    #reason regardless pacakge exist or not, install.package will return 1
    preinstalled=0
    R_LIBS_USER=/hpc/hpcswadm/cron-script/R_tmp/  R --vanilla -e 'library("'"$target_package"'")'&&echo "loaded successfully"&&preinstalled=1
    
    if [ $preinstalled == 0 ]; then
    
        loaded=0
        cran=0
        bioc=0
        R_LIBS_USER=${dest_dir}  R --vanilla -e 'install.packages("'"$target_package"'", repos="http://cran.us.r-project.org")'    &&echo "CRAN installed $target_package successfully" &&cran=1
        R_LIBS_USER=${dest_dir} R --vanilla -e 'library("BiocManager"); BiocManager::install("'"$target_package"'", update = TRUE, ask = FALSE)'    &&echo "BiocManager installed $target_package successfully" &&bioc=1
        R_LIBS_USER=${dest_dir}  R --vanilla -e 'library("'"$target_package"'")'&&echo "loaded successfully"&&loaded=1
        #echo  $loaded
        if [ $loaded == 1 ]; then
        	#echo "good to go "
        	rm -fr $dest_dir/*
                if [ $cran == 1 ]; then
        		R --vanilla -e 'install.packages("'"$target_package"'", repos="http://cran.us.r-project.org")'   
                fi 
                if [ $bioc == 1 ]; then
                R --vanilla -e 'library("BiocManager"); BiocManager::install("'"$target_package"'" , update = TRUE, ask = FALSE)'
                fi
        else
        	echo "something wrong, $target_package can not be installed in ${r_ver}"  >> /nfs/grid/software/auto_R_package/auto_mod/failed_package.log
        fi
    fi
    module purge
done

