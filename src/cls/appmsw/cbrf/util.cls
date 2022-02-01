Class appmsw.cbrf.util [ Abstract ]
{

ClassMethod init() As %Status
{
	if '##class(Ens.Director).IsProductionRunning("appmsw.cbrf.production") {
	    w !,"Run prod"
		job ##class(Ens.Director).StartProduction("appmsw.cbrf.production")::1
		do ##class(Ens.Director).SetAutoStart("appmsw.cbrf.production")
		else   w !," no job start"
	}
    return $$$OK
}

/// do ##class(appmsw.cbrf.util).MakeProject("/irisdev/app/src/data/")
ClassMethod MakeProject(dir) As %Status
{
	;do ##class(apptools.core.code).exp(dir_"src","appmsw")
	do $classmethod("apptools.core.code","exp",dir_"src","appmsw")
	set List("appmsw.cbrf.tabexDayD.GBL")=""
	set target=##class(%File).NormalizeFilename("appmsw.cbrf.tabexDayD.xml",dir_"src/gbl/")
	Write $SYSTEM.OBJ.Export(.List, target)
	
	kill List
	set List("appmsw.cbrf.tabexD.GBL")=""
	set target=##class(%File).NormalizeFilename("appmsw.cbrf.tabexD.xml",dir_"src/gbl/")
	Write $SYSTEM.OBJ.Export(.List, target)

	do ..GetListApps($namespace,.list)
	set name=""
	set tWebAppList=""
	for { set name=$order(list(name)) quit:name=""
		set tWebAppList=tWebAppList_name_","
	}
	do ..CreateModuleXML($namespace,dir,"exchange-rate-cbrf",,"Database of exchange rates of the Central Bank of the Russian Federation.","",$e(tWebAppList,1,*-1))
    return $$$OK
}

/// do ##class(appmsw.cbrf.util).initDb("2021-01-01","2021-01-10")
/// http://localhost:52774/cbrf-rate/exchange/2021-03-03,2021-03-05
ClassMethod initDb(from = "2021-01-01", to = "2021-12-31") As %Status
{
	for h=$zdh(from,3):1:$zdh(to,3) {
		set Date=$zd(h,3) 
		write !,"<br>"_Date
		do ##class(appmsw.cbrf.tabexDay).CheckDay(Date,.count)
		if $g(count) write " uploaded earlier" continue
		set st=##class(appmsw.cbrf.tabexDay).LoadDay("http://www.cbr.ru/scripts/xml_daily.asp?date_req=",Date)
		if st {	
			write " loaded"
		}
	}
    return $$$OK
}

ClassMethod CreateModuleXML(namespace, tPath, tName, tVersion = "1.0.0", tDescription = "", tKeywords = "", tWebAppList) As %Status
{
	//set st=##class(%ZPM.PackageManager.Developer.ModuleTemplate).GenerateTemplate(tPath)
	Set tTemplate = $classmethod("%ZPM.PackageManager.Developer.ModuleTemplate","NewTemplate",tPath, tName, tVersion, tDescription, tKeywords)
	//Set tTemplate = ##class(%ZPM.PackageManager.Developer.ModuleTemplate).NewTemplate(tPath, tName, tVersion, tDescription, tKeywords)
	Return:'$IsObject(tTemplate) $$$ERROR($$$GeneralError,"Module creation error")
	;Do tTemplate.SetAuthorProps(tAuthorPerson, tAuthorOrg, tAuthorLicense, tAuthorCopy, tAuthorNotes)
	if namespace ;stupid line to please the quality of the code
	;Do tTemplate.AddWebApps(tWebAppList,.tCSPapps,namespace) //TODO https://github.com/intersystems-community/zpm/pull/275
	Do tTemplate.AddWebApps(tWebAppList,.tCSPapps) // tCSP - list of CSP (not REST apps) 
	
	For i=1:1:$Listlength(tCSPapps) {
		set namecsp=$Listget(tCSPapps,i)
		Set tCSPPath = "/csp/"_$p(namecsp,"/",*)
		Do tTemplate.SetSourcePathForCSPApp(namecsp,tCSPPath)
	}
	Do tTemplate.ReadResorces("src")
	Do tTemplate.ProcessResources()
	Return tTemplate.SaveFile(tPath)
}

ClassMethod GetListApps(sourcedb, ByRef list) As %Status
{
	new $namespace
	set $namespace="%SYS"
	set result=##CLASS(%ResultSet).%New("%DynamicQuery:SQL")
	set tSC=result.Prepare("select NameLowerCase FROM Security.Applications where NameSpace=?")
	set:tSC tSC=result.Execute($zconvert(sourcedb,"U"))
	if '$$$ISOK(tSC) {
		set text="Application setup error :"_$SYSTEM.Status.GetErrorText(tSC)  write !,text QUIT $$$ERROR(text)
	}
	else {
		while result.Next() {
			set name=result.Data("NameLowerCase")
			set tSC=##class(Security.Applications).Get(name,.prop)
			merge list(name)=prop
		}
	}
}

/// set st=##class(appmsw.cbrf.util).LoadData("/irisdev/app/src/data/NamesCurrences.txt","appmsw_cbrf.tabcurr")
ClassMethod LoadData(fileName, tableName)
{
    set Query = "LOAD DATA FROM FILE '"_fileName_"' INTO " _tableName_ "(CharCode,Name,NumCode)"
    do ##class(%SQL.Statement).%ExecDirect(,Query)
    quit $$$OK
}

}

