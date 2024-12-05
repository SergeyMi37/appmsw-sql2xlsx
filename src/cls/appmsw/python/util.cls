Class appmsw.python.util [ Abstract ]
{

ClassMethod ZPMShell(cmd As %String) As %Status
{
	Set tNewClass = "%IPM.Main"
	Set tOldClass = "%ZPM.PackageManager"
	If $System.CLS.IsMthd(tNewClass, "Shell") {
		Return $ClassMethod(tNewClass, "Shell", cmd)
	} ElseIf $System.CLS.IsMthd(tOldClass, "Shell") {
		Return $ClassMethod(tOldClass, "Shell", cmd)
	} Else {
		Throw $$$ERROR($$$GeneralError, "ZPM not installed")
	}
}

/// do ##class(appmsw.python.util).init()
ClassMethod init(installall = 0) As %Status
{
	quit:installall="note" $$$OK
	set gn=##class(appmsw.python.demo).#GN
	set tMgrDir = $System.Util.ManagerDirectory()
  	set tBinDir = $System.Util.BinaryDirectory()
	set tCSPDir = ##class(%File).NormalizeDirectory("csp", ##class(%File).GetDirectory($zu(86)))
	if $zversion(1)=3 {  //Linux
		set dir="/opt/irisapp/src/"
		set dir2="/irisdev/" 
		set pattpath="/opt/irisapp/src/csp/sql2xlsx/pattern/"
		set outputpath="/usr/irissys/mgr/Temp/"
		if ##class(%File).DirectoryExists(dir) {
		 if '##class(%File).DirectoryExists(dir2) {	;for demo  GCR
			for name="exchange-rate-cbrf","csvgen" {
				if '##class(appmsw.python.util).IsInstallzpm(name) {
					do ..ZPMShell("install "_name)
			    }
			}
		    do:'##class(appmsw.python.util).IsInstallzpm("fileserver") ..ZPMShell("load https://github.com/SergeyMi37/Cache-FileServer")
		 }
		 else {  ;install zpm modules for Docker
			for name="csvgen" {
				if '##class(appmsw.python.util).IsInstallzpm(name) {
					do ..ZPMShell("install "_name)
			    }
			}
			do:'##class(appmsw.python.util).IsInstallzpm("fileserver") ..ZPMShell("load https://github.com/SergeyMi37/Cache-FileServer")
		 }
		}
		else {  //just linux without docker
		}
		do:'##class(appmsw.python.util).IsInstallzpm("fileserver") ..ZPMShell("load https://github.com/SergeyMi37/Cache-FileServer")
		if installall {
			for name="csvgen" {
				if '##class(appmsw.python.util).IsInstallzpm(name) {
					do ..ZPMShell("install "_name)
			    }
			}
		}

	    ;set options for linux
		if ##class(%File).DirectoryExists(pattpath)	{
			set @gn@("pattpath")=pattpath
		}
		else {
			set @gn@("pattpath")=tCSPDir_"sql2xlsx/pattern/"
		}
		if ##class(%File).DirectoryExists(outputpath)	{
			set @gn@("outputpath")=outputpath
		}
		else {
			set @gn@("outputpath")=$System.Util.ManagerDirectory()_"Temp/"
		}
		
	}
	else { ;set options for Windows
		do:'##class(appmsw.python.util).IsInstallzpm("fileserver") ..ZPMShell("load https://github.com/SergeyMi37/Cache-FileServer")
		set @gn@("pattpath")=tCSPDir_"sql2xlsx/pattern\"
		set @gn@("outputpath")=$System.Util.ManagerDirectory()_"Temp\"
	}
	write !,"Load for demo "_##class(apptools.core.net).GetURI(.prop)_"/apptoolsrest/a/xlsx&class=appmsw.python.demo&namespace="_$namespace
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
	Set tNewClass = "%IPM.Main"
	Set tOldClass = "%ZPM.PackageManager"
	If $System.CLS.IsMthd(tNewClass, "GetListModule") {
		Do $ClassMethod(tNewClass, "GetListModule", ns, .list)
	} ElseIf $System.CLS.IsMthd(tOldClass, "GetListModule") {
		do $ClassMethod(tOldClass, "GetListModule", ns, .list)
	} Else {
		Throw $$$ERROR($$$GeneralError, "ZPM not installed")
	}
	quit $DATA(list(modulename))
}

}

