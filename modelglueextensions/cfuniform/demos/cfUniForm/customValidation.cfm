<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<cfsilent>
<!--- 
filename:		cfUniForm/demos/customValidation.cfm
date created:	11/19/2008
author:			Michael Sammut (http://www.foureyes.com)
purpose:		I demonstrate the use of custom validation (for the jQuery validation plugin) with the cfUniForm tag library
				
	// **************************************** LICENSE INFO **************************************** \\
	
	Copyright 2008, Michael Sammut
	
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
	11/19/2008		New																				MS
	
 --->

<!--- 
	FOR MORE DETAILS ON USAGE, SEE MY BLOG AT http://www.quackfuzed.com/index.cfm/UniForm-Tag-Library
	
	YOU CAN ALSO VIEW THE 'use example' COMMENTS AT THE TOP OF EACH OF THE TAG FILES LOCATED IN THE 
	/tags/forms/cfUniForm/ DIRECTORY.
 --->

<!--- import the tag library --->
<cfimport taglib="/tags/forms/cfUniForm" prefix="uform" />

<cfsavecontent variable="customRules">
{
	rules: {
		email: {
			required: true,
			email: true
		},
		email2: {
			required: true,
			equalTo: "#email"
		},
		password: {
			required: true,
			minlength: 5
		},
		password2: {
			required: true,
			equalTo: "#password"
		}
	},
	messages: {
			email: {
			required: "Please provide an email"
		},
		email2: {
			required: "Please provide enter your email",
			equalTo: "Please enter the same email as above"
		},
		password: {
			required: "Please enter a password.  There is a 5 character minimum",
			minength: "You must enter 5 characters at minimum"
		},
		password2: {
			required: "Please enter a password",
			equalTo: "Please enter the same password as above"
		}
	}
}
</cfsavecontent>		 
</cfsilent>


<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-us" lang="en-us">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />	
	<link href="/demos/assets/css/demostyles.css" type="text/css" rel="stylesheet" media="all" />
	<title>cfUniForm Custom Validation Demo</title>
</head>

<body>

<p>
	This page displays the "Custom Validation" demo form.  View the 
	<a href="customValidationCode.cfm">code used to generate the form</a>.
</p>
<p>
	Thank you to Michael Sammut for providing the Custom Validation demo form and code.
</p>
<ul>
	<li><a href="index.cfm">Back to the cfUniForm demo home</a></li>
	<li><a href="http://cfuniform.riaforge.org/">Download cfUniForm from RIAForge.org</a></li>
	<li><a href="http://www.quackfuzed.com/index.cfm/UniForm-Tag-Library">View my blog</a></li>
</ul>

<hr />

<div id="wrap">
	<div class="cfUniForm-form-container">
		<!--- 
			The opening tag demonstrates optional attributes to do the following:
				1) determine where to place the error messages [valid options: top, inline, both, none]
				2) have the tag library load jQuery and the following jQuery plugin prerequisites: 
					a) validation plugin
					b) validationSetup (Load in custom validation.   cfUniform will accept any type of jQuery validation.  Please see example below)
		 --->
		<uform:form action="#cgi.script_name#" 
					id="myDemoForm" 
					cancelAction="index.cfm" 
					errorMessagePlacement="both" 
					submitValue=" Sign Me Up " 
					loadjQuery="true" 
					loadValidation="true" 
					loadMaskUI="true" 
					loadDateUI="true" 
					loadTimeUI="true" 
					loadTextareaResize="true" 
					validationSetup="#customRules#">
			
			<uform:fieldset legend="Required Fields">
				<input type="hidden" name="foo" value="1" />
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
	<li><a href="customValidationCode.cfm">View the code</a></li>
	<li><a href="index.cfm">Back to the cfUniForm demo home</a></li>
	<li><a href="http://cfuniform.riaforge.org/">Download cfUniForm from RIAForge.org</a></li>
	<li><a href="http://www.quackfuzed.com/index.cfm/UniForm-Tag-Library">View my blog</a></li>
</ul>

</body>
</html>
