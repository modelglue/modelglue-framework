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

<!---
 Mimics the cfabort tag.
 
 @param showError 	 An error to throw. (Optional)
 @return Does not return a value. 
 @author Raymond Camden (&#114;&#97;&#121;&#64;&#99;&#97;&#109;&#100;&#101;&#110;&#102;&#97;&#109;&#105;&#108;&#121;&#46;&#99;&#111;&#109;) 
 @version 1, October 16, 2002 
--->
<cffunction name="abort" output="false" returnType="void">
	<cfargument name="showError" type="string" required="false">
	<cfif isDefined("showError") and len(showError)>
		<cfthrow message="#showError#">
	</cfif>
	<cfabort>
</cffunction>

<!---
 Mimics the cfdirectory, action=&quot;create&quot; command.
 
 @param directory 	 Name of directory to create. (Required)
 @param mode 	 Mode to apply to directory. (Optional)
 @return Does not return a value. 
 @author Raymond Camden (&#114;&#97;&#121;&#64;&#99;&#97;&#109;&#100;&#101;&#110;&#102;&#97;&#109;&#105;&#108;&#121;&#46;&#99;&#111;&#109;) 
 @version 1, October 15, 2002 
--->
<cffunction name="directoryCreate" output="false" returnType="void">
	<cfargument name="directory" type="string" required="true">
	<cfargument name="mode" type="string" required="false" default="">
	<cfif len(mode)>
		<cfdirectory action="create" directory="#directory#" mode="#mode#">
	<cfelse>
		<cfdirectory action="create" directory="#directory#">
	</cfif>
</cffunction>

<!---
 Mimics the cfdirectory tag, action=&quot;delete&quot; command.
 
 @param directory 	 The directory to delete. (Required)
 @return Does not return a value. 
 @author Raymond Camden (&#114;&#97;&#121;&#64;&#99;&#97;&#109;&#100;&#101;&#110;&#102;&#97;&#109;&#105;&#108;&#121;&#46;&#99;&#111;&#109;) 
 @version 1, October 15, 2002 
--->
<cffunction name="directoryDelete" output="false" returnType="void">
	<cfargument name="directory" type="string" required="true">
	<cfdirectory action="delete" directory="#directory#">
</cffunction>

<!---
 Mimics the cfdirectory, action=&quot;list&quot; command.
 Updated with final CFMX var code.
 Fixed a bug where the filter wouldn't show dirs.
 
 @param directory 	 The directory to list. (Required)
 @param filter 	 Optional filter to apply. (Optional)
 @param sort 	 Sort to apply. (Optional)
 @param recurse 	 Recursive directory list. Defaults to false. (Optional)
 @return Returns a query. 
 @author Raymond Camden (&#114;&#97;&#121;&#64;&#99;&#97;&#109;&#100;&#101;&#110;&#102;&#97;&#109;&#105;&#108;&#121;&#46;&#99;&#111;&#109;) 
 @version 2, April 8, 2004 
--->
<cffunction name="directoryList" output="false" returnType="query">
	<cfargument name="directory" type="string" required="true">
	<cfargument name="filter" type="string" required="false" default="">
	<cfargument name="sort" type="string" required="false" default="">
	<cfargument name="recurse" type="boolean" required="false" default="false">
	<!--- temp vars --->
	<cfargument name="dirInfo" type="query" required="false">
	<cfargument name="thisDir" type="query" required="false">
	<cfset var path="">
    <cfset var temp="">
	
	<cfif not recurse>
		<cfdirectory name="temp" directory="#directory#" filter="#filter#" sort="#sort#">
		<cfreturn temp>
	<cfelse>
		<!--- We loop through until done recursing drive --->
		<cfif not isDefined("dirInfo")>
			<cfset dirInfo = queryNew("attributes,datelastmodified,mode,name,size,type,directory")>
		</cfif>
		<cfset thisDir = directoryList(directory,filter,sort,false)>
		<cfif server.os.name contains "Windows">
			<cfset path = "\">
		<cfelse>
			<cfset path = "/">
		</cfif>
		<cfloop query="thisDir">
			<cfset queryAddRow(dirInfo)>
			<cfset querySetCell(dirInfo,"attributes",attributes)>
			<cfset querySetCell(dirInfo,"datelastmodified",datelastmodified)>
			<cfset querySetCell(dirInfo,"mode",mode)>
			<cfset querySetCell(dirInfo,"name",name)>
			<cfset querySetCell(dirInfo,"size",size)>
			<cfset querySetCell(dirInfo,"type",type)>
			<cfset querySetCell(dirInfo,"directory",directory)>
			<cfif type is "dir">
				<!--- go deep! --->
				<cfset directoryList(directory & path & name,filter,sort,true,dirInfo)>
			</cfif>
		</cfloop>
		<cfreturn dirInfo>
	</cfif>
</cffunction>

<!---
 Mimics the cfdirectory, action=&quot;rename&quot; command.
 
 @param directory 	 Directory to rename. (Required)
 @param newDirectory 	 New name for directory. (Required)
 @return Does not return a value. 
 @author Raymond Camden (&#114;&#97;&#121;&#64;&#99;&#97;&#109;&#100;&#101;&#110;&#102;&#97;&#109;&#105;&#108;&#121;&#46;&#99;&#111;&#109;) 
 @version 1, October 15, 2002 
--->
<cffunction name="directoryRename" output="false" returnType="void">
	<cfargument name="directory" type="string" required="true">
	<cfargument name="newDirectory" type="string" required="true">
	<cfdirectory action="rename" directory="#directory#" newDirectory="#newDirectory#">
</cffunction>

<!---
 Mimics the cfdump tag.
 Updated for final cfmx var scope - also, we only redo var if size bigger than top.
 
 @param var 	 The variable to dump. (Required)
 @param expand 	 Expand output. Defaults to true. (Optional)
 @param label 	 Label for dump. (Optional)
 @param top 	 Restricts output based on type. If array or query, top will represent the number of rows to show. If structure, will show this many keys. (Optional)
 @return Returns a string. 
 @author Raymond Camden (&#114;&#97;&#121;&#64;&#99;&#97;&#109;&#100;&#101;&#110;&#102;&#97;&#109;&#105;&#108;&#121;&#46;&#99;&#111;&#109;) 
 @version 2, October 16, 2002 
--->
<cffunction name="dump" returnType="string">
	<cfargument name="var" type="any" required="true">
	<cfargument name="expand" type="boolean" required="false" default="true">
	<cfargument name="label" type="string" required="false" default="">
	<cfargument name="top" type="numeric" required="false">
	
	<!--- var --->
    <cfset var type = "">
    <cfset var tempArray = arrayNew(1)>
    <cfset var temp_x = 1>
    <cfset var tempStruct = structNew()>
	<cfset var orderedKeys = "">
	<cfset var tempQuery = queryNew("")>
	<cfset var col = "">
	
	<!--- do filtering if top ---->
	<cfif isDefined("top")>
	
		<cfif isArray(var)>
			<cfset type = "array">
		</cfif>
		<cfif isStruct(var)>
			<cfset type="struct">
		</cfif>
		<cfif isQuery(var)>
			<cfset type="query">
		</cfif>
		
		<cfswitch expression="#type#">
		
			<cfcase value="array">
				<cfif arrayLen(var) gt top>
					<cfloop index="temp_x" from=1 to="#Min(arrayLen(var),top)#">
						<cfset tempArray[temp_x] = var[temp_x]>
					</cfloop>
					<cfset var = tempArray>
				</cfif>
			</cfcase>
			
			<cfcase value="struct">
				<cfif listLen(structKeyList(var)) gt top>
					<cfset orderedKeys = listSort(structKeyList(var),"text")>
					<cfloop index="temp_x" from=1 to="#Min(listLen(orderedKeys),top)#">
						<cfset tempStruct[listGetAt(orderedKeys,temp_x)] = var[listGetAt(orderedKeys,temp_x)]>
					</cfloop>
					<cfset var = tempStruct>
				</cfif>
			</cfcase>
			
			<cfcase value="query">
				<cfif var.recordCount gt top>
					<cfset tempQuery = queryNew(var.columnList)>
					<cfloop index="temp_x" from=1 to="#min(var.recordCount,top)#">
						<cfset queryAddRow(tempQuery)>
						<cfloop index="col" list="#var.columnList#">
							<cfset querySetCell(tempQuery,col,var[col][temp_x])>
						</cfloop>
					</cfloop>
					<cfset var = tempQuery>
				</cfif>
			</cfcase>
			
		</cfswitch>
		
	</cfif>
	
	<cfdump var="#var#" expand="#expand#" label="#label#">
</cffunction>

<!---
 Mimics the cfexecute tag.
 Updated for CFMX var scope.
 
 @param name 	 Program to execute. (Required)
 @param args 	 Args to pass. Can be string or array. (Optional)
 @param timeout 	 Time to wait for program execution. (Optional)
 @param outputFile 	 File to save results. (Optional)
 @return Returns a string. 
 @author Raymond Camden (&#114;&#97;&#121;&#64;&#99;&#97;&#109;&#100;&#101;&#110;&#102;&#97;&#109;&#105;&#108;&#121;&#46;&#99;&#111;&#109;) 
 @version 1, October 16, 2002 
--->
<cffunction name="execute" output="false" returnType="string">
	<cfargument name="name" type="string" required="true">
	<cfargument name="args" type="any" required="false" default="">
	<cfargument name="timeout" type="string" required="false" default="0">
	<cfargument name="outputfile" type="string" required="false" default="">

	<cfset var result = "">
	
	<cfsavecontent variable="result">
		<cfif len(outputFile)>
			<cfexecute name="#name#" arguments="#args#" timeout="#timeout#" outputfile="#outputfile#"/>
		<cfelse>
			<cfexecute name="#name#" arguments="#args#" timeout="#timeout#"/>
		</cfif>
	</cfsavecontent>
	<cfreturn result>
</cffunction>

<!---
 Mimics the cffile, action=&quot;append&quot; command.
 
 @param file 	 The file to append. (Required)
 @param output 	 The data to append. (Required)
 @param mode 	 Defines permissions for a file on non-Windows systems. (Optional)
 @param addNewLine 	 If true, a new line character is added to output. (Optional)
 @param attributes 	 File attributes. (Optional)
 @return Does not return a value. 
 @author Raymond Camden (&#114;&#97;&#121;&#64;&#99;&#97;&#109;&#100;&#101;&#110;&#102;&#97;&#109;&#105;&#108;&#121;&#46;&#99;&#111;&#109;) 
 @version 1, October 15, 2002 
--->
<cffunction name="fileAppend" output="false" returnType="void">
	<cfargument name="file" type="string" required="true">
	<cfargument name="output" type="string" required="true">
	<cfargument name="mode" type="string" default="" required="false">
	<cfargument name="addNewLine" type="boolean" default="yes" required="false">
	<cfargument name="attributes" type="string" default="" required="false">
	<cfif mode is "">
		<cffile action="append" file="#file#" output="#output#" addNewLine="#addNewLine#" attributes="#attributes#">	
	<cfelse>
		<cffile action="append" file="#file#" output="#output#" mode="#mode#" addNewLine="#addNewLine#" attributes="#attributes#">	
	</cfif>
</cffunction>


<!---
 Returns information about a file.
 Updated for CMFX var scope.
 
 @param fileName 	 File to inspect. (Required)
 @return Returns a query. 
 @author Raymond Camden (&#114;&#97;&#121;&#64;&#99;&#97;&#109;&#100;&#101;&#110;&#102;&#97;&#109;&#105;&#108;&#121;&#46;&#99;&#111;&#109;) 
 @version 1, October 15, 2002 
--->
<cffunction name="fileInfo" output="false" returntype="query">
	<cfargument name="fileName" type="string" required="true">

	<cfset var directory = "">
	<cfset var getFile = queryNew("")>
	
	<cfif not fileExists(fileName)>
		<cfthrow message="fileInfo error: #fileName# does not exist.">
	</cfif>
	<cfset directory = getDirectoryFromPath(fileName)>
	<cfdirectory name="getFile" directory="#directory#" filter="#getFileFromPath(fileName)#">
	<cfreturn getFile>
</cffunction>



<!---
 Mimics the CFFLUSH tag and sends all content to the screen.
 Version 2 by RCamden (&#114;&#97;&#121;&#64;&#99;&#97;&#109;&#100;&#101;&#110;&#102;&#97;&#109;&#105;&#108;&#121;&#46;&#99;&#111;&#109;)
 
 @param interval 	 Flushes output each time this number of bytes becomes available. (Required)
 @return Returns nothing. 
 @author Eric C. Davis (&#114;&#97;&#121;&#64;&#99;&#97;&#109;&#100;&#101;&#110;&#102;&#97;&#109;&#105;&#108;&#121;&#46;&#99;&#111;&#109;&#99;&#102;&#108;&#105;&#98;&#64;&#49;&#48;&#109;&#97;&#114;&#50;&#48;&#48;&#49;&#46;&#99;&#111;&#109;) 
 @version 2, April 22, 2003 
--->
<cffunction name="flush" returnType="void">
	<cfargument name="interval"  type="numeric" required="false">
	<cfif isDefined("interval")>
		<cfflush interval="#interval#">
	<cfelse>
		<cfflush>
	</cfif>
</cffunction>

<!---
 Mimics the CFHTMLHEAD tag.
 
 @param text 	 Text to insert. (Required)
 @return Does not return a value. 
 @author Kreig Zimmerman (&#107;&#107;&#122;&#64;&#102;&#111;&#117;&#114;&#101;&#121;&#101;&#115;&#46;&#99;&#111;&#109;) 
 @version 1, October 15, 2002 
--->
<cffunction name="HTMLHead" output="false" returnType="void">
	<cfargument name="text" type="string" required="yes">
	<cfhtmlhead text="#text#">
</cffunction>

<!---
 Mimics the CFHEADER tag.
 
 @param name 	 Name used when passing name/value pairs. (Optional)
 @param value 	 Value used when passing name/value pairs. (Optional)
 @param statuscode 	 Status code used when passing statuscode/statustext pairs. (Optional)
 @param statustext 	 Status text used when passing statuscode/statustext pairs. (Optional)
 @return Returns nothing. 
 @author Kreig Zimmerman (&#107;&#107;&#122;&#64;&#102;&#111;&#117;&#114;&#101;&#121;&#101;&#115;&#46;&#99;&#111;&#109;) 
 @version 1, September 20, 2002 
--->
<cffunction name="HTTPHeader" output="false" returnType="void">
	<cfargument name="name" type="string" default="">
	<cfargument name="value" type="string" default="">
	<cfargument name="statuscode" type="string" default="">
	<cfargument name="statustext" type="string" default="">
	<cfif Len(name) and Len(value)>
		<cfheader name="#name#" value="#value#">
	<cfelseif Len(statuscode) and Len(statustext)>
		<cfheader statuscode="#statuscode#" statustext="#statustext#">
	</cfif>
</cffunction>

<!---
 Mimics the cfinclude tag.
 Changed output to true so the included doc could display something.
 
 @param template 	 The template to include. (Required)
 @return Does not return a value. 
 @author Raymond Camden (&#114;&#97;&#121;&#64;&#99;&#97;&#109;&#100;&#101;&#110;&#102;&#97;&#109;&#105;&#108;&#121;&#46;&#99;&#111;&#109;) 
 @version 2, August 3, 2005 
--->
<cffunction name="include" output="true" returnType="void">
	<cfargument name="template" type="string" required="true">
	<cfinclude template="#template#">
</cffunction>

<!---
 Mimics the cflocation tag.
 
 @param url 	 URL to cflocate to. (Required)
 @param addToken 	 Specifies wether CFTOKEN info should be appended. Defaults to true. (Optional)
 @return Does not return a value. 
 @author Raymond Camden (&#114;&#97;&#121;&#64;&#99;&#97;&#109;&#100;&#101;&#110;&#102;&#97;&#109;&#105;&#108;&#121;&#46;&#99;&#111;&#109;) 
 @version 1, October 15, 2002 
--->
<cffunction name="location" output="false" returnType="void">
	<cfargument name="url" type="string" required="true">
	<cfargument name="addToken" type="boolean" default="true" required="false">
	<cflocation url="#url#" addToken="#addToken#">
</cffunction>

<!---
 Mimics the CFTHROW tag.
 
 @param Type 	 Type for exception. (Optional)
 @param Message 	 Message for exception. (Optional)
 @param Detail 	 Detail for exception. (Optional)
 @param ErrorCode 	 Error code for exception. (Optional)
 @param ExtendedInfo 	 Extended Information for exception. (Optional)
 @param Object 	 Object to throw. (Optional)
 @return Does not return a value. 
 @author Raymond Camden (&#114;&#97;&#121;&#64;&#99;&#97;&#109;&#100;&#101;&#110;&#102;&#97;&#109;&#105;&#108;&#121;&#46;&#99;&#111;&#109;) 
 @version 1, October 15, 2002 
--->
<cffunction name="throw" output="false" returnType="void" hint="CFML Throw wrapper">
	<cfargument name="type" type="string" required="false" default="Application" hint="Type for Exception">
	<cfargument name="message" type="string" required="false" default="" hint="Message for Exception">
	<cfargument name="detail" type="string" required="false" default="" hint="Detail for Exception">
	<cfargument name="errorCode" type="string" required="false" default="" hint="Error Code for Exception">
	<cfargument name="extendedInfo" type="string" required="false" default="" hint="Extended Info for Exception">
	<cfargument name="object" type="any" hint="Object for Exception">
	
	<cfif not isDefined("object")>
		<cfthrow type="#type#" message="#message#" detail="#detail#" errorCode="#errorCode#" extendedInfo="#extendedInfo#">
	<cfelse>
		<cfthrow object="#object#">
	</cfif>
	
</cffunction>

<!---
 Allows for deserialization of WDDX data.
 Updated for CFMX var syntax.
 
 @param input 	 A valid WDDX string. (Required)
 @return Returns deserialized data. 
 @author Raymond Camden (&#114;&#97;&#121;&#64;&#99;&#97;&#109;&#100;&#101;&#110;&#102;&#97;&#109;&#105;&#108;&#121;&#46;&#99;&#111;&#109;) 
 @version 2, October 16, 2002 
--->
<cffunction name="wddxDeserialize" output="false" returnType="any">
	<cfargument name="input" type="string" required="true">

	<cfset var output="">
	
	<cfwddx action="wddx2cfml" input="#input#" output="output">
	<cfreturn output>
</cffunction>

<!---
 Reads a file containing WDDX and returns the CF variable.
 Updated for CFMX var scope syntax.
 
 @param file 	 File to read and deserialize. (Required)
 @return Returns deserialized data. 
 @author Nathan Dintenfass (&#110;&#97;&#116;&#104;&#97;&#110;&#64;&#99;&#104;&#97;&#110;&#103;&#101;&#109;&#101;&#100;&#105;&#97;&#46;&#99;&#111;&#109;) 
 @version 2, October 15, 2002 
--->
<cffunction name="WDDXFileRead" output="no">
	<cfargument name="file" required="yes">
	
	<cfset var tempPacket = "">
	<cfset var tempVar = "">
	
	<!--- make sure the file exists, otherwise, throw an error --->
	<cfif NOT fileExists(file)>
		<cfthrow message="WDDXFileRead() error: File Does Not Exist" detail="The file #file# called in WDDXFileRead() does not exist">
	</cfif>
	<!--- read the file --->
	<cffile action="read" file="#file#" variable="tempPacket">
	<!--- make sure it is a valid WDDX Packet --->
	<cfif NOT isWDDX(tempPacket)>
		<cfthrow message="WDDXFileRead() error: Bad Packet" detail="The file #file# called in WDDXFileRead() does not contain a valid WDDX packet">		
	</cfif>
	<!--- deserialize --->
	<cfwddx action="wddx2cfml" input="#tempPacket#" output="tempVar">
	<cfreturn tempVar>    
</cffunction>

<!---
 Write a flat file containing a WDDX packet of any CF variable
 Updated for CFMX var scope syntax.
 
 @param file 	 The file to write to. (Required)
 @param var 	 The value to serialize. (Required)
 @return Does not return a value. 
 @author Nathan Dintenfass (&#110;&#97;&#116;&#104;&#97;&#110;&#64;&#99;&#104;&#97;&#110;&#103;&#101;&#109;&#101;&#100;&#105;&#97;&#46;&#99;&#111;&#109;) 
 @version 2, October 15, 2002 
--->
<cffunction name="WDDXFileWrite" output="no" returnType="void">
	<cfargument name="file" required="yes">
	<cfargument name="var" required="yes">
	
	<cfset var tempPacket = "">
	
	<!--- serialize --->
	<cfwddx action="cfml2wddx" input="#var#" output="tempPacket">
	<!--- write the file --->
	<cffile action="write" file="#file#" output="#tempPacket#">
</cffunction>

<!---
 Allows for serialization to WDDX.
 Updated for CFMX var scope syntax.
 
 @param input 	 The value to serialize. (Required)
 @param useTimeZoneInfo 	 Indicates whether to output time-zone information when serializing CFML to WDDX. The default is yes. (Optional)
 @return Returns a WDDX packet. 
 @author Raymond Camden (&#114;&#97;&#121;&#64;&#99;&#97;&#109;&#100;&#101;&#110;&#102;&#97;&#109;&#105;&#108;&#121;&#46;&#99;&#111;&#109;) 
 @version 2, October 16, 2002 
--->
<cffunction name="wddxSerialize" output="false" returnType="string">
	<cfargument name="input" type="any" required="true">
	<cfargument name="useTimeZoneInfo" type="boolean" required="false" default="true">
	
	<cfset var output="">
	
	<cfwddx action="cfml2wddx" input="#input#" output="output" useTimeZoneInfo="#useTimeZoneInfo#">
	<cfreturn output>
</cffunction>
