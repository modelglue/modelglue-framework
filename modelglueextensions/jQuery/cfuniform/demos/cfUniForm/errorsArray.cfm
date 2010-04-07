<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<cfsilent>
<!--- 
filename:		cfUniForm/demos/errorsArray.cfm
date created:	2/22/2009
author:			Matt Quackenbush (http://www.quackfuzed.com/)
purpose:		I demonstrate the use of an errors array with the cfUniForm tag library
				
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

<!--- 
	FOR MORE DETAILS ON USAGE, SEE MY BLOG AT http://www.quackfuzed.com/index.cfm/UniForm-Tag-Library
	
	YOU CAN ALSO VIEW THE 'use example' COMMENTS AT THE TOP OF EACH OF THE TAG FILES LOCATED IN THE 
	/tags/forms/cfUniForm/ DIRECTORY.
 --->

<!--- import the tag library --->
<cfimport taglib="/tags/forms/cfUniForm" prefix="uform" />

<cfscript>
	errs = arrayNew(1);
	st = {property="email",message="Please enter your Email Address."};
	arrayAppend(errs, st);
	st = {property="password",message="The passwords do not match."};
	arrayAppend(errs, st);
	st = {property="email",message="The Email Address is invalid."};
	arrayAppend(errs, st);
	
	errs2 = arrayNew(1);
	st = {field="email",message="Please enter your Email Address."};
	arrayAppend(errs2, st);
	st = {field="password",message="The passwords do not match."};
	arrayAppend(errs2, st);
	st = {field="email",message="The Email Address is invalid."};
	arrayAppend(errs2, st);
</cfscript>
</cfsilent>


<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-us" lang="en-us">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />	
	<link href="/demos/assets/css/demostyles.css" type="text/css" rel="stylesheet" media="all" />
	<title>cfUniForm Validation Errors Array Demo</title>
</head>

<body>

<p>
	This page demonstrates how to use an array of structs to provide server-side 
	validation errors to the form.  View the 
	<a href="errorsArrayCode.cfm">code used to generate the form</a>.
</p>
<ul>
	<li><a href="index.cfm">Back to the cfUniForm demo home</a></li>
	<li><a href="http://cfuniform.riaforge.org/">Download cfUniForm from RIAForge.org</a></li>
	<li><a href="http://www.quackfuzed.com/index.cfm/UniForm-Tag-Library">View my blog</a></li>
</ul>

<hr />

<div id="wrap">
	<h4>Choices, Choices</h4>
	<p>
		cfUniForm supports two conventions for building 
		your errors array.  Provide the name of the property that failed 
		validation in your choice of a 'property' key or a 'field' key.
	</p>
	<h4>The array of structs: Property Key</h4>
	<cfdump var="#errs#"><br />
	<h4>The array of structs: Field Key</h4>
	<cfdump var="#errs2#"><br />
	<p>
		Note that the two 'email' error messages are not in order.  However, 
		when the messages are displayed by cfUniForm, they are grouped by 
		field (property) name.  See the demo form below.
	</p>
	
	<h4>The Rendered Form:</h4>
	<div class="cfUniForm-form-container">
		<uform:form action="#cgi.script_name#"
					id="myDemoForm"
					errors="#errs#"
					errorMessagePlacement="both"
					loadjQuery="true"
					loadValidation="true">
			
			<uform:fieldset legend="Account Registration">
				<uform:field label="Email Address" 
							name="email" 
							isRequired="true" 
							type="text" 
							hint="Note: Please enter a valid email" />
							
				<uform:field label="Re-enter Email Address" 
							name="email2" 
							isRequired="true" 
							type="text" 
							hint="Note: Please re-type your email." />
				
				<uform:field label="Choose Password" 
							name="password" 
							isRequired="true" 
							type="password" /><!--- for security purposes, we don't populate the password --->
				
				<uform:field label="Re-enter Password" 
							name="password2" 
							isRequired="true" 
							type="password" /><!--- for security purposes, we don't populate the password --->
			
			</uform:fieldset>
		</uform:form>
	</div>
</div>

<hr />

<ul>
	<li><a href="errorsArrayCode.cfm">View the code</a></li>
	<li><a href="index.cfm">Back to the cfUniForm demo home</a></li>
	<li><a href="http://cfuniform.riaforge.org/">Download cfUniForm from RIAForge.org</a></li>
	<li><a href="http://www.quackfuzed.com/index.cfm/UniForm-Tag-Library">View my blog</a></li>
</ul>

</body>
</html>
