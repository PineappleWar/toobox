#!/bin/bash 

# DEFAULTS
cpus=2
memory=4096

deploy () {
	ovapath=$1
	ovaname=$(echo $ovapath | rev | cut -d '/' -f 1 | rev)
	name=$(echo $ovaname | cut -d '.' -f 1)
	
	echo $ovapath $ovaname 
	extension=$(echo $ovaname | rev | cut -d / -f 1 | cut -d . -f 1 | rev)
	[ ! "$extension" = "ova" ] && echo "[***] $filetarget is an invalid ova!" && exit 1
	VBoxManage import $ovapath 1>/dev/null 
	
	# Insert whatever options here 
        VBoxManage modifyvm $name --memory $memory
        VBoxManage modifyvm $name --cpus $cpus

	command="VBoxManage snapshot $name take "
	command+=$(printf '%s\n' '$(date -I)')
	(crontab -l; echo "0 12 * * * $command") | crontab -
}

remove () {
	vms=$(VBoxManage list vms)
	IFS=$'\n'
	counter=1
	vms=$(VBoxManage list vms)
	for vm in $vms; do
		echo "[$counter] $vm"
		counter=$((counter+1))
	done
	read selection
	removeName=$(echo $vms | cut -d '}' -f $selection | cut -d '{' -f 1 | awk '{$1=$1};1' | tr -d \")
	echo $removeName
	VBoxManage unregistervm $removeName --delete
	crontab -l | grep -v $(echo $removeName | cut -d ' ' -f 1) | crontab -
}

# Full cli 
[ "$1" = "deploy" ] && deploy $2 && exit 0
[ "$1" = "remove" ] && remove && exit 0

# Interactive 
echo -e "Syntax:\n./scriptname deploy OVAPATH\n./scriptname remove"
echo -e "[1] Deploy ova (import ova and setup cronjob)\n[2] Remove (delete vm and remove cronjob)"

echo "[___] Enter selection: "
read actionChoice
if [ "$actionChoice" = "1" ]; then
	counter=1
	declare -i counter
	ovasearch=$(find . -name '*.ova')
	for ova in $(echo $ovasearch | tr ' ' '\n' | rev | cut -d '/' -f 1 | rev);do
		echo "[$counter]: $ova"
		counter+=1
	done
	echo "[___] Enter selection: "
	read ovaChoice
	ovaPath=$(echo $ovasearch | cut -d ' ' -f $ovaChoice)
fi

[ "$actionChoice" = "1" ] && deploy $ovaPath && exit 0
[ "$actionChoice" = "2" ] && remove && exit 0
