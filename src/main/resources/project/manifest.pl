@files = (

 ['//property[propertyName="preamble"]/value' , 'preamble.pl'],
 ['//property[propertyName="VirtualBox"]/value' , 'VirtualBox.pm'],
 
 ['//procedure[procedureName="PowerOn"]/step[stepName="PowerOn"]/command' , 'vm/poweron.pl'],
 ['//procedure[procedureName="PowerOff"]/step[stepName="PowerOff"]/command' , 'vm/poweroff.pl'],
 ['//procedure[procedureName="Pause"]/step[stepName="Pause"]/command' , 'vm/pause.pl'],
 ['//procedure[procedureName="Resume"]/step[stepName="Resume"]/command' , 'vm/resume.pl'],
 ['//procedure[procedureName="Snapshot"]/step[stepName="Snapshot"]/command' , 'vm/snapshot.pl'],
 ['//procedure[procedureName="Revert"]/step[stepName="Revert"]/command' , 'vm/revert.pl'],
 ['//procedure[procedureName="Register"]/step[stepName="Register"]/command' , 'vm/register.pl'],
 ['//procedure[procedureName="Unregister"]/step[stepName="Unregister"]/command' , 'vm/unregister.pl'],
 
 ['//procedure[procedureName="PowerOn"]/step[stepName="SetTimelimit"]/command' , 'setTimelimit.pl'],
 ['//procedure[procedureName="PowerOff"]/step[stepName="SetTimelimit"]/command' , 'setTimelimit.pl'],
 ['//procedure[procedureName="Pause"]/step[stepName="SetTimelimit"]/command' , 'setTimelimit.pl'],
 ['//procedure[procedureName="Resume"]/step[stepName="SetTimelimit"]/command' , 'setTimelimit.pl'],
 ['//procedure[procedureName="Snapshot"]/step[stepName="SetTimelimit"]/command' , 'setTimelimit.pl'],
 ['//procedure[procedureName="Revert"]/step[stepName="SetTimelimit"]/command' , 'setTimelimit.pl'],
 ['//procedure[procedureName="Register"]/step[stepName="SetTimelimit"]/command' , 'setTimelimit.pl'],
 ['//procedure[procedureName="Unregister"]/step[stepName="SetTimelimit"]/command' , 'setTimelimit.pl'],
 
 ['//procedure[procedureName="PowerOn"]/propertySheet/property[propertyName="ec_parameterForm"]/value', 'forms/PowerOn.xml'],
 ['//procedure[procedureName="PowerOff"]/propertySheet/property[propertyName="ec_parameterForm"]/value', 'forms/PowerOff.xml'],
 ['//procedure[procedureName="Pause"]/propertySheet/property[propertyName="ec_parameterForm"]/value', 'forms/Pause.xml'],
 ['//procedure[procedureName="Resume"]/propertySheet/property[propertyName="ec_parameterForm"]/value', 'forms/Resume.xml'],
 ['//procedure[procedureName="Snapshot"]/propertySheet/property[propertyName="ec_parameterForm"]/value', 'forms/Snapshot.xml'],
 ['//procedure[procedureName="Revert"]/propertySheet/property[propertyName="ec_parameterForm"]/value', 'forms/Revert.xml'],
 ['//procedure[procedureName="Register"]/propertySheet/property[propertyName="ec_parameterForm"]/value', 'forms/Register.xml'],
 ['//procedure[procedureName="Unregister"]/propertySheet/property[propertyName="ec_parameterForm"]/value', 'forms/Unregister.xml'],

 ['//property[propertyName="ec_setup"]/value', 'ec_setup.pl'],
);
