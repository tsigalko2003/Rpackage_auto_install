#!/bin/bash

MYID="hpcswadm"
SERVICE="inotifywait"

if [ "$HOSTNAME" = "amrndhl1317.pfizer.com" ]; then
         if  ps aux | grep $MYID | grep $SERVICE | grep -v grep  >/dev/null; then
                #pre-exist ascp process, do not start a new one
                echo "inotify daemon is running, no need to restart another">/dev/null
	else
		echo "inotify daemon stopped, need to restart it">/dev/null
		pkill inotifywait 
		pkill r_installer_monitor
		cd /nfs/grid/software/auto_R_package/hpcrpackage/
		#inofity can not work well with nfs, so we have to switch the github folder into local storage 
		//nfs/grid/software/auto_R_package/inotify/bin/inotifywait -rqm --event CLOSE_WRITE  --format " %w%f %e %T  " /nfs/grid/software/auto_R_package/hpcrpackage/ --timefmt="%a, %d %b ;5D;5D%Y %T %z"  |
		 while read file action time ; do 
			if [[ "$file" == '/nfs/grid/software/auto_R_package/hpcrpackage/package_list.yaml' ]]; then
				 echo $file $time
				 rm -fr *.swx *.swp; git add . && git commit -m "autocommit on $time" && git push
				 cp -fr /nfs/grid/software/auto_R_package/auto_mod/saved.yaml /nfs/grid/software/auto_R_package/auto_mod/saved.yaml-bak
				 #ssh amrndhl1225 'module load eb/2019 Anaconda3/5.3.0;python /nfs/grid/software/auto_R_package/auto_mod/auto_install.py 2> /dev/null '
				 #cp -fr /nfs/grid/software/auto_R_package/auto_mod/saved.yaml-bak /nfs/grid/software/auto_R_package/auto_mod/saved.yaml
				 #ssh hpccpu100  'module load eb/2019 Anaconda3/5.3.0;python /nfs/grid/software/auto_R_package/auto_mod/auto_install.py 2> /dev/null' 
				 #cp -fr /nfs/grid/software/auto_R_package/auto_mod/saved.yaml-bak /nfs/grid/software/auto_R_package/auto_mod/saved.yaml
				 #ssh hpccpu207  'module load eb/2019 Anaconda3/5.3.0;python /nfs/grid/software/auto_R_package/auto_mod/auto_install.py 2> /dev/null' 
				 #cp -fr /nfs/grid/software/auto_R_package/auto_mod/saved.yaml-bak /nfs/grid/software/auto_R_package/auto_mod/saved.yaml
				 module load eb/2019 Anaconda3/5.3.0; python /nfs/grid/software/auto_R_package/auto_mod/auto_install.py 2> /dev/null 

			fi; 
                done

		#nohup /nfs/grid/software/auto_R_package/inotify/bin/inotifywait -qm --event CLOSE_WRITE --format "git commit -m 'autocommit for %w%f-- %e at %T' " /nfs/grid/software/auto_R_package/pub_package_list/package_list.yaml >> /nfs/grid/software/auto_R_package/log/package_list.log --timefmt="%a, %d %b %Y %T %z"&
	fi
fi



