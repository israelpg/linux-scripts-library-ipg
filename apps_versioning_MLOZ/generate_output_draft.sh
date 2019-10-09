#!/bin/bash

# Must be deployed in server running Apache Server (Available through port 80)

# parameters
workDir=${PWD} ####### revert this!!! to --> /data/scripts
outputFile=apps-status.html
templateFile=template.html
listIIB_EB=$(ls *.lst | egrep "EB|BO")
listIIB_FL=$(ls *.lst | egrep "FL|ST")
listWASApps_EB=$(cat applications_running.txt | grep 'EB' | awk -F '|' '{print $1}')
listWASApp_FL=$(cat applications_running.txt | egrep 'FLUX|RFND' | awk -F '|' '{print $1}')
listTomcatApps=$(cat listTomcatApps.txt)
environnement="INTEG P8"

if [[ ${PWD} != ${workDir} ]]; then
	cd $workDir
fi



cat > ${workDir}/${outputFile} << EOF
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>Application Versions - INTEG</title>
	<link rel="stylesheet" href="styles.css">
	<script src="javascript.js"></script>
</head>
<body>
	<h2>Integration Environment - Application Versions</h2>
	<!-- Tab links -->
	<div class="tab">
		<button class="tablinks" onclick="openCity(event, 'Tomcat')">Tomcat</button>
		<button class="tablinks" onclick="openCity(event, 'WAS')">WAS</button>
		<button class="tablinks" onclick="openCity(event, 'IIB')">IIB</button>
	</div>	
	<!-- Tab content -->
	<div id="Tomcat" class="tabcontent">
		<h3>Tomcat</h3>
		End-Tomcat
	</div>
	<div id="WAS" class="tabcontent">
		<h3>WAS</h3>
		<button class="accordion">eBusiness</button>
		<div class="panel">
	  		End-WAS-EB
		</div>
		<button class="accordion">Flux</button>
		<div class="panel">
 			<p>Lorem ipsum...</p>
		</div>
	</div>
	<div id="IIB" class="tabcontent">
		<h3>IIB</h3>
		<button class="accordion">eBusiness</button>
		<div class="panel">
	  		End-IIB-EB
		</div>
		<button class="accordion">Flux</button>
		<div class="panel">
  			End-IIB-FL
		</div>
	</div>
	<script>
	var acc = document.getElementsByClassName("accordion");
	var i;

	for (i = 0; i < acc.length; i++) {
	  acc[i].addEventListener("click", function() {
	    this.classList.toggle("active");
	    var panel = this.nextElementSibling;
	    if (panel.style.maxHeight) {
	      panel.style.maxHeight = null;
	    } else {
	      panel.style.maxHeight = panel.scrollHeight + "px";
	    } 
	  });
	}
</script>
</body>
</html>
EOF

# Populate the lines for IIB EB Servers (Simple list with one collapsable level by Domain)
for i in ${listIIB_EB}; do
	mq=$(echo "$i" |cut -d'.' -f 1)
	mq="<h2>$mq<\/h2>"
	sed -i "s/\<End-IIB-EB\>/$mq &/" $workDir/$outputFile
	while read line
	do
		line="<p>$line<\/p>"
		line=$(echo ${line} | sed "s/.bar'//")
		sed -i "s/\<End-IIB-EB\>/$line &/" $workDir/$outputFile
	done< <(cat ${i})
done

# Populate the lines for IIB FL Servers (Simple list with one collapsable level by Domain)
for i in ${listIIB_FL}; do
	mq=$(echo "$i" |cut -d'.' -f 1)
	mq="<h2>$mq<\/h2>"
	sed -i "s/\<End-IIB-FL\>/$mq &/" $workDir/$outputFile
	while read line
	do
		line="<p>$line<\/p>"
		line=$(echo ${line} | sed "s/.bar'//")
		sed -i "s/\<End-IIB-FL\>/$line &/" $workDir/$outputFile
	done< <(cat ${i})
done

# Populate the lines with all running WAS apps for EB
while read line
do
	line="<p>$line<\/p>"
	sed -i "s/\<End-WAS-EB\>/$line &/" $workDir/$outputFile
done< <(cat ${listWASApps_EB})

# Populate the lines with all running WAS apps for EB
while read line
do
	line="<p>$line<\/p>"
	sed -i "s/\<End-WAS-EB\>/$line &/" $workDir/$outputFile
done< <(cat ${listWASApps_FL})

# Populate the lines with all running Tomcat apps
while read line
do
	line="<p>$line<\/p>"
	sed -i "s/\<End-Tomcat\>/$line &/" $workDir/$outputFile
done< <(cat ${listTomcatApps})
