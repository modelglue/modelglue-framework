<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<cfsilent>
<!--- 
filename:		cfMgmtDemos/cfUniForm/demos/errorsArrayCode.cfm
date created:	2/22/2009
author:			Matt Quackenbush (http://www.quackfuzed.com)
purpose:		I display the code for the 'Validation Errors Array Demo'
				
	// **************************************** LICENSE INFO **************************************** \\
	
	Copyright 2009, Matt Quackenbush
	
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
	2/22/2008		New																				MQ
	
 --->

</cfsilent>

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-us" lang="en-us">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="/demos/assets/css/demostyles.css" type="text/css" rel="stylesheet" media="all" />
	<title>cfUniForm - Validation Errors Array Demo - The Code</title>
</head>

<body>

<p>
	This page shows you the code used to generate the form 
	on the <a href="errorsArray.cfm">Validation Errors Array demo page</a>.
</p>
<ul>
	<li><a href="index.cfm">Back to the cfUniForm demo home</a></li>
	<li><a href="http://cfuniform.riaforge.org/">Download cfUniForm from RIAForge.org</a></li>
	<li><a href="http://www.quackfuzed.com/index.cfm/UniForm-Tag-Library">View my blog</a></li>
</ul>

<hr />

<cfoutput>
#htmlCodeFormat(replace('
<cfscript>
	// init an array to hold the errors
	errs = arrayNew(1);
	
	// create a struct for the Email property/field error and append it to the array
	st = {property="email",message="The Email Address is invalid."};
	arrayAppend(errs, st);
	
	// create a struct for the Password property/field error and append it to the array
	st = {property="password",message="The passwords do not match."};
	arrayAppend(errs, st);
</cfscript>
<div id="wrap">
	<div class="cfUniForm-form-container">
		<uform:form action="##cgi.script_name##" 
					id="myDemoForm" 
					cancelAction="index.cfm" 
					errors="##errs##" 
					errorMessagePlacement="both" 
					loadjQuery="true" 
					loadValidation="true">
			
			<uform:fieldset legend="Required Fields">
				<uform:field label="Email Address" 
							name="email" 
							isRequired="true" 
							type="text" 
							hint="Note: Your email is your username.  Use a valid email address." />
							
				<uform:field label="Re-enter Email Address" 
							name="email2" 
							isRequired="true" 
							type="text" 
							hint="Note: Please re-type your email." />
				
				<uform:field label="Choose Password" 
							name="password" 
							isRequired="true" 
							type="password" /><!--- for security purposes, we don''t populate the password --->
				
				<uform:field label="Re-enter Password" 
							name="password2" 
							isRequired="true" 
							type="password" /><!--- for security purposes, we don''t populate the password --->		
			</uform:fieldset>
		</uform:form>
	</div>
</div>
' ,chr(9), " ", "all"))#
</cfoutput>

<hr />

<ul>
	<li><a href="errorsArray.cfm">View the "Validation Errors Array" demo form</a></li>
	<li><a href="index.cfm">Back to the cfUniForm demo home</a></li>
	<li><a href="http://cfuniform.riaforge.org/">Download cfUniForm from RIAForge.org</a></li>
	<li><a href="http://www.quackfuzed.com/index.cfm/UniForm-Tag-Library">View my blog</a></li>
</ul>

</body>
</html>
