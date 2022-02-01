Include apptools.core

/// http://localhost:52773/apptoolsrest/a/rate&class=appmsw.cbrf.rateinfo&namespace=RATE
Class appmsw.cbrf.rateinfo Extends apptools.lte.adminTabs [ ClassType = "", DependsOn = apptools.core.msg, ProcedureBlock ]
{

/// Application title
Parameter HeaderText = "RateInfo";

/// Roles
Parameter AppRoles = "Rate_Info";

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
		set opt(key,"Active")=1 ;active menu item

		set key="Curr"
		set opt(key,"Menu")=sideMenu
		set opt(key)="Сurrencies"
		set opt(key,"id")=key
		set opt(key,"TabName")="Сurrencies"
		set opt(key,"ClassName")=..%ClassName(1)
		set opt(key,"Role")="%All"
		set opt(key,"Namespace")=ns
		set opt(key,"Method")="ShowTabSample"
		set opt(key,"TabMenu","Close")=1 ;0 = the tab cannot be deleted
		set opt(key,"aw-icon")="fa-list-alt" ;fa-table"   https://fontawesome.com/icons?d=gallery&p=2&m=free

	set sideMenuName="Charts",
		sideMenuNumer=2,
		sideMenuOpen=0,        //3 =1 open menu
		sideMenuIcon="fa-cog"  //4  icon   https://fontawesome.com/icons?d=gallery&p=2&m=free
		set sideMenu=$lb(sideMenuNumer,sideMenuName,sideMenuOpen,sideMenuIcon) 
	
			set key="ChartСurr"
			set opt(key,"Menu")=sideMenu
			set opt(key)="Chart Exchange rate"
			set opt(key,"id")=key
			set opt(key,"TabName")="Chart Exchange rate"
			set opt(key,"ClassName")=..%ClassName(1)
			set opt(key,"Role")="%All"
			set opt(key,"Namespace")=ns
			set opt(key,"Method")="ShowTabSample"
			set opt(key,"TabMenu","Close")=1 ;0 = the tab cannot be deleted
			set opt(key,"aw-icon")="fa-list-alt" ;fa-table"   https://fontawesome.com/icons?d=gallery&p=2&m=free

			set key="ThreeСurr"
			set opt(key,"Menu")=sideMenu
			set opt(key)="Exchange rate 3"
			set opt(key,"id")=key
			set opt(key,"TabName")="Exchange rate 3"
			set opt(key,"ClassName")=..%ClassName(1)
			set opt(key,"Role")="%All"
			set opt(key,"Namespace")=ns
			set opt(key,"Method")="ShowTabSample"
			set opt(key,"TabMenu","Close")=1 ;0 = the tab cannot be deleted
			set opt(key,"aw-icon")="fa-list-alt" ;fa-table"   https://fontawesome.com/icons?d=gallery&p=2&m=free


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

ClassMethod ChartСurrFirstHead(Par = "") As %Status
{
	do ##class(apptools.core.Form).BlockUI(0)
	set key=Par("key")
	set divId=Par("divId")
	set cgi="&panel=class(appmsw.cbrf.ChartRate).AllCurrencies&days=1365"
	kill %request
	do ##class(apptools.Chart.ChartPanel).Drawcanvas(cgi)
	;$$$SetHeightContent(divId,250)
	q $$$OK
}

ClassMethod ThreeСurrFirstHead(Par = "") As %Status
{
	do ##class(apptools.core.Form).BlockUI(0)
	set key=Par("key")
	set divId=Par("divId")
	set cgi="&panel=class(appmsw.cbrf.ChartRate).AllCurrencies&days=2265(EUR,USD,GBP)"
	kill %request
	do ##class(apptools.Chart.ChartPanel).Drawcanvas(cgi)
	;$$$SetHeightContent(divId,250)
	q $$$OK
}

ClassMethod ViewFirstHead(Par = "") As %Status
{
	do ##class(apptools.core.Form).BlockUI(0)
	set key=Par("key")
	set divId=Par("divId")
	set %ui=1
	;set dataFrom=##class(apptools.core.type).GetYear($h-30)_"-"_##class(apptools.core.type).GetMonth($h-30)_"-01"
	;set dataTo=##class(apptools.core.type).GetYear($h)_"-12-31"
	set dataFrom=$zd($h-1,3)
	set dataTo=$zd($h,3)
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
	if mode=1 {
		set sql="select CharCode, DateExchangeRates, DateReq, LastChanged, Nominal, NumCode, Value from appmsw_cbrf.tabex where DateExchangeRates >= '"_from_"' and DateExchangeRates <= '"_to_"'"
		set sql="select * from appmsw_cbrf.tabex where DateExchangeRates >= '"_from_"' and DateExchangeRates <= '"_to_"'"
		set st=##class(apptools.core.LogInfoPane).DrawSQL(sql,100000,$zu(5),sql,$GET(exec),,1)
		if 'st  write $$$appError($System.Status.GetErrorText(st))
	}
	elseif mode=2 {
		do ##class(appmsw.cbrf.util).initDb(from,to)
	}
	quit $$$OK
}

ClassMethod CurrFirstHead(Par = "") As %Status
{
	do ##class(apptools.core.Form).BlockUI(0)
	set key=Par("key")
	set divId=Par("divId")
	set %ui=1
	set path="/opt/irisapp/src/csp/data/NamesCurrences.txt"
    set inc=0 
	//##class(apptools.core.Action).WriteActJs(%request,divId_"MainForm",divId_"MainContent",..%ClassName(1),divId_"Result","&key="_key_"&divId="_divId_"&mode=*")
	set onclick=$$$blockui("Load...")_
		$$$onclick(divId_"MainForm",divId_"MainContent",$namespace,..%ClassName(1),divId_"Result","&key="_key_"&divId="_divId_"&mode=*")
	&html<
		<table>
		<tr>
			<td>
 	
			</td>
			<td>
			</td>
			<td>
			#($$$appButton(divId_"appButtonResult1","onclick="""_$tr(onclick,"*",1)_"""","Search"))#
			#($$$appButton(divId_"appButtonResult2","onclick="""_$tr(onclick,"*",2)_"""","Delete Data"))#
			#($$$appButton(divId_"appButtonResult3","onclick="""_$tr(onclick,"*",3)_"""","Load Data"))#
			#($$$appText(divId_"Path_to_files","title='path to files' size=80 ",path))#
			</td>
		</tr>
		</table>
	>
	$$$SetHeightContent(divId,250)
	q $$$OK
}

/// Search result 
ClassMethod CurrResult(Par = "") As %Status
{
	set %ui=1
	do ##class(apptools.core.Form).BlockUI(0)
	set key=Par("key")
	set divId=Par("divId")
	set mode=Par("mode")
	set class="appmsw.cbrf.tabcurr"
	set table="appmsw_cbrf.tabcurr"
	set Path=##class(apptools.core.Action).GetElemForm(%request,.Par,divId_"Path_to_files")	
	write ..ButtonAgain(divId,key)
	if mode=1 {
		set sql="select * from appmsw_cbrf.tabcurr"
		set st=##class(apptools.core.LogInfoPane).DrawSQL(sql,100000,$zu(5),sql,$GET(exec),,1)
		if 'st  write $$$appError($System.Status.GetErrorText(st))
	}
	elseif mode=2 {
		Do $classmethod(class,"%KillExtent")
		write "%KillExtent"
	}
	elseif mode=3 {
		set st=##class(appmsw.cbrf.util).LoadData(Path,table)
		write "Loaded"
	}
	quit $$$OK
}

/// set base64 = ##class(apptools.core.rest).getStatic("appmsw.cbrf.rateinfo:image") w !,base64,!
XData image [ MimeType = application/yaml ]
{
data:image/x-png;base64,
iVBORw0KGgoAAAANSUhEUgAAAdEAAAGUCAYAAABqVhhEAAAAAXNSR0IArs4c6QAAAARnQU1BAACx
jwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAC21SURBVHhe7Z3bs6RnfV7nj8qtXcVNXLmhEtsX
CThc2I6JEuM4BqdcMRaiHFwQQ0KBygmQgthYGGHJyAwCyaCTBeiAJHQaSaOzQEgzI4TQAaVKN5P9
de9B8/3e1buf/U73+J3ea1U9N2j1s9/d/fX3bKq6eo6dFRERkS4cURERkU4cURERkU4cURERkU4c
URERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURER
kU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4c
URERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURER
kU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4c
URERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURER
kU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4c
URERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURER
kU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4c
URERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURER
kU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4c
URERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURER
kU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4c
URERkU4cURERkU4cURERkU4cURERkU4cURERkU6OvfXWW2eNMcYYc/g4osYYY0xnHFFjjDGmM46o
McYY0xlH1BhjjOmMI2qMMcZ0xhE1xhhjOuOIGmOMMZ1xRI0xxpjOOKLGGGNMZ/zaPxERkU4cURER
kU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4c
URERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURER
kU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4c
URERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cURERkU4cUZED+MxDX57l+NM3NxGR
o4sjKnIAjqiIHIQjKnIAjqiIHIQjKnIAjqiIHIQjKnIAjqiIHIQjKrLPyVeeafLPvvxrayMiRxdH
VGQfR1REDosjKrKPIyoih8URFdnHERWRw+KIiuzjiIrIYXFERfZ5x7XvaUKjWfPCG6ebiMjRwBEV
2ccRFZHD4oiK7OOIishhcURF9nFEReSwOKJyJHntrTea0EAmuef0w01E5GjgiMqRxBEVkU3giMqR
xBEVkU3giMqRxBEVkU3giMqRxBEVkU3giMqRhIaPBjLJLc/f1UREjgaOqBxJHFER2QSOqBxJHFER
2QSOqBxJHFER2QSOqBxJHFER2QSOqBxJNjmin3no6iYicjRwROVI4oiKyCZwROVI4oiKyCZwROVI
4oiKyCZwROVI4oiKyCZwROVIQsNHA/kfbrliFnKoS2TT0FdV1j8E33vz5U02+enxe8+cmOX40zc3
OWo4onIkoeGjgXREZRQc0TFxROVIQsNHA+mIyig4omPiiMqRhIaPBtIRlVFwRMfEEZVLmnoTmZLw
8fs+34QG8oN3fHIWcqhLZNPQYL3rhvfPssnrk/44rN2/c9OfNDlqOKJySeOIylHBER0TR1QuaRxR
OSo4omPiiMoljSMqRwVHdEwcUbmkcUTlqOCIjokjKmfff/tHm9Q3y5SesboQ6M1fbxpX3PnpJvQp
xpOvPDPLO49f1oR+568/c8ss5Lzj2vc0eeGN07PQJySrM0VkFcmopUmo77UptYfeR0ftunZExRHd
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
D+1dCG0eb/KXj351Fuqu3xAzhUaUHltTz7k8az1XdvY+h7zEIS9xyEsc8hLnZDNW9DpsM/Qa33Xq
wSbt2bPfr88hL3HISxzyEoe8xCEvcchLHPISh7zEIS9xyFvvOKI7TnLjSi6UKY5o6pCXOOQlDnmJ
44iyQ17ikJc45CUOeYlDXuKQlzjkJQ55iUNe4pC33nFEd5zkxpVcKFMc0dQhL3HISxzyEscRZYe8
xCEvcchLHPISh7zEIS9xyEsc8hKHvMQhb73jiO44yY0ruVCmOKKpQ17ikJc45CWOI8oOeYlDXuKQ
lzjkJQ55iUNe4pCXOOQlDnmJQ956xxHdcZIbV3KhTHFEU4e8xCEvcchLHEeUHfISh7zEIS9xyEsc
8hKHvMQhL3HISxzyEoe89Y4jukPUr9KbQjeu37jxD2d5+OUnotz6/N2zUDcNJqU+7leu++0m33j2
tiZ0LtOf+prSJ6J//x//rEl16uu5Kr96/e/Ocs2TNzahcxozahzRHcIRNYdNfU3rOE5xRI1ZHUd0
h3BEzWFTX9M6jlMcUWNWxxHdIRxRc9jU17SO4xRH1JjVcUR3CPq2ILqR1Rviwz/ZuxhKTuxdHDXV
oW4azHcev6xJfdxfPXpdk/rzpqw7EznkJQ55iUNe4pCXOOQlDnn0OlRnyq0/2hvd81Jfz1X5Hz/4
wizJmab0OOQlDnmJQ17ikJc45CUOeYlDXuKQlzjkJQ55iUNe4jiiO4Qjyg55iUNe4pCXOOQlDnmJ
Qx69DtWZ4oi2DnmJQ17ikJc45CUOeYlDXuKQlzjkJQ55ieOI7hCOKDvkJQ55iUNe4pCXOOQlDnn0
OlRniiPaOuQlDnmJQ17ikJc45CUOeYlDXuKQlzjkJY4jukM4ouyQlzjkJQ55iUNe4pCXOOTR61Cd
KY5o65CXOOQlDnmJQ17ikJc45CUOeYlDXuKQlziO6A7hiLJDXuKQlzjkJQ55iUNe4pBHr0N1pjii
rUNe4pCXOOQlDnmJQ17ikJc45CUOeYlDXuI4ojsEDRjdyD7y/f81yyMvP9nmp5DiUHea+gnh5Oct
0uOQlzjkJQ55iUNe4pCXOOQlDnj1U7dTfvmadze558xDs9SeRYKfFznkJQ55iUNe4pCXOOQlDnmJ
Q17ikJc45CUOeYlDXuA4ojuEI7qf6pCXOOQlDnmJQ17ikJc45CUOeI7ofnoc8hKHvMQhL3HISxzy
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
4pCXOOQlDnmJQ17ikJc45CUOeYlDXuKQlzjkJQ55iUNe4pCXOOQFjiPqiGYOeYmTeolDXuKQlzjk
JQ55iUNe4pCXOOQlDnmJQ17ikJc45CUOeYlDXuKQlzjkJQ55iUNe4pCXOOQlDnmJQ17gOKKOaOaQ
lziplzjkJQ55iUNe4pCXOOQlDnmJQ17ikJc45CUOeYlDXuKQlzjkJQ55iUNe4pCXOOQlDnmJQ17i
kJc45AXOkR/ROpg0mv/+5g81qc4/RT59/xdneerVH7XBi6DDIS9xUi9xyEsc8hKHvMQhL3HISxzy
Eoe8xCEvcchLHPISh7zEIS9xyEsc8hKHvMQhL3HISxzyEoe8xCEvccgLHEfUEc0c8hIn9RKHvMQh
L3HISxzyEoe8xCEvcchLHPISh7zEIS9xyEsc8hKHvMQhL3HISxzyEoe8xCEvcchLHPISh7zAcUQd
0cwhL3FSL3HISxzyEoe8xCEvcchLHPISh7zEIS9xyEsc8hKHvMQhL3HISxzyEoe8xCEvcchLHPIS
h7zEIS9xyAscR9QRzRzyEif1Eoe8xCEvcchLHPISh7zEIS9xyEsc8hKHvMQhL3HISxzyEoe8xCEv
cchLHPISh7zEIS9xyEsc8hKHvMBxRB3RzCEvcVIvcchLHPISh7zEIS9xyEsc8hKHvMQhL3HISxzy
Eoe8xCEvcchLHPISh7zEIS9xyEsc8hKHvMQhL3HIC5ydHtFP3PeFWT778NVNaJzqp17vPvVgk3/x
9/+uyWW3XDELdSf5tet/rwl59UzPvPp8k6f3XuQa8pJsqmfKprpqz6hd5CSpPaN2kZOk9ozaRU6S
2jNqFzlJas+oXeQkqT3U5YjCODminE31TNlUV+0ZtYucJLVn1C5yktSeUbvISVJ7Ru0iJ0ntGbWL
nCS1h7ocURgnR5SzqZ4pm+qqPaN2kZOk9ozaRU6S2jNqFzlJas+oXeQkqT2jdpGTpPZQlyMK4+SI
cjbVM2VTXbVn1C5yktSeUbvISVJ7Ru0iJ0ntGbWLnCS1Z9QucpLUHupyRGGcHFHOpnqmbKqr9oza
df6ZD5P6u43adf6ZD5P6u43aRU6S2jNqFzlJas+oXeQkqT3UdVFHlL5ir+bDd13ZpA7fvWdONKmD
OYWGJ8mVD/z1LPVJm3L5nZ9qUkeNun99bxBr6vg+/JMnmlz9+Dea0LmMMcZcvDiiEEfUGGNMEkcU
4ogaY4xJ4ohCHFFjjDFJjp0/YL2cfOWZJrc8f1cT+nagGhqeTeXXv7E3WiVXPnBVk2df+/HanHj5
ySbV+cB3PtbkK098s8m6HmOMMWPGEXVEjTHGdMYRdUSNMcZ0xhF1RI0xxnTGEXVEjTHGdObY79z0
J2fPhcaQOP70zbOc33Eu7zx+WRMatpr6SdUp9ZuB6jcKTaHB+sIjfzfLc3u/cA09KT0OeY/sDWJN
daas6yGHvMQhL3HIS5zUSxzyEoe8xCEvcchLHPISh7zEIS9xyEsc8hKHvMQhL3HISxzyEoe8xCEv
cchLHPISh7zEIS9xyEsc8hLHEYX0OOQ5ormXOOQlDnmJQ17ikJc45CUOeYlDXuKQlzjkJQ55iUNe
4pCXOOQlDnmJQ17ikJc45CUOeYlDXuKQlzjkJY4jCulxyHNEcy9xyEsc8hKHvMQhL3HISxzyEoe8
xCEvcchLHPISh7zEIS9xyEsc8hKHvMQhL3HISxzyEoe8xCEvcchLHEcU0uOQ54jmXuKQlzjkJQ55
iUNe4pCXOOQlDnmJQ17ikJc45CUOeYlDXuKQlzjkJQ55iUNe4pCXOOQlDnmJQ17ikJc4jiikxyHP
Ec29xCEvcchLHPISh7zEIS9xyEsc8hKHvMQhL3HISxzyEoe8xCEvcchLHPISh7zEIS9xyEsc8hKH
vMQhL3GOnT9g77rh/U2OP3NLk/Mfc5jUT8b+xYNXNfnGs7c1+eHrL85yz+mHm/zw9RcucuZnWuS1
vf/9/ODjtpngTKOeCx+3zQRnGuFcI56JzoWP22aCM41wrhHPROfCx20zwZlGOFdwJke0O/MzLbLm
yd5+gjONei583DYTnGmEc414JjoXPm6bCc40wrlGPBOdCx+3zQRnGuFcwZkc0e7Mz7TImid7+wnO
NOq58HHbTHCmEc414pnoXPi4bSY40wjnGvFMdC583DYTnGmEcwVnckS7Mz/TImue7O0nONOo58LH
bTPBmUY414hnonPh47aZ4EwjnGvEM9G58HHbTHCmEc4VnMkR7c78TIusebK3n+BMo54LH7fNBGca
4VwjnonOhY/bZoIzjXCuEc9E58LHbTPBmUY4V3Cm2YhuO3/7xA2z4AGNMcaYSySOqDHGGNMZR9QY
Y4zpjCNqjDHGdGbtiF5x16eb1G8Lqt8oNOWbz97e5Eevv1hyClId8hKHvMQhL3HISxzyEoe8xCEv
cchLnNRLHPISh7zEIS9xyEsc8hKHvMQhL3HISxzyEoe8xCEvcchLHPISh7zEIS9xyEsc8hKHvMQh
L3HISxzy1juOaOOQlzjkJQ55iUNe4pCXOOQlTuolDnmJQ17ikJc45CUOeYlDXuKQlzjkJQ55iUNe
4pCXOOQlDnmJQ17ikJc45CUOeYlDXuKQlzjkJQ556x1HtHHISxzyEoe8xCEvcchLHPISJ/USh7zE
IS9xyEsc8hKHvMQhL3HISxzyEoe8xCEvcchLHPISh7zEIS9xyEsc8hKHvMQhL3HISxzyEoe89Y4j
2jjkJQ55iUNe4pCXOOQlDnmJk3qJQ17ikJc45CUOeYlDXuKQlzjkJQ55iUNe4pCXOOQlDnmJQ17i
kJc45CUOeYlDXuKQlzjkJQ55iUPeescRbRzyEoe8xCEvcchLHPISh7zESb3EIS9xyEsc8hKHvMQh
L3HISxzyEoe8xCEvcchLHPISh7zEIS9xyEsc8hKHvMQhL3HISxzyEoe8xCFvvXPs/G8Q+i/f+fMm
9QFT7jtzYpa/fPS6Js/veTW1J3HISxzyEoe8xCEvcchLHPISh7zEIS9xUi9xyEsc8hKHvMQhL3HI
SxzyEoe8xCEvcchLHPISh7zEIS9xyEsc8hKHvMQhL3HISxzyEoe8xCEvcchLHEcU0uOQlzjkJQ55
iUNe4pCXOKmXOOQlDnmJQ17ikJc45CUOeYlDXuKQlzjkJQ55iUNe4pCXOOQlDnmJQ17ikJc45CUO
eYlDXuKQlzjkJY4jCulxyEsc8hKHvMQhL3HIS5zUSxzyEoe8xCEvcchLHPISh7zEIS9xyEsc8hKH
vMQhL3HISxzyEoe8xCEvcchLHPISh7zEIS9xyEsc8hLHEYX0OOQlDnmJQ17ikJc45CVO6iUOeYlD
XuKQlzjkJQ55iUNe4pCXOOQlDnmJQ17ikJc45CUOeYlDXuKQlzjkJQ55iUNe4pCXOOQlDnmJ44hC
ehzyEoe8xCEvcchLHPISJ/USh7zEIS9xyEsc8hKHvMQhL3HISxzyEoe8xCEvcchLHPISh7zEIS9x
yEsc8hKHvMQhL3HISxzyEoe8xDl243O3nz0oP37jtDHGGGMgjqgxxhjTGUfUGGOM6YwjaowxxnTm
GP2Ps7wOIS/JtnpG7SInSe0ZtYucNJvqqj2jdpGTpPaM2kVOktozahc5SWrPqF3kJKk9o3aRk6T2
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
AElFTkSuQmCC
}

}

