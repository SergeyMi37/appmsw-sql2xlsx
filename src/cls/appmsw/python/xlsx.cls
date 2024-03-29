/// Include apptools.core
Class appmsw.python.xlsx
{

/// do ##class(appmsw.python.xlsx).sql2xlsx("select * from apptools_core.Log order by id desc","n,,,,,n,,,,d","/tmp/sample-py.xlsx")
ClassMethod sql2xlsx(sql, format = "", file As %String = "d:\_proj\python\sample-py-*.xlsx", title = "")
{
	set st=$$$OK
	set myQuery = ##CLASS(%ResultSet).%New("%DynamicQuery:SQL")
	set st=myQuery.Prepare(sql)
	if 'st q st
	set st=myQuery.Execute()
	if 'st q st
	
	;prepare XLSX
	set file=$Replace(file,"*",$Tr($zts,".,"))
	try {
        set openpyxl = ##class(%SYS.Python).Import("openpyxl") 
    } catch err {
        do ##class(appmsw.python.xlsx).InstallPy("openpyxl")
        set openpyxl = ##class(%SYS.Python).Import("openpyxl") 
    }
	
	
	set wb = openpyxl.Workbook()
	#; grab the active worksheet
	set ws = wb.active
	set ws.title = "Report"
	set pybuiltins = $system.Python.Import("builtins")
	set pycols = pybuiltins.list()
	do pycols.append(" ")
	do ws.append(pycols)
	set ws."__getitem__"("A2").value=title

	set pycols = pybuiltins.list()
	set (count)=0
	set ColCount=myQuery.GetColumnCount()
	for i=1:1:ColCount {	
		do pycols.append(myQuery.GetColumnName(i))
		set col=$C(i+64)
		if i<27 set ws."column_dimensions"."__getitem__"(col).width = "20"
	}
	do ws.append(pycols)

	while (myQuery.Next())	{
		set count=count+1
		set pyrows = pybuiltins.list()
		for ii=1:1:ColCount {
			set val=myQuery.GetData(ii)
			if $P(format,",",ii)="d" { //date
				set dt = ##class(%SYS.Python).Import("datetime")
				set val=dt.datetime(+$p(val,"-",1), +$p(val,"-",2), +$p($p(val,"-",3)," "),+$p($p(val,":",1)," ",2),+$p($p(val,":",2)," ",2),+$p($p(val,":",3)," ",2))
			}
			if $P(format,",",ii)="n" { //number
				set val=+val
			}
			do pyrows.append(val)
		}
		do ws.append(pyrows)
	}
   ;}
	write !,"Save into "_file_" rows: "_count
	do wb.save(file)
	q $GET(count)
}

/// do ##class(appmsw.python.xlsx).InstallPy("openpyxl")
ClassMethod InstallPy(lib)
{
    //  depricated  ;set sc = ##class(%SYS.Python).Install("openpyxl")
    set cmd="pip3 install --target /usr/irissys/mgr/python/ "_lib
    if $zversion(1)'=3 {
        set tMgrDir = $System.Util.ManagerDirectory()
		set tBinDir = $System.Util.BinaryDirectory()_"irispip.exe"
		set cmd=tBinDir_" install --target "_tMgrDir_"python "_lib
    }
    set st=##class(%ZPM.PackageManager.Developer.Utils).RunCommandViaZF(cmd,.tLog,.tErr)
    quit $$$OK
}

/// do ##class(appmsw.python.xlsx).gn2xlsx("^||tmpQuery","","/tmp/test.xlsx","Test Title","/tmp/pattern.xlsx")
ClassMethod gn2xlsx(gn, format = "", file As %String, title = "", patternxlsx = "", sheetname = "Report")
{
	set st=$$$OK

	if '$d(@gn@(1)) q $$$ERROR($$$GeneralError,"Is empty glovals data")

	try {
        set openpyxl = ##class(%SYS.Python).Import("openpyxl") 
    } catch err {
		 do ##class(appmsw.python.xlsx).InstallPy("openpyxl")
        set openpyxl = ##class(%SYS.Python).Import("openpyxl")
    }

	if patternxlsx'="" {
		;>> from openpyxl import load_workbook
		;>>> wb = load_workbook(filename = 'patternxlsx')
		try {
			set wb = openpyxl."load_workbook"(patternxlsx)
		} catch err {
			set wb = openpyxl.Workbook()
		}
	}
	else {		
		set wb = openpyxl.Workbook()
	}

	#; grab the active worksheet
	set ws = wb.active
	set ws.title = sheetname_$g(a)
	set pybuiltins = $system.Python.Import("builtins")
	set pycols = pybuiltins.list()
	;do pycols.append(" ")
	;do ws.append(pycols)
	set ws."__getitem__"("A1").value=title

	set pycols = pybuiltins.list()
	set (count)=0
	set ColCount=$ll(@gn@(0))
	for i=1:1:ColCount {	
		do pycols.append($lg(@gn@(0),i))
		set col=$C(i+64)
		if i<27 {
			set width=$s($P(format,",",i)="d":17,$P(format,",",i)="n":10,1:30)
			set ws."column_dimensions"."__getitem__"(col).width = width
		}
	}
	do ws.append(pycols)

	for row=1:1 {
		quit:'$d(@gn@(row),data)
		set count=count+1
		set pyrows = pybuiltins.list()
		for ii=1:1:ColCount {
			set val=$lg(data,ii)
			if $P(format,",",ii)="d",val'="" { //date
				set dt = ##class(%SYS.Python).Import("datetime")
				set val=dt.datetime(+$p(val,"-",1), +$p(val,"-",2), +$p($p(val,"-",3)," "),+$p($p(val,":",1)," ",2),+$p($p(val,":",2)," ",2),+$p($p(val,":",3)," ",2))
			}
			if $P(format,",",ii)="n" { //number
				set val=+val
			}
			do pyrows.append(val)
		}
		do ws.append(pyrows)
	}
   ;}
	write !,"Save into "_file_" rows: "_count
	do wb.save(file)
	q $GET(count)
}

}

