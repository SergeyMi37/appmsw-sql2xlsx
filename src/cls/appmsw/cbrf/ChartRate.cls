/*!
 * Chart.js
 * http://chartjs.org/
 * Version: 2.7.3
 *
 * Copyright 2018 Chart.js Contributors
 * Released under the MIT license
 * https://github.com/chartjs/Chart.js/blob/master/LICENSE.md
 */

Include apptools.core

Class appmsw.cbrf.ChartRate Extends apptools.Chart.ChartPanel
{

/// http://localhost:52774/apptools/apptools.Chart.Chart.cls?panel=class(appmsw.cbrf.ChartRate).AllCurrencies&days=665&NSP=RATE
/// do ##class(appmsw.cbrf.ChartRate).AllCurrencies(.arg,1200,.res, .data, .labels)
ClassMethod AllCurrencies(arg, days, res, data, labels)
{
	set curr="GBP,USD,EUR,CNY"
	if days["(" set curr=$p($p(days,"(",2),")"),days=$p(days,"(")
	do ..GetValueCurrencies(days,curr,.res)
	
	set df=$p(res," ",1) //date from
	set dt=$p(res," ",2) //date to
	set arg("header")="The Currencies "_df_" - "_dt
	set arg("type")="line"
	set labels="["
	for yyyy=$p(df,".",3):1:$p(dt,".",3) {
		for m=1:1:12 {
			if yyyy=$p(df,".",3),m<$p(df,".",2)  continue
			if yyyy=$p(dt,".",3),m>$p(dt,".",2)  continue
			if m?1n s mm="0"_m
			else  s mm=m
			set labels=labels_""""_##class(apptools.core.type).GetTextMonth(mm)_"."_yyyy_""","
			set a="" f num=1:1 { s a=$o(res(a)) q:a=""
				if '$d(color(a)) s color(a)=num
				if '$d(data(a)) s data(a)="{  label: """_a_""", borderColor: '"_..ColorRGBa(color(a),1)_"',  data: ["
				set data(a)=data(a)_+$g(res(a,yyyy,mm))_","
			}

		}
	}
 do ..FinishArg(.res, .data, .labels, .arg)
 if 0 { //debug
	 w "<pre>" zw res zw data zw labels zw arg w "</pre>"
 }
 quit $$$OK
}

/// do ##class(appmsw.cbrf.ChartRate).GetValueCurrencies(1200,"GBP,USD,EUR",.res) zw res
/// do ##class(appmsw.cbrf.ChartRate).GetValueCurrencies("2021-01-11,2022-01-11","GBP,USD,EUR".res) zw res
ClassMethod GetValueCurrencies(date, curr, res)
{
	set from=date
		,to=date
	if date?1n.n {
		set period=##class(apptools.core.files).getPeriod(date,.FromDateTime,.ToDateTime,.df,.dt)
		set date=##class(apptools.core.type).getYYYYMMDD(df)_","_##class(apptools.core.type).getYYYYMMDD(dt)
		
	}
	if date["," {
		set from=$p(date,",",1)
		set to=$p(date,",",2)
	}
	set gn="^tmpRate"
	set sql="select CharCode, DateExchangeRates, DateReq, LastChanged, Nominal, NumCode, Value from appmsw_cbrf.tabex where DateExchangeRates >= '"_from_"' and DateExchangeRates <= '"_to_"'"
	do ##class(apptools.core.sys).SaveSQL(sql,gn)
	for i=1:1 { quit:'$d(@gn@(i))
		set code=##class(apptools.core.sys).GetValue(gn,i,"CharCode")
		if curr[code {
			set date=##class(apptools.core.sys).GetValue(gn,i,"DateExchangeRates")
			set yyyy=$p(date,"-")
			set mm=$p(date,"-",2)
			set val=##class(apptools.core.sys).GetValue(gn,i,"Value")
			set Nominal=##class(apptools.core.sys).GetValue(gn,i,"Nominal")
			if Nominal>1 set val=val/Nominal
			set res(code,yyyy,mm)=$g(res(code,yyyy,mm))_val_"|"
		}
	}
	set res=$p(from,"-",3)_"."_$p(from,"-",2)_"."_$p(from,"-",1)_" "_$p(to,"-",3)_"."_$p(to,"-",2)_"."_$p(to,"-",1)
	set a="" for { set a=$o(res(a)) quit:a=""
		set y="" for { set y=$o(res(a,y)) quit:y=""
			set m="" for { set m=$o(res(a,y,m)) quit:m=""
				set summ=0,count=0
				for i=1:1:$l(res(a,y,m),"|") { continue:$p(res(a,y,m),"|",i)=""
					set summ=summ+$p(res(a,y,m),"|",i)
					set count=count+1
				}
				;set ar=summ\count
				set ar=$j(summ/count,"",4)
				set res(a,y,m)=ar
			}
		}
	}
}

}

