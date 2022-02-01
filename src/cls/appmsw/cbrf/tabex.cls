/// Daily Loading the Exchange rate of the Central Bank of the Russian Federation
Class appmsw.cbrf.tabex Extends (%Persistent, %XML.Adaptor)
{

Property DateReq As %Date(FORMAT = 3);

Index DateReqIndex On DateReq;

Property DateExchangeRates As %String;

Property LastChanged As %String;

Property Date As %Date(FORMAT = 3, XMLNAME = "Date", XMLPROJECTION = "attribute");

Property ID As %String(XMLNAME = "ID", XMLPROJECTION = "attribute");

Property NumCode As %String(XMLNAME = "NumCode");

Property CharCode As %String(XMLNAME = "CharCode");

Property Name As %String(XMLNAME = "Name");

Property Nominal As %Integer(XMLNAME = "Nominal");

/// The value of the exchange rate against the ruble
Property Value As %String(XMLNAME = "Value");

Storage Default
{
<Data name="tabexDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DateReq</Value>
</Value>
<Value name="3">
<Value>DateExchangeRates</Value>
</Value>
<Value name="4">
<Value>LastChanged</Value>
</Value>
<Value name="5">
<Value>Date</Value>
</Value>
<Value name="6">
<Value>ID</Value>
</Value>
<Value name="7">
<Value>NumCode</Value>
</Value>
<Value name="8">
<Value>CharCode</Value>
</Value>
<Value name="9">
<Value>Name</Value>
</Value>
<Value name="10">
<Value>Nominal</Value>
</Value>
<Value name="11">
<Value>Value</Value>
</Value>
</Data>
<DataLocation>^appmsw.cbrf.tabexD</DataLocation>
<DefaultData>tabexDefaultData</DefaultData>
<IdLocation>^appmsw.cbrf.tabexD</IdLocation>
<IndexLocation>^appmsw.cbrf.tabexI</IndexLocation>
<StreamLocation>^appmsw.cbrf.tabexS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

