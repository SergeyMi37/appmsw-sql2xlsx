Include apptools.core

/// http://localhost:52773/apptoolsrest/a/rate&class=appmsw.python.demo&namespace=USER
Class appmsw.python.demo Extends apptools.lte.adminTabs [ ClassType = "", DependsOn = apptools.core.msg, ProcedureBlock ]
{

/// Application title
Parameter HeaderText = "Sql2Xlsx";

/// Roles
Parameter AppRoles = "RoleSql2Xlsx";

/// Replace parameters
ClassMethod MainParameter(ByRef h, ByRef par) As %Status
{
 set path=par("=path=")
 set par("=Brand-Text=")=..#HeaderText
 set base64=##class(apptools.core.rest).getStatic(..%ClassName(1)_":image")
 set par("=Logo-image=")=base64
 set par("=titleAppToolsadmin=")=..#HeaderText
 set par("<!--=LinkIcon=-->")=..GetAppIcon(,"png",base64)
 set par("<!--FooterLeft-->")=$system_" - "_$zv
 set par("<!--FooterRight-->")="<a target='license' href=""/csp/sys/op/UtilDashboard.csp?$NAMESPACE=%25SYS""> "_$$$aText("System Dashboard","")_"</a>"
 quit ..RepaceParameter(.h,.par)
}

/// what modes are available
ClassMethod GetAllApps(opt) As %Status
{
	set ns=$namespace
	set sideMenuName="Tables",
		sideMenuNumer=1,
		sideMenuOpen=1,        //3 =1 open menu
		sideMenuIcon="fa-cog"  //4  icon   https://fontawesome.com/icons?d=gallery&p=2&m=free
		set sideMenu=$lb(sideMenuNumer,sideMenuName,sideMenuOpen,sideMenuIcon) 
    if ##class(appmsw.python.util).IsInstallzpm("exchange-rate-cbrf") {
		set key="View"
		set opt(key,"Menu")=sideMenu
		set opt(key)="Exchange rate"
		set opt(key,"id")=key
		set opt(key,"TabName")="Exchange rate"
		set opt(key,"ClassName")=..%ClassName(1)
		set opt(key,"Role")="%All"
		set opt(key,"Namespace")=ns
		set opt(key,"Method")="ShowTabSample"
		set opt(key,"TabMenu","Close")=1 ;0 = the tab cannot be deleted
		set opt(key,"aw-icon")="fa-list-alt" ;fa-table"   https://fontawesome.com/icons?d=gallery&p=2&m=free
		set opt(key,"Active")=0 ;active menu item
     }
    if ##class(appmsw.python.util).IsInstallzpm("fileserver") {
		set key="File"
		set opt(key,"Menu")=sideMenu
		set opt(key)="Fileserver"
		set opt(key,"id")=key
		set opt(key,"TabName")="Fileserver"
		set opt(key,"ClassName")=..%ClassName(1)
		set opt(key,"Role")="%All"
		;set opt(key,"MethodUrlNewWin")="/fileserver/files"
		set opt(key,"Method")="ShowInIFrame" 
		set opt(key,"InFrameUrl")="/fileserver/files"
		set opt(key,"aw-icon")="fa-list-alt" ;fa-table"   https://fontawesome.com/icons?d=gallery&p=2&m=free
		set opt(key,"Active")=0 ;active menu item
     }	
    if ##class(appmsw.python.util).IsInstallzpm("csvgen") {
		set key="Titanic"
		set opt(key,"Menu")=sideMenu
		set opt(key)="csvgen"
		set opt(key,"id")=key
		set opt(key,"TabName")="csvgen"
		set opt(key,"ClassName")=..%ClassName(1)
		set opt(key,"Role")="%All"
		set opt(key,"Namespace")=ns
		set opt(key,"Method")="ShowTabSample"
		set opt(key,"TabMenu","Close")=1 ;0 = the tab cannot be deleted
		set opt(key,"aw-icon")="fa-list-alt" ;fa-table"   https://fontawesome.com/icons?d=gallery&p=2&m=free
		set opt(key,"Active")=0 ;active menu item
     }
       	set key="SQL"
		set opt(key,"Menu")=sideMenu
		set opt(key)="SQL2XLSX"
		set opt(key,"id")=key
		set opt(key,"TabName")="SQL2XLSX"
		set opt(key,"ClassName")=..%ClassName(1)
		set opt(key,"Role")="%All"
		set opt(key,"Namespace")=ns
		set opt(key,"Method")="ShowTabSample"
		set opt(key,"TabMenu","Close")=1 ;0 = the tab cannot be deleted
		set opt(key,"aw-icon")="fa-list-alt" ;fa-table"   https://fontawesome.com/icons?d=gallery&p=2&m=free
		set opt(key,"Active")=1 ;active menu item

	;top menu
		s LeftMenuName="Support",LeftMenuNumer=1
		s key="menu-top-support"
		s opt(key)="support"
		s opt(key,"id")="Support"
		s opt(key,"TabName")="Support" 
		s opt(key,"ClassName")=..%ClassName(1)
		s opt(key,"Method")="ShowTabAbout"
		s opt(key,"TabMenu","Close")=1
		s opt(key,"MenuTop")=$lb(LeftMenuNumer,LeftMenuName)
	
	set topMenuName="Account",
		topMenuNumer=99
		set key="menu-top-accoun2"
		set opt(key)="Account: "_$username
		set opt(key,"id")="AccountProf"
		set opt(key,"TabName")="Profile "_$username 
		set opt(key,"ClassName")=..%ClassName(1)
		set opt(key,"Method")="ShowInIFrame" 
		set opt(key,"InFrameUrl")="http://"_$zu(110)_":52773/csp/sys/sec/%25CSP.UI.Portal.User.zen?PID="_$username
		set opt(key,"MenuTop")=$lb(topMenuNumer,topMenuName)
	set key="menu-top-account3"
		set opt(key,"MenuTop")=$lb(topMenuNumer,topMenuName) ; 99-account has nested items
		set opt(key)="Exit"
		set opt(key,"id")="AccountExit"
		set opt(key,"TabName")="Logoit" 
		set opt(key,"ClassName")=..%ClassName(1)
		set opt(key,"Method")="Logout"
	
	;----- Setup the search in the top menu
	s key="Search"
	s opt(key)="Search"
	s opt(key,"id")="Search-"
	s opt(key,"TabName")="Search"_"-"
	s opt(key,"ClassName")=..%ClassName(1)
	s opt(key,"Method")="ShowTabSearch"
	s opt(key,"TabMenu","Mode")=0 ;1 - for each new search bar to make new tab, 0-tab is always the same
	
	do ..CheckRoleMenu(.opt)
	quit $$$OK
}

