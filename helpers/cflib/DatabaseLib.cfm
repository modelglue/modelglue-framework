<!---
	
	This library is part of the Common Function Library Project. An open source
	collection of UDF libraries designed for ColdFusion 5.0. For more information,
	please see the web site at:
		
		http://www.cflib.org
		
	Warning:
	You may not need all the functions in this library. If speed
	is _extremely_ important, you may want to consider deleting
	functions you do not plan on using. Normally you should not
	have to worry about the size of the library.
		
	License:
	This code may be used freely. 
	You may modify this code as you see fit, however, this header, and the header
	for the functions must remain intact.
	
	This code is provided as is.  We make no warranty or guarantee.  Use of this code is at your own risk.
--->

<cfscript>
/**
 * Takes a ColdFusion date object and returns a DB2 formatted timestamp.
 * 
 * @param dateObj 	 A data object. (Required)
 * @param emulateTick 	 A boolean. (Required)
 * @return Returns a string. 
 * @author Chris Wigginton (&#99;&#119;&#105;&#103;&#103;&#105;&#110;&#116;&#111;&#110;&#64;&#109;&#97;&#99;&#114;&#111;&#109;&#101;&#100;&#105;&#97;&#46;&#99;&#111;&#109;) 
 * @version 1, June 27, 2002 
 */
function getDB2TimeStamp(dateObj, emulateTick)
{
	var tick = "000000";
	// We can partially emulate milliseconds by 
	//grabbing the current tick and applying it to the date object
	if(emulateTick IS "Yes")
		tick = Right(GetTickCount(),3) & "000";
		
	return DateFormat(dateObj, "yyyy-mm-dd-") & TimeFormat(dateObj, "HH.mm.ss.") & tick; 
}

/**
 * Gets a list of DSNs.
 * 
 * @return Returns an array. 
 * @author Raymond Camden (&#114;&#97;&#121;&#64;&#99;&#97;&#109;&#100;&#101;&#110;&#102;&#97;&#109;&#105;&#108;&#121;&#46;&#99;&#111;&#109;) 
 * @version 1, November 15, 2002 
 */
function getDSNs() {
	var factory = createObject("java","coldfusion.server.ServiceFactory");
	return factory.getDataSourceService().getNames();
}

/**
 * Tests a string, one-dimensional array, or simple struct for possible SQL injection.
 * 
 * @param input 	 String to check. (Required)
 * @return Returns a boolean. 
 * @author Will Vautrain (&#118;&#97;&#117;&#116;&#114;&#97;&#105;&#110;&#64;&#121;&#97;&#104;&#111;&#111;&#46;&#99;&#111;&#109;) 
 * @version 1, July 1, 2002 
 */
function IsSQLInject(input) {
	/*
	* The SQL-injection strings were used at the suggestion of Chris Anley [chris@ngssoftware.com]
	* in his paper "Advanced SQL Injection In SQL Server Applications" available for downloat at
	* http://www.ngssoftware.com/
	*/
	var listSQLInject = "select,insert,update,delete,drop,--,'";
	var arraySQLInject = ListToArray(listSQLInject);
	var i = 1;
	
	for(i=1; i lte arrayLen(arraySQLInject); i=i+1) {
		if(findNoCase(arraySQLInject[i], input)) return true;
	}
	
	return false;
}

/**
 * Creates UUIDs safe for use in MSSQL UNIQUEIDENTIFIER fields.
 * 
 * @param format 	 UUID format to generate.  Options are String or Binary. (Optional)
 * @return Returns a string. 
 * @author Chip Temm (&#99;&#104;&#105;&#112;&#64;&#97;&#110;&#116;&#104;&#114;&#111;&#108;&#111;&#103;&#105;&#107;&#46;&#110;&#101;&#116;) 
 * @version 1, June 27, 2002 
 */
function MSSQL_createUUID(){
	var format = 'string';
	// uniqueidentifier wombat_createUUID([string FORMAT])
	//returns a UUID in the format specified.  
	//optional argument FORMAT defaults to string (MS-SQL uniqueidentifier safe)
	//accepts 'binary' or 'string'.  other values fail quietly to 'string'
	
	
	if(arraylen(Arguments)){
		if(arguments[1] eq 'binary' or arguments[1] eq 'string'){
			format = arguments[1];
		}
	}
	
	if(format eq 'string'){
		return Insert("-", CREATEuuid(), 23);
		/***   NOTE quoted usage is SQL statement:
		Insert into attribute (attributeID) values ('#wombat_createUUID()#')
		***/
	
	}else{//must be raw binary
		return '0x' & Replace(CREATEuuid(),'-','','All'); 
		/***   NOTE UN-quoted usage is SQL statement:
		Insert into attribute (attributeID) values (#wombat_createUUID('binary')#)
		Good for cases where the value maybe either NULL or a UUID
		(neither of which should be quoted)
		***/
	}
}

