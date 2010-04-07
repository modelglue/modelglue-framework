<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<cfsilent>
<!--- 
filename:		cfMgmtDemos/cfUniForm/demos/preLoadedCode.cfm
date created:	2/23/2010
author:			Matt Quackenbush (http://www.quackfuzed.com)
purpose:		I display the code for the 'Pre-Loaded CSS/JS Demo'
				
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
	2/23/2010		New																				MQ
	
 --->

</cfsilent>

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-us" lang="en-us">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="/demos/assets/css/demostyles.css" type="text/css" rel="stylesheet" media="all" />
	<title>cfUniForm - Pre-Loaded CSS/JS Demo - The Code</title>
</head>

<body>

<p>
	This page shows you the code used to generate the form 
	on the <a href="preLoaded.cfm">Pre-Loaded CSS/JS demo page</a>.
</p>
<ul>
	<li><a href="index.cfm">Back to the cfUniForm demo home</a></li>
	<li><a href="http://cfuniform.riaforge.org/">Download cfUniForm from RIAForge.org</a></li>
	<li><a href="http://www.quackfuzed.com/index.cfm/UniForm-Tag-Library">View my blog</a></li>
</ul>

<hr />

<cfoutput>
#htmlCodeFormat(replace('
<head>
	<!--- 
		Here we are pre-loading all of our CSS files
	 --->
	<link href="/demos/assets/css/demostyles.css" type="text/css" rel="stylesheet" media="all" />
	<link href="/commonassets/css/uni-form.css" type="text/css" rel="stylesheet" media="all" />
	<link href="/commonassets/css/datepick/jquery.datepick.css" rel="stylesheet" media="all" />
	<link href="/commonassets/css/jquery.timeentry.css" rel="stylesheet" media="all" />
	<!--[if lte ie 8]><link href="/commonassets/css/uni-form-ie.css" type="text/css" rel="stylesheet" media="all" /><![endif]-->
</head>
<div class="cfUniForm-form-container">
	<!--- 
		The opening tag demonstrates optional attributes to do the following:
			1) tell cfUniForm **NOT** to load any CSS or JavaScript files
			2) tell cfUniForm to go ahead and configure the following UI components:
				a) Date
				b) Time
				c) Mask
				d) Validation
			3) provide a variable name that cfUniForm will return our JavaScript
				configuration to us in.
	 --->
	<uform:form action="##cgi.script_name##"
				id="myDemoForm"
				submitValue=" Add Task "
				loadDefaultCSS="false"
				loadDefaultJS="false"
				configValidation="true"
				configDateUI="true"
				configTimeUI="true"
				configMaskUI="true"
				jsConfigVar="myJSconfig">
		
		<uform:fieldset legend="Task Details">
			<uform:field label="Task Name" 
						name="task" 
						isRequired="true" 
						type="text" 
						value="##form.task##" 
						hint="Enter a name to remember your task by (e.g. Pick up laundry)" />
			
			<uform:field label="Start Date"
						name="startDate"
						isRequired="true"
						type="date"
						value="##startDate##" />
			
			<uform:field label="Start Time"
						name="startTime"
						isRequired="true"
						type="time"
						value="##form.startTime##" />
			
			<uform:field label="End Date"
						name="endDate"
						isRequired="true"
						type="date"
						value="##endDate##" />
			
			<uform:field label="End Time"
						name="endTime"
						isRequired="true"
						type="time"
						value="##endTime##" />
			
			<uform:field label="Zip / Postal Code"
						name="zip"
						isRequired="true"
						type="text"
						value="##form.zip##"
						mask="99999?-9999" />
			
			<uform:field label="Detailed Description"
						name="description"
						isRequired="true"
						type="textarea"
						value="##form.description##"
						hint="Enter a detailed description of the task (e.g. directions to the cleaners)." />
		</uform:fieldset>
	</uform:form>
</div>
<!--- 
	Here we are pre-loading all of our JavaScript files.
 --->
<script type="text/javascript" src="/commonassets/scripts/jQuery/jquery-1.3.2.min.js"></script>
<script type="text/javascript" src="/commonassets/scripts/jQuery/forms/jquery.validate-1.6.0.min.js"></script>
<script type="text/javascript" src="/commonassets/scripts/jQuery/forms/jquery.datepick-3.7.5.min.js"></script>
<script type="text/javascript" src="/commonassets/scripts/jQuery/forms/jquery.timeentry-1.4.6.min.js"></script>
<script type="text/javascript" src="/commonassets/scripts/jQuery/forms/jquery.maskedinput-1.2.2.min.js"></script>
<script type="text/javascript" src="/commonassets/scripts/jQuery/forms/jquery.prettyComments-1.4.pack.js"></script>
<script type="text/javascript" src="/commonassets/scripts/jQuery/forms/uni-form.jquery.js"></script>
<!--- 
	Here we are outputing the JavaScript configuration string returned by cfUniForm.
 --->
<cfoutput>##myJSconfig##</cfoutput>
' ,chr(9), " ", "all"))#
</cfoutput>

<hr />

<ul>
	<li><a href="preLoaded.cfm">View the "Pre-Loaded CSS/JS" demo form</a></li>
	<li><a href="index.cfm">Back to the cfUniForm demo home</a></li>
	<li><a href="http://cfuniform.riaforge.org/">Download cfUniForm from RIAForge.org</a></li>
	<li><a href="http://www.quackfuzed.com/index.cfm/UniForm-Tag-Library">View my blog</a></li>
</ul>

</body>
</html>