ClassMethod ViewFirstHead(Par = "") As %Status
{
	do ##class(apptools.core.Form).BlockUI(0)
	set key=Par("key")
	set divId=Par("divId")
	set %ui=1
	set dataFrom=$zd($h-1,3)
	set dataTo=$zd($h,3)
	set pattern="/opt/irisapp/src/csp/sql2xlsx/pattern/pattern-yellow.xlsx"
	set onclick=$$$blockui("Load...")_
		$$$onclick(divId_"MainForm",divId_"MainContent",$namespace,..%ClassName(1),divId_"Result","&key="_key_"&divId="_divId_"&mode=*")
	&html<
		<table>
		<tr>
			<td>
 			from #($$$appDate(divId_"fromDate","",dataFrom))#
			</td>
			<td>
			to #($$$appDate(divId_"toDate","",dataTo))#
			</td>
			<td>
			#($$$appButton(divId_"appButtonResult1","onclick="""_$replace(onclick,"*",1)_"""","Search"))#
			#($$$appButton(divId_"appButtonResult2","onclick="""_$replace(onclick,"*",2)_"""","Load from service"))#
			#($$$appText(divId_"pattern","title='pattern for export' size=40 ",pattern))#
			#($$$appButton(divId_"appButtonResult3","onclick="""_$tr(onclick,"*",3)_"""","Export to XLSX"))#
			</td>
		</tr>
		</table>
	>
	$$$SetHeightContent(divId,250)
	q $$$OK
}

