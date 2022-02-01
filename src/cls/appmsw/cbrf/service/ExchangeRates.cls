/// Updating exchange rates
Class appmsw.cbrf.service.ExchangeRates Extends Ens.BusinessService
{

Parameter ADAPTER = "Ens.InboundAdapter";

/// will stop if loaded
Property StopIfLoaded As %Boolean [ InitialExpression = "1" ];

/// Start the service on a specific day (DD.MM.YYYY)
Property DateReg As %String(MAXLEN = 250);

/// Link to the service of the Central Bank
Property URL As %String(MAXLEN = 350) [ InitialExpression = "http://www.cbr.ru/scripts/xml_daily.asp?date_req=" ];

/// Number of days ago to check
Property CountDay As %Integer [ InitialExpression = "10" ];

Parameter SETTINGS = "StopIfLoaded:Basic,URL:Basic,DateReg:Basic,CountDay:Basic";

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
	if ..DateReg'="" s Day=..DateReg $$$TRACE("Date from settings :"_Day)
	else  s Day=$zd($h,3) $$$TRACE("Date today :"_Day)
	set sc=$$$OK
	$$$TRACE("---Start")
	// Let's put the date in the format $H
	set DateH=$system.SQL.TODATE(##class(appmsw.cbrf.tabexDay).getDate2DDMMYYYY(Day),"DD.MM.YYYY") 
	// Loop backwards by dates
	set CountDay=..CountDay
	set:'CountDay CountDay=10
	set IfLoaded=0
	for hor=DateH:-1:(DateH-CountDay) {
		set DateLoop=$zd(hor,3)
		$$$TRACE("Loop backwards by dates :"_DateLoop)
		set sc=..LoadDate(DateLoop,.IfLoaded)
		if $GET(IfLoaded),..StopIfLoaded $$$TRACE("Stop If Loaded") quit
	}
	$$$TRACE("---Stop")
	quit sc
}

/// Load Day YYYY-MM-DD 
Method LoadDate(Day, ByRef IfLoaded) As %Status
{
 s st=$$$OK
 s obj=##class(appmsw.cbrf.tabexDay).GetByDay(Day)
	if '$isobject(obj) {
		s URL=..URL
		s:URL="" URL="http://www.cbr.ru/scripts/xml_daily.asp?date_req="
		set st=##class(appmsw.cbrf.tabexDay).LoadDay(URL,Day,.count)
		$$$TRACE(Day_" Load count: "_$g(count))
	} else {
		$$$TRACE(Day_" Boot call from central bank is not required")
		set IfLoaded=1
	}
	q st
}

}