/**
 * Checks to see if the number is a valid SQL-92 integer.
 * Rewritten by RCamden. Code didn't work as submitted.
 * 
 * @param number 	 Number to check. (Required)
 * @return Returns a number. 
 * @author Michael Slatoff (&#109;&#105;&#99;&#104;&#97;&#101;&#108;&#64;&#115;&#108;&#97;&#116;&#111;&#102;&#102;&#46;&#99;&#111;&#109;) 
 * @version 1, April 1, 2003 
 */
function MSSQLInt(number) {
	if (val(number) LT -2147483648 OR val(number) GT 2147483247) return 0;
	else return number;
}

/**
 * Converts a CF DateTime object into a MySQL timestamp.
 * 
 * @param dt 	 Date object. (Required)
 * @return Returns a string. 
 * @author Mark Andrachek (&#104;&#97;&#108;&#108;&#111;&#119;&#64;&#119;&#101;&#98;&#109;&#97;&#103;&#101;&#115;&#46;&#99;&#111;&#109;) 
 * @version 1, June 27, 2002 
 */
function MySQLDT2TS(dt) {
	return Year(dt) & NumberFormat(Month(dt),'00') & NumberFormat(Day(dt),'00') & NumberFormat(Hour(dt),'00') & NumberFormat(Minute(dt),'00') & NumberFormat(Second(dt),'00');
}

/**
 * Converts a MySQL timestamp to a CF DateTime object.
 * 
 * @param timestamp 	 MySQL time stamp. (Required)
 * @return Returns a date/time object. 
 * @author Mark Andrachek (&#104;&#97;&#108;&#108;&#111;&#119;&#64;&#119;&#101;&#98;&#109;&#97;&#103;&#101;&#115;&#46;&#99;&#111;&#109;) 
 * @version 1, June 27, 2002 
 */
function MySQLTS2DT(timestamp) {
	return CreateDateTime(Left(timestamp,4),Mid(timestamp,5,2),Mid(timestamp,7,2),Mid(timestamp,9,2),Mid(timestamp,11,2),Mid(timestamp,13,2));
}

/**
 * Useful in constructing SQL statements that must handle empty strings as NULLs.
 * Rewritten to use one UDF by RCamden
 * 
 * @param columnValue 	 The value to test.  (Required)
 * @param dataType 	 Allows you to specify 'alpha' or 'numeric'. If alpha, value is wrapped in single quotes. Default is alpha. (Optional)
 * @return Returns a string. 
 * @author Charles McElwee (&#99;&#109;&#99;&#101;&#108;&#119;&#101;&#101;&#64;&#101;&#116;&#101;&#99;&#104;&#115;&#111;&#108;&#117;&#116;&#105;&#111;&#110;&#115;&#46;&#99;&#111;&#109;) 
 * @version 1, September 20, 2002 
 */
function NullColumn(columnValue) {
	var dataType = "alpha";
	
	if(arrayLen(arguments) gte 2) dataType = arguments[2];
	if(trim(columnValue) eq "") return "NULL";
 	else if(dataType is "alpha") return "'" & columnValue & "'";
	else return columnValue;
}

/**
 * Removes ms sql freetext stop words from a sting.
 * 
 * @param TheList 	 List of items to check. (Required)
 * @param delims 	 List of delimiters. Defaults to a comma. (Optional)
 * @return Returns a string. 
 * @author Joe Graves (&#106;&#111;&#101;&#64;&#115;&#116;&#97;&#103;&#105;&#110;&#103;&#114;&#111;&#111;&#109;&#46;&#99;&#111;&#109;) 
 * @version 1, August 10, 2007 
 */
/**
 * Remove Stop words from list for SQL FreeText Search.
 * 
 * @function:  RemoveSQLStops
 * @param required: TheList
 * @param dilims optional: The delimiters add as the second argument
 * @return a string with stop words removed.
 * @syntax default: RemoveSQLStops("The,stuff,to,remove")
 * @syntax optional delimiter: RemoveSQLStops("The stuff to remove", " ")
 * @author Joe Graves StagingRoom.com (joe@stagingroom.com) 
 * @version 1, 12/08/2006 
 */
