<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<cfsilent>
<!--- 
filename:		cfMgmtDemos/cfUniForm/demos/multipleUploadsCode.cfm
date created:	2/8/2010
author:			Matt Quackenbush (http://www.quackfuzed.com)
purpose:		I display the code for the 'Multiple Uploads Demo'
				
	// **************************************** LICENSE INFO **************************************** \\
	
	Copyright 2010, Matt Quackenbush
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
	// ****************************************** REVISIONS ****************************************** \\
	
	DATE		DESCRIPTION OF CHANGES MADE												CHANGES MADE BY
	===================================================================================================
	2/8/2010		New																				MQ
	
 --->

</cfsilent>

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-us" lang="en-us">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="/demos/assets/css/demostyles.css" type="text/css" rel="stylesheet" media="all" />
	<title>cfUniForm - Multiple Uploads Demo - The Code</title>
</head>

<body>

<p>
	This page shows you the code used to generate the form 
	on the <a href="multipleUploads.cfm">Multiple Uploads demo page</a>.
</p>
<ul>
	<li><a href="index.cfm">Back to the cfUniForm demo home</a></li>
	<li><a href="http://cfuniform.riaforge.org/">Download cfUniForm from RIAForge.org</a></li>
	<li><a href="http://www.quackfuzed.com/index.cfm/UniForm-Tag-Library">View my blog</a></li>
</ul>

<hr />

<cfoutput>
#htmlCodeFormat(replace('
<cfimport taglib="/tags/forms/cfUniForm" prefix="uform" />

<cfloop from="1" to="4" index="i">
	<cfif structKeyExists(form,"file" & i) AND len(trim(form["file" & i])) GT 0>
		<cfscript>
			filefield = "file" & i;
			uploadpath = getDirectoryFromPath(getCurrentTemplatePath());
		</cfscript>
		<cffile action="upload" filefield="##filefield##" destination="##uploadpath##" nameconflict="overwrite" />
	</cfif>
	
	<cfif structKeyExists(form,"anotherfile" & i) AND len(trim(form["anotherfile" & i])) GT 0>
		<cfscript>
			filefield = "anotherfile" & i;
			uploadpath = getDirectoryFromPath(getCurrentTemplatePath());
		</cfscript>
		<cffile action="upload" filefield="##filefield##" destination="##uploadpath##" nameconflict="overwrite" />
	</cfif>
</cfloop>
<div class="cfUniForm-form-container">
	<uform:form action="##cgi.script_name##"
				id="myDemoForm"
				submitValue=" Upload "
				loadjQuery="true"
				loadValidation="true">
	
		<p>
			This form utilizes cfUniForm''s native type="file" tag.
		</p>
		<uform:fieldset legend="Files to Upload" class="inlineLabels">
			<cfloop index="i" from="1" to="4" step="1">
				<cfset filename = "file" & i />
				<uform:field label="File ####i##"
							name="##filename##"
							isRequired="false"
							type="file" />
			</cfloop>
		</uform:fieldset>
		
	</uform:form>
</div>

<div class="cfUniForm-form-container">
	<uform:form action="##cgi.script_name##"
				id="myDemoForm"
				enctype="multipart/form-data"
				submitValue=" Upload "
				loadjQuery="true"
				loadValidation="true">
	
		<p>
			This form utilizes cfUniForm''s type="custom" tag in conjunction 
			with standard XHTML file fields.
		</p>
		<uform:fieldset legend="Files to Upload" class="inlineLabels">
			<uform:field type="custom">
				<cfoutput>
				<label for="anotherfile1">Upload File(s)</label>
				<cfloop index="i" from="1" to="4" step="1">
					<cfset filename = "file" & i />
					<cfif i GT 1>
						<label for="anotherfile##i##">&nbsp;</label>
					</cfif>
					<input name="anotherfile##i##" id="anotherfile##i##" size="35" type="file" class="fileUpload" />
				</cfloop>
				</cfoutput>
			</uform:field>
		</uform:fieldset>
		
	</uform:form>
</div>
' ,chr(9), " ", "all"))#
</cfoutput>

<hr />

<ul>
	<li><a href="multipleUploads.cfm">View the "Multiple Uploads" demo form</a></li>
	<li><a href="index.cfm">Back to the cfUniForm demo home</a></li>
	<li><a href="http://cfuniform.riaforge.org/">Download cfUniForm from RIAForge.org</a></li>
	<li><a href="http://www.quackfuzed.com/index.cfm/UniForm-Tag-Library">View my blog</a></li>
</ul>

</body>
</html>

