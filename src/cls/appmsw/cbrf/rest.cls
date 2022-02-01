/// The REST interface: class that routes HTTP requests
Class appmsw.cbrf.rest Extends %CSP.REST
{

Parameter CONTENTTYPE = "application/json";

Parameter CHARSET = "UTF-8";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/a/:text" Method="GET" Call="apptools.lte.adminStatic:GetMain"/>
<Route Url="/get-html/:text" Method="GET" Call="apptools.core.rest:Index"/>
<Route Url="/post-json" Method="POST" Call="apptools.core.rest:jsonrpc"/>
<Route Url="/get-files/:text" Method="GET" Call="apptools.core.rest:Files"/>

<Route Url="/testget/:text" Method="GET" Call="Test"/>  
<Route Url="/exchange/:date" Method="GET" Call="exchange"/>
</Routes>
}

ClassMethod Test(parameter) As %Status
{
	set %response.CharSet = "utf-8"
    set %response.ContentType = "text/html"
	&html<<h1>Status: OK!</h1><pre>>
	zw %request
	zw %response
	zw parameter
	&html<</pre>>
	quit $$$OK
}

/// Search exchange rate by date
/// http://localhost:52774/cbrf-rate/exchange/2021-11-11,2021-11-12
ClassMethod exchange(date = "") As %Status
{
	set from=date
		,to=date
	if date["," {
		set from=$p(date,",",1)
		set to=$p(date,",",2)
	}
	;set sql="select * from appmsw_cbrf.tabex where DateExchangeRates >= '"_from_"' and DateExchangeRates <= '"_to_"'"
	set sql="select CharCode, DateExchangeRates, DateReq, LastChanged, Nominal, NumCode, Value from appmsw_cbrf.tabex where DateExchangeRates >= '"_from_"' and DateExchangeRates <= '"_to_"'"
	#if $$$comClassDefined("%ZEN.Auxiliary.jsonSQLProvider")
		set Provider = ##class(%ZEN.Auxiliary.jsonSQLProvider).%New()
		set Provider.sql = sql
		Set Provider.%Format = "tw" ;$$$formatJSONSQL
		Set Provider.maxRows = 10000
		set st = Provider.%DrawJSON()
	#else
		set st = $$$ERROR($$$GeneralError,"Class %ZEN.Auxiliary.jsonSQLProvider does not exist")
	#endif
	return st
}

}

