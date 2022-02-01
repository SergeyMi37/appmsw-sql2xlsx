/// Сurrencies
Class appmsw.cbrf.tabcurr Extends (%Persistent, %XML.Adaptor)
{

Property NumCode As %String(XMLNAME = "NumCode");

Property CharCode As %String(XMLNAME = "CharCode");

Property Name As %String(XMLNAME = "Name");

Index NumCodeIndex On NumCode [ Unique ];

Storage Default
{
<Data name="tabcurrDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NumCode</Value>
</Value>
<Value name="3">
<Value>CharCode</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^appmsw.cbrf.tabcurrD</DataLocation>
<DefaultData>tabcurrDefaultData</DefaultData>
<ExtentSize>0</ExtentSize>
<IdLocation>^appmsw.cbrf.tabcurrD</IdLocation>
<IndexLocation>^appmsw.cbrf.tabcurrI</IndexLocation>
<StreamLocation>^appmsw.cbrf.tabcurrS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