function removeSQLStops(TheList){
// list of stop words 
var TheStopList="a,about,1,after,2,all,also,3,an,4,and,5,another,6,any,7,are,8,as,9,at,0,be,$,because,been,before,being,between,both,but,by,came,can,come,could,did,do,each,for,from,get,got,has,had,he,have,her,here,him,himself,his,how,if,in,into,is,it,like,make,many,me,might,more,most,much,must,my,never,now,of,on,only,or,other,our,out,over,said,same,see,should,since,some,still,such,take,than,that,the,their,them,then,there,these,they,this,those,through,to,too,under,up,very,was,way,we,well,were,what,where,which,while,who,with,would,you,your";

var delims = ",";
var i=1;
var OriginalSize=0;
var results="";

//check for declared delimiter
if(arrayLen(arguments) gt 1) delims = arguments[2];

// get the size of the list
OriginalSize=listlen(TheList,delims);

// loop over the list and search for stop words
	for(; i lte OriginalSize; i=i+1){
	//if the word is not in the stop word list add it to the results
		if(ListFindNoCase(TheStopList, ListGetAt(TheList,i,delims),"," ) EQ 0) {
	// word a are added to new list (list is returned with the same delimiter passed in to the function) 
				results=ListAppend(results,(ListGetAt(TheList,i,delims)),delims);
			}
		}
		return results;
}

/**
 * Cleans string of potential sql injection.
 * 
 * @param string 	 String to modify. (Required)
 * @return Returns a string. 
 * @author Bryan Murphy (&#98;&#114;&#121;&#97;&#110;&#64;&#103;&#117;&#97;&#114;&#100;&#105;&#97;&#110;&#108;&#111;&#103;&#105;&#99;&#46;&#99;&#111;&#109;) 
 * @version 1, May 26, 2005 
 */
function metaguardSQLSafe(string) {
  var sqlList = "-- ,'";
  var replacementList = "#chr(38)##chr(35)##chr(52)##chr(53)##chr(59)##chr(38)##chr(35)##chr(52)##chr(53)##chr(59)# , #chr(38)##chr(35)##chr(51)##chr(57)##chr(59)#";
  
  return trim(replaceList( string , sqlList , replacementList ));
}
</cfscript>

/**
 * Normalizes the various possible returned keys in the cfquery result struct.
 * 
 * @param resultStruct 	 Structure. (Required)
 * @return Returns a value. 
 * @author Todd Sharp (&#116;&#111;&#100;&#100;&#64;&#99;&#102;&#115;&#105;&#108;&#101;&#110;&#99;&#101;&#46;&#99;&#111;&#109;) 
 * @version 1, February 15, 2008 
 */
<cffunction name="getGeneratedKey" hint="i normalize the key returned from cfquery" output="false">
	<cfargument name="resultStruct" hint="the result struct returned from cfquery" />
	<cfif structKeyExists(arguments.resultStruct, "IDENTITYCOL")>
		<cfreturn arguments.resultStruct.IDENTITYCOL />
	<cfelseif structKeyExists(arguments.resultStruct, "ROWID")>
		<cfreturn arguments.resultStruct.ROWID />
	<cfelseif structKeyExists(arguments.resultStruct, "SYB_IDENTITY")>
		<cfreturn arguments.resultStruct.SYB_IDENTITY />
	<cfelseif structKeyExists(arguments.resultStruct, "SERIAL_COL")>
		<cfreturn arguments.resultStruct.SERIAL_COL />	
	<cfelseif structKeyExists(arguments.resultStruct, "GENERATED_KEY")>
		<cfreturn arguments.resultStruct.GENERATED_KEY />
	<cfelse>
		<cfreturn />
	</cfif>
</cffunction>