/// Search result 
ClassMethod ViewResult(Par = "") As %Status
{
	set %ui=1
	do ##class(apptools.core.Form).BlockUI(0)
	set key=Par("key")
	set divId=Par("divId")
	set mode=Par("mode")
	;Geting elements from form and prepare array Par
	set from=##class(apptools.core.Action).GetElemForm(%request,.Par,divId_"fromDate")	
	set to=##class(apptools.core.Action).GetElemForm(%request,.Par,divId_"toDate")
	write ..ButtonAgain(divId,key)
	set sql="select CharCode, DateExchangeRates, DateReq, LastChanged, Nominal, NumCode, Value from appmsw_cbrf.tabex where DateExchangeRates >= '"_from_"' and DateExchangeRates <= '"_to_"'"
	if mode=1 {
		set st=##class(apptools.core.LogInfoPane).DrawSQL(sql,100000,$zu(5),sql,$GET(exec),,1)
		if 'st  write $$$appError($System.Status.GetErrorText(st))
	}
	elseif mode=2 {
		do ##class(appmsw.cbrf.util).initDb(from,to)
	}
	elseif mode=3 {
		set gn="^||tmpQuery"
		set st=##class(apptools.core.sys).SaveSQL(sql,gn)
		if 'st  write $$$appError($System.Status.GetErrorText(st)) quit st
		set newfile="/usr/irissys/mgr/Temp/Exchange-rate"_$tr(##class(apptools.core.type).GetDateTime($h),"T:","_")_".xlsx"
		do ##class(appmsw.python.xlsx).gn2xlsx(gn,"",newfile,"Test",pattern)
		do ##class(Fileserver.File).AddFile(newfile)
	}
	quit $$$OK
}

ClassMethod SQLFirstHead(Par = "") As %Status
{
	do ##class(apptools.core.Form).BlockUI(0)
	set key=Par("key")
	set divId=Par("divId")
	set %ui=1
	set pattern="/opt/irisapp/src/csp/sql2xlsx/pattern/pattern-green.xlsx"
	set sql="select * from %SYS.Namespace_List(0,0)"
    set inc=0 
	set onclick=$$$blockui("Load...")_
		$$$onclick(divId_"MainForm",divId_"MainContent",$namespace,..%ClassName(1),divId_"Result","&key="_key_"&divId="_divId_"&mode=*")
	&html<
		<table>
		<tr>
			<td>
 			#($$$appText(divId_"Sql","title='Query statement' size=80 ",sql))#
			#($$$appButton(divId_"appButtonResult1","onclick="""_$tr(onclick,"*",1)_"""","Search"))#
			</td>
			<td>
			</td>
			<td>
			#($$$appText(divId_"pattern","title='pattern for export' size=40 ",pattern))#
			#($$$appButton(divId_"appButtonResult2","onclick="""_$tr(onclick,"*",2)_"""","Export to XLSX"))#
			</td>
		</tr>
		</table>
	>
	$$$SetHeightContent(divId,250)
	q $$$OK
}

/// Search result 
ClassMethod SQLResult(Par = "") As %Status
{
	set %ui=1
	do ##class(apptools.core.Form).BlockUI(0)
	set key=Par("key")
	set divId=Par("divId")
	set mode=Par("mode")
	write ..ButtonAgain(divId,key)
	;Geting elements from form and prepare array Par
	set sql=##class(apptools.core.Action).GetElemForm(%request,.Par,divId_"Sql")
	set pattern=##class(apptools.core.Action).GetElemForm(%request,.Par,divId_"pattern")
	if mode=1 {
		set st=##class(apptools.core.LogInfoPane).DrawSQL(sql,100000,$zu(5),sql,$GET(exec),,1)
		if 'st  write $$$appError($System.Status.GetErrorText(st))
	}
	elseif mode=2 {
		set gn="^||tmpQuery"
		set st=##class(apptools.core.sys).SaveSQL(sql,gn)
		if 'st  write $$$appError($System.Status.GetErrorText(st)) quit st
		set newfile="/usr/irissys/mgr/Temp/sql"_$tr(##class(apptools.core.type).GetDateTime($h),"T:","_")_".xlsx"
		do ##class(appmsw.python.xlsx).gn2xlsx(gn,"",newfile,"Test",pattern)
		do ##class(Fileserver.File).AddFile(newfile)
	}
	quit $$$OK
}

ClassMethod TitanicFirstHead(Par = "") As %Status
{
	do ##class(apptools.core.Form).BlockUI(0)
	set key=Par("key")
	set divId=Par("divId")
	set %ui=1
	set pattern="/opt/irisapp/src/csp/sql2xlsx/pattern/pattern-grey.xlsx"
	set sql="select * FROM Data.Titanic"
    set inc=0 
	set onclick=$$$blockui("Load...")_
		$$$onclick(divId_"MainForm",divId_"MainContent",$namespace,..%ClassName(1),divId_"Result","&key="_key_"&divId="_divId_"&mode=*")
	&html<
		<table>
		<tr>
			<td>
 			#($$$appText(divId_"Sql","title='Query statement' size=80 ",sql))#
			#($$$appButton(divId_"appButtonResult1","onclick="""_$tr(onclick,"*",1)_"""","Search"))#
			</td>
			<td>
			</td>
			<td>
			#($$$appButton(divId_"appButtonResult3","onclick="""_$tr(onclick,"*",3)_"""","Load"))#
			#($$$appText(divId_"pattern","title='pattern for export' size=40 ",pattern))#
			#($$$appButton(divId_"appButtonResult2","onclick="""_$tr(onclick,"*",2)_"""","Export to XLSX"))#
			</td>
		</tr>
		</table>
	>
	$$$SetHeightContent(divId,250)
	q $$$OK
}

/// Search result 
ClassMethod TitanicResult(Par = "") As %Status
{
	set %ui=1
	do ##class(apptools.core.Form).BlockUI(0)
	set key=Par("key")
	set divId=Par("divId")
	set mode=Par("mode")
	write ..ButtonAgain(divId,key)
	;Geting elements from form and prepare array Par
	set sql=##class(apptools.core.Action).GetElemForm(%request,.Par,divId_"Sql")
	set pattern=##class(apptools.core.Action).GetElemForm(%request,.Par,divId_"pattern")
	if mode=1 {
		set st=##class(apptools.core.LogInfoPane).DrawSQL(sql,100000,$zu(5),sql,$GET(exec),,1)
		if 'st  write $$$appError($System.Status.GetErrorText(st))
	}
	elseif mode=3 {
		do ##class(community.csvgen).GenerateFromURL("https://raw.githubusercontent.com/datasciencedojo/datasets/master/titanic.csv",",","Data.Titanic")
	}
	elseif mode=2 {
		set gn="^||tmpQuery"
		set st=##class(apptools.core.sys).SaveSQL(sql,gn)
		if 'st  write $$$appError($System.Status.GetErrorText(st)) quit st
		set newfile="/usr/irissys/mgr/Temp/titanic"_$tr(##class(apptools.core.type).GetDateTime($h),"T:","_")_".xlsx"
		do ##class(appmsw.python.xlsx).gn2xlsx(gn,"",newfile,"Test",pattern)
		do ##class(Fileserver.File).AddFile(newfile)
	}
	quit $$$OK
}

/// set base64 = ##class(apptools.core.rest).getStatic("appmsw.cbrf.rateinfo:image") w !,base64,!
XData image [ MimeType = application/yaml ]
{
data:image/x-png;base64,
iVBORw0KGgoAAAANSUhEUgAAABgAAAAaCAYAAACtv5zzAAAAAXNSR0IArs4c6QAAAARnQU1BAACx
jwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAEYSURBVEhLY/hPYzBqAUEwsBYsX7oUL16zavX/
9+/eQVVjBwQtwAWWLVn6//OnTwQtocgCECBkCYYFJ+5c/L/r8rH//TsX/w9uy/4fNrXkv05V4H/5
Ijeoiv//Z8yY8T8zPQPK+///5s2bOC3BsABkEC6MDGA+gAGYT9ABWRa07pv/P7YuB2wJiIaxsQUp
Vguippf/v/H8PtzQilUTUCzABYi2AIS//PgG5oNoveogFAtAPgBhdDZJFmQubAbz2zfPgYsRAiRZ
8PjtCzAfRKNbQLEPQGEOAqCgAQGqxwHIYFi4I7NhgGIf4MKEAFEWPHn3EpybQTk5uqMAa06myAfI
AJsGfIAsC0jF6ACvBdQAoxYQBDS24P9/ABuq7h0dIZMSAAAAAElFTkSuQmCC
}

}

