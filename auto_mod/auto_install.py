#!/usr/bin/env python

import yaml
import subprocess
import time
import ruamel.yaml


code_folder = '/nfs/grid/software/auto_R_package/'
#subprocess.Popen(['rm -fr /nfs/grid/software/auto_R_packageauto_mod/hpcrpackage'],
#                 shell=True, executable="/bin/bash")
#subprocess.Popen(['cd  /nfs/grid/software/auto_R_packageauto_mod'"&&"'git clone git@auth_mod:PfizerRD/hpcrpackage.git'"&&"'echo good'],
#                 shell=True, executable="/bin/bash")


time.sleep(3)
yaml = ruamel.yaml.YAML()  # defaults to round-trip if no parameters given


with open(code_folder+'auto_mod/saved.yaml') as saved:
    #saved_dict = yaml.load(saved, Loader=yaml.Loader)
    saved_dict = yaml.load(saved)
    #print(saved_dict)
saved.close()
with open(code_folder+'hpcrpackage/package_list.yaml') as latest:
    #git_dict = yaml.load(latest, Loader=yaml.Loader)
    git_dict = yaml.load(latest)
    #print(git_dict)
latest.close()
for key in git_dict.keys():
    if key not in saved_dict.keys():
        print("find new packages", key," to be installed, start working")
        if git_dict[key] is None:
            print("empty value", key)
        cmd = '/nfs/grid/software/auto_R_package/auto_mod/validate_r.sh ' + \
            key + "&&" + 'echo finished'
        subprocess.Popen([cmd], shell=True, executable="/bin/bash")

with open(code_folder+'auto_mod/saved.yaml', 'w') as to_be_updated:
    #yaml.dump(git_dict, to_be_updated, default_flow_style=False)
    yaml.dump(git_dict, to_be_updated)
to_be_updated.close()