<!---
 Search SQL Server Stored Procedures for a value.
 
 @param datasource 	 Database to search. (Required)
 @param searchstring 	 Name to search for. (Required)
 @return Returns a query of stored procedure names that match. 
 @author Jose Diaz (&#98;&#108;&#101;&#97;&#99;&#104;&#101;&#100;&#98;&#117;&#103;&#64;&#103;&#109;&#97;&#105;&#108;&#46;&#99;&#111;&#109;) 
 @version 1, November 14, 2007 
--->
<cffunction name="cfStoredProcSearch" access="public" returntype="query" output=false>

	<cfargument name="datasource" type="string" required="true"/>
	<cfargument name="searchString" type="string" required="true"/>
	<cfset var qStoredProcSearch = "">

	<cfquery name="qStoredProcSearch" datasource="#arguments.datasource#">
		select name
		from sysobjects s
		   , syscomments c
		where s.id = c.id and text like '%#arguments.searchString#%'
	</cfquery>


	<cfreturn qStoredProcSearch />

</cffunction>

<!---
 Export table data in script format (INSERT statements).
 Modified by Raymond
 v2 by Joseph Flanigan (&#106;&#111;&#115;&#101;&#112;&#104;&#64;&#115;&#119;&#105;&#116;&#99;&#104;&#45;&#98;&#111;&#120;&#46;&#111;&#114;&#103;)
 
 @param table 	 Table to export. (Required)
 @param dbsource 	 DSN. (Required)
 @param dbuser 	 Database username. (Optional)
 @param dbpassword 	 Database password. (Optional)
 @param commitAfter 	 Inserts commit statements after a certain number of rows. Defaults to 100. (Optional)
 @return Returns a string. 
 @author Asif Rashid (&#106;&#111;&#115;&#101;&#112;&#104;&#64;&#115;&#119;&#105;&#116;&#99;&#104;&#45;&#98;&#111;&#120;&#46;&#111;&#114;&#103;&#97;&#115;&#105;&#102;&#114;&#97;&#115;&#104;&#101;&#101;&#100;&#64;&#114;&#111;&#99;&#107;&#101;&#116;&#109;&#97;&#105;&#108;&#46;&#99;&#111;&#109;) 
 @version 2, April 18, 2006 
--->
<cffunction name="exportSQLTable" returnType="string" output="false">
        <cfargument name="table" type="string" required="true">
        <cfargument name="dbsource" type="string" required="true">
        <cfargument name="dbuser" type="string" required="false" default="">
        <cfargument name="dbpassword" type="string" required="false" default="">
        <cfargument name="commitAfter" default="100" type="numeric">

        <cfset var i = 1>
        <cfset var j = 1>
        <cfset var k = 0>
        <cfset var temp = "">
        <cfset var qryTemp = "">
        <cfset var tempCol = "">
        <cfset var str = "">
        <cfset var textstr = "">

        <!--- Getting table data --->
        <cfquery name="qryTemp" datasource="#arguments.dbsource#" username= "#arguments.dbuser#" password="#arguments.dbpassword#">
                select * from #arguments.table#
        </cfquery>

        <!--- Getting meta information of executed query --->
        <cfset tempCol = getMetaData(qryTemp)>
        <cfset k =      ArrayLen(tempCol) >

        <cfloop query="qryTemp">
                <cfset temp = "INSERT INTO " & arguments.table &" (">
                <cfloop index="j" from="1" to="#k#">
                        <cfset temp = temp & "[#tempCol[j].Name#]" >
                 <cfif j NEQ k >
                        <cfset temp = temp & "," >
                 </cfif>
                </cfloop>


                <cfset temp = temp & ") VALUES (">
                <cfloop index="j" from="1" to="#k#">
                        <cfif FindNoCase("char", tempCol[j].TypeName)
                              OR FindNoCase("date", tempCol[j].TypeName)
                                  OR FindNoCase("text", tempCol[j].TypeName)
                                  OR FindNoCase("unique", tempCol[j].TypeName)
                                  OR FindNoCase("xml", tempCol[j].TypeName)
                                   >
                                <cfset textstr = qryTemp[tempCol[j].Name][i] >
                                <cfif Find("'",textstr)>
                                  <cfset textstr = Replace(textstr,"'","'","ALL") >
                                </cfif>
                                <cfset temp = temp & "'" & textstr & "'" >
                        <cfelseif FindNoCase("image",tempCol[j].TypeName)>
                                 <cfset temp = temp & "'" >
                        <cfelse>
                                <cfset temp = temp & qryTemp[#tempCol[j].Name#][i] >
                        </cfif>
                  <cfif j NEQ k >
                        <cfset temp = temp  &  "," >
                 </cfif>

                </cfloop>
                <cfset temp = temp & ");">
                <cfset str = str & temp & chr(10)>
                <cfif i mod commitAfter EQ 0>
                        <cfset str = str & "commit;" & chr(10)>
                </cfif>
                <cfset i = i + 1>
        </cfloop>
        <cfreturn str>
</cffunction>

<!---
 Returns the SQL statement used to generate the specified query.
 
 @param queryname 	 Name of the query you wish to return the SQL statement for. (Required)
 @return Returns a string. 
 @author Ben Forta (&#98;&#101;&#110;&#64;&#102;&#111;&#114;&#116;&#97;&#46;&#99;&#111;&#109;) 
 @version 1, October 15, 2002 
--->
<CFFUNCTION NAME="QueryGetSQL" RETURNTYPE="string">

	<!--- Query name is required --->
	<CFARGUMENT NAME="queryname" TYPE="string" REQUIRED="yes">

        <!--- Initialize variables --->
        <CFSET var cfdebugger="">
        <CFSET var events ="">
        
	<!--- Initialize result string --->
	<CFSET var result="">

	<!--- Requires debug mode --->
	<CFIF IsDebugMode()>

		<!--- Use debugging service --->
		<CFOBJECT ACTION="CREATE"
		          TYPE="JAVA"

CLASS="coldfusion.server.ServiceFactory"
				  NAME="factory">
		<CFSET cfdebugger=factory.getDebuggingService()>

		<!--- Load the debugging service's event table --->
		<CFSET events = cfdebugger.getDebugger().getData()>

		<!--- Get SQL statement (body) for specified query --->
		<CFQUERY DBTYPE="query" NAME="getquery" DEBUG="false">
		SELECT body
		FROM events
		WHERE type='SqlQuery' AND name='#queryname#'
		</CFQUERY>

		<!--- Save result --->
		<CFSET result=getquery.body>
	</CFIF>

	<!--- Return string --->
	<CFRETURN result>
</CFFUNCTION>

<!---
 This function will return all child tables of a mySQL database as an array.
 
 @param Path 	 Path to where mysqlshow exists. (Required)
 @param Database 	 Database to inspect. (Required)
 @param Timeout 	 Time to wait for results. Defaults to 30. (Optional)
 @return Returns an array. 
 @author brandon wyckoff (&#98;&#119;&#121;&#99;&#107;&#111;&#102;&#102;&#50;&#64;&#99;&#111;&#120;&#46;&#110;&#101;&#116;) 
 @version 1, June 4, 2004 
--->
<cffunction name="showDatabaseTablesMySQL">
	<cfargument name="path" required="true">
	<cfargument name="database" required="true">
	<cfargument name="timeout" required="false" default="30">
	<cfscript>
		var a = "";
		var x = "";
		var y = 1;
		database=replace(database, '_', '\_', 'all');
	</cfscript>
	<cfexecute name="#arguments.path#\mysqlshow" arguments="#arguments.database#" timeout="#arguments.timeout#" variable="mySQLDB"></cfexecute>
	<cfscript>
		a=replaceList(mySQLDB,'+,-, ,','');
		a=trim(a);
		x=arrayNew(1);
	</cfscript>
	<cfloop list="#a#" index="i" delimiters="|">
		<cfscript>
			if (not compareNoCase(left(i, 9), "Database:")) {
					
			} else if (not compareNoCase(trim(replace(i, '|', '', 'all')),"Tables")) {
					x = arrayNew(1);
			} else if (compareNoCase(trim(i), "")) {
					x[y]=i;
					y=y+1;			
			}
		</cfscript>
	</cfloop>
	<cfreturn x>
</cffunction>

<!---
 Verifies a DSN is working.
 
 @param dsn 	 Name of a DSN you want to verify. (Required)
 @return Returns a Boolean. 
 @author Ben Forta (&#98;&#101;&#110;&#64;&#102;&#111;&#114;&#116;&#97;&#46;&#99;&#111;&#109;) 
 @version 1, October 15, 2002 
--->
<CFFUNCTION NAME="VerifyDSN" RETURNTYPE="boolean">
   <CFARGUMENT NAME="dsn" TYPE="string" REQUIRED="yes">

   <!--- initialize variables --->
   <CFSET var dsService="">
   <!--- Try/catch block, throws errors if bad DSN --->
   <CFSET var result="true">


   <CFTRY>
      <!--- Get "factory" --->
      <CFOBJECT ACTION="CREATE"
                TYPE="JAVA"
                CLASS="coldfusion.server.ServiceFactory"
                NAME="factory">
      <!--- Get datasource service --->
      <CFSET dsService=factory.getDataSourceService()>
      <!--- Validate DSN --->
      <CFSET result=dsService.verifyDatasource(dsn)>

      <!--- If any error, return FALSE --->
	  <CFCATCH TYPE="any">
	     <CFSET result="false">
	  </CFCATCH>
   </CFTRY>

   <CFRETURN result>
</CFFUNCTION>
