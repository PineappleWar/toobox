Imports and OVA and writes cronjob for snapshots.
If you have custom OVAs its pretty convinent.
```bash
$ ./ovaDeploy.sh
[1] Deploy ova (import ova and setup cronjob)
[2] Remove (delete vm and remove cronjob)
[___] Enter selection: 
1
[1]: Fedora-35.ova
[2]: KLv0.ova
[___] Enter selection: 
2
./KLv0.ova KLv0.ova
0%...10%...20%...30%...40%...50%...60%...70%...80%...90%...100%
Interpreting /home/e/toolDevelopment/vboxDeploy/KLv0.ova...
OK.
0%...10%...20%...30%...40%...50%...60%...70%...80%...90%...100%
$ crontab -l
0 12 * * * VBoxManage snapshot KLv0 take $(date -I)
```
