Class appmsw.python.util [ Abstract ]
{

ClassMethod init() As %Status
{
	if $zversion(1)=3 {  //Linux
		set dir="/opt/irisapp/src/"
		set dir2="/irisdev/" 
		if ##class(%File).DirectoryExists(dir) {
		 if '##class(%File).DirectoryExists(dir2) {	;for demo  GCR
			for name="exchange-rate-cbrf","fileserver","csvgen" {
				if '##class(appmsw.python.util).IsInstallzpm(name) {
					do ##class(%ZPM.PackageManager).Shell("install "_name)
			    }
			}
		 }
		 else {  ;install zpm modules for Docker
			for name="fileserver","csvgen" {
				if '##class(appmsw.python.util).IsInstallzpm(name) {
					do ##class(%ZPM.PackageManager).Shell("install "_name)
			    }
			}
		 }
		}
		else {  //just linux without docker
		}
	    ;set options for linux
	    ;/opt/irisapp/src/csp/sql2xlsx/pattern/
		;/usr/irissys/mgr/Temp/
	}
	else { ;set options for Windows
	    ;/opt/irisapp/src/csp/sql2xlsx/pattern/
		;/usr/irissys/mgr/Temp/
	}
    return $$$OK
}

/// do ##class(appmsw.python.util).MakeProject("d:\_proj\_mygirhub\appmsw-sql2xlsx\")
ClassMethod MakeProject(dir) As %Status
{
	;do ##class(apptools.core.code).exp(dir_"src","appmsw")
	do $classmethod("apptools.core.code","exp",dir_"src","appmsw.python")
    return $$$OK
}

/// write ##class(appmsw.python.util).IsInstallzpm("exchange-rate-cbrf")
ClassMethod IsInstallzpm(modulename, ns = {$namespace}) As %String
{
	do ##class(%ZPM.PackageManager).GetListModule(ns,.list)
	;zw list
	quit $DATA(list(modulename))
}

}

