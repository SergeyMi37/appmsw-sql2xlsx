/// Loading the Exchange rate of the Central Bank of the Russian Federation
Class appmsw.cbrf.tabexDay Extends (%Persistent, %XML.Adaptor)
{

Property Date As %String(XMLNAME = "Date", XMLPROJECTION = "attribute");

Property DateReq As %Date(FORMAT = 3);

Index DateReqIndex On DateReq [ Unique ];

Property Values As list Of appmsw.cbrf.tabex(XMLNAME = "Valute", XMLPROJECTION = "ELEMENT");

/// Write $System.Status.GetErrorText(##class(appmsw.cbrf.tabexDay).CheckDay("2021-12-12",.cnt))
ClassMethod CheckDay(Date As %String, cnt) As appmsw.cbrf.tabexDay
{
	set sc=$$$OK
		,cnt=0
	set Date=$system.SQL.TODATE(Date,"YYYY-MM-DD") 
	set sql="SELECT ID FROM appmsw_cbrf.tabexDay WHERE DateReq='"_Date_"'"
		,error=$$$NULLOREF
	set query=##class(%ResultSet.SQL).%Prepare(sql,.error)
	quit:$isobject(error) $$$ERROR($$$GeneralError,error.Message)
	while query.%Next() {
		set cnt=cnt+1
	}
	quit sc
}

/// set obj=##class(appmsw.cbrf.tabexDay).GetByDay("2021-12-12")
ClassMethod GetByDay(Date As %String) As %Status
{
	set Date=$system.SQL.TODATE(Date,"YYYY-MM-DD") 
	set sql="SELECT ID FROM appmsw_cbrf.tabexDay WHERE DateReq='"_Date_"'",error=$$$NULLOREF
	set query=##class(%ResultSet.SQL).%Prepare(sql,.error)
	quit:$isobject(error) $$$ERROR($$$GeneralError,error.Message)
	set obj=""
	while query.%Next() {
		set obj=query.ID		
	}
	quit obj
}

/// Write $System.Status.GetErrorText(##class(appmsw.cbrf.tabexDay).KillDay("2021-12-12"))
/// Set tSC = ##class(appmsw.cbrf.tabexDay).%KillExtent() Set tSC = ##class(appmsw.cbrf.tabex).%KillExtent()
ClassMethod KillDay(Date As %String) As %Status
{
	set Date=$system.SQL.TODATE(Date,"YYYY-MM-DD") 
	set sql="SELECT ID1 FROM appmsw_cbrf.tabexDay WHERE DateReq='"_Date_"'",error=$$$NULLOREF
	set query=##class(%ResultSet.SQL).%Prepare(sql,.error)
	quit:$isobject(error) $$$ERROR($$$GeneralError,error.Message)
	set sc=$$$OK
	while query.%Next() {
		;w !,query.ID1.%Id()
		s sc=##class(appmsw.cbrf.tabex).%DeleteId(query.ID1.%Id())
	}
	quit sc
}

/// write ##class(appmsw.cbrf.tabexDay).getDate2DDMMYYYY("2021-12-12")
ClassMethod getDate2DDMMYYYY(sDate As %String) As %String
{
	if sDate["-" s date=$p(sDate,"-",3)_"."_$p(sDate,"-",2)_"."_$p(sDate,"-",1)
	if sDate["." s date=sDate
	if sDate["/" s date=$p(sDate,"/",2)_"."_$p(sDate,"/",1)_"."_$p(sDate,"/",3)
	quit $g(date)
}

/// write ##class(appmsw.cbrf.tabexDay).LoadDay("http://www.cbr.ru/scripts/xml_daily.asp?date_req=","12.12.2021")
ClassMethod LoadDay(URL As %String, Date, Count, outObj) As %Status
{
    #Dim Status As %Status = $$$OK
    Set Reader = ##class(%XML.Reader).%New()
    Set Count = 0
	set Date=..getDate2DDMMYYYY(Date)
    Set Status = Reader.OpenURL(URL_Date)
    Quit:$$$ISERR(Status) Status

    Do Reader.Correlate("ValCurs", $classname())
	set DateReq=$system.SQL.TODATE(Date,"DD.MM.YYYY") 
	
	//;d ..KillDay($zd(DateReq,3))
    While Reader.Next(.Object, .Status) {
        #Dim Object As appmsw.cbrf.tabexDay

        If $isobject(Object) {
	        
	        Set RealDate = $system.SQL.TODATE(Object.Date,"DD.MM.YYYY") 
	        For i=1:1:Object.Values.Count() {
		        Set Object.Values.GetAt(i).Date = RealDate
		        Set Object.Values.GetAt(i).DateReq = DateReq
		        Set Object.Values.GetAt(i).LastChanged = $zdatetime($ztimestamp,3,,3)
		        Set Object.Values.GetAt(i).DateExchangeRates = $zd(DateReq,3)
		        Set Count = Count + 1
	        }
        	set Object.DateReq=DateReq
            Set Status = Object.%Save()
            Quit:$$$ISERR(Status)
            set outObj(Date)=Object
        }
    }
    Quit Status
}

Storage Default
{
<Data name="tabexDayDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Date</Value>
</Value>
<Value name="3">
<Value>DateReq</Value>
</Value>
<Value name="4">
<Value>Values</Value>
</Value>
</Data>
<DataLocation>^appmsw.cbrf.tabexDayD</DataLocation>
<DefaultData>tabexDayDefaultData</DefaultData>
<IdLocation>^appmsw.cbrf.tabexDayD</IdLocation>
<IndexLocation>^appmsw.cbrf.tabexDayI</IndexLocation>
<StreamLocation>^appmsw.cbrf.tabexDayS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

