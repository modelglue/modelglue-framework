<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<cfsilent>
<!--- 
filename:		cfUniForm/demos/preLoaded.cfm
date created:	2/15/2010
author:			Matt Quackenbush (http://www.quackfuzed.com)
purpose:		I demonstrate the use of having the cfUniForm prerequisite files already loaded, and *NOT*
					having them loaded by cfUniForm
				
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
	2/15/2010		New																				MQ
	
 --->

<!--- 
	FOR MORE DETAILS ON USAGE, SEE MY BLOG AT http://www.quackfuzed.com/index.cfm/UniForm-Tag-Library
	
	YOU CAN ALSO VIEW THE 'use example' COMMENTS AT THE TOP OF EACH OF THE TAG FILES LOCATED IN THE 
	/tags/forms/cfUniForm/ DIRECTORY.
 --->

<!--- import the tag library --->
<cfimport taglib="/tags/forms/cfUniForm" prefix="uform" />

<!--- param our form variables --->
<cfparam name="form.task" type="string" default="" />
<cfparam name="form.startDate" type="string" default="" />
<cfparam name="form.startTime" type="string" default="" />
<cfparam name="form.endDate" type="string" default="" />
<cfparam name="form.endTime" type="string" default="" />
<cfparam name="form.zip" type="string" default="" />
<cfparam name="form.description" type="string" default="" />

</cfsilent>

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-us" lang="en-us">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="/demos/assets/css/demostyles.css" type="text/css" rel="stylesheet" media="all" />
	<link href="/commonassets/css/uni-form.css" type="text/css" rel="stylesheet" media="all" />
	<link href="/commonassets/css/datepick/jquery.datepick.css" rel="stylesheet" media="all" />
	<link href="/commonassets/css/jquery.timeentry.css" rel="stylesheet" media="all" />
	<!--[if lte ie 8]><link href="/commonassets/css/uni-form-ie.css" type="text/css" rel="stylesheet" media="all" /><![endif]-->
	<title>cfUniForm Pre-Loaded CSS/JS Demo</title>
</head>

<body>

<p>
	This page displays the "Pre-Loaded CSS/JS" demo form.  If you are building 
	an AJAX-powered "one-page application" - load a single page, and then load 
	all content on the page via AJAX - then the Pre-Loaded options are exactly 
	what you're looking for.  By using the following (optional) attributes, you 
	can seamlessly use cfUniForm-generated forms within your application.
</p>
<dl>
	<dt>loadDefaultCSS (boolean)</dt>
		<dd>Indicates whether or not to load the Uni-Form CSS files. Defaults to true.</dd>
	<dt>loadDefaultJS (boolean)</dt>
		<dd>Indicates whether or not to load the Uni-Form JS files. Defaults to true.</dd>
	<dt>loadDateUI (boolean)</dt>
		<dd>Indicates whether or not to load the prerequisite files for the jQuery UI datepicker plugin. Defaults to false.</dd>
	<dt>configDateUI (boolean)</dt>
		<dd>Indicates whether or not to run configuration routines for the jQuery UI datepicker plugin. Defaults to false.</dd>
	<dt>dateSetup (any)</dt>
		<dd>Commands to load for the jQuery datepick plugin. Can be provided as a string OR a struct.
			If it is a string, it will be loaded as-is. If it is a struct, it will be looped over and
			a string of key-value pairs will be created. Defaults to an empty string.</dd>
	<dt>loadTimeUI (boolean)</dt>
		<dd>Indicates whether or not to load the prerequisite files for the jQuery time entry plugin. Defaults to false.</dd>
	<dt>configTimeUI (boolean)</dt>
		<dd>Indicates whether or not to run configuration routines for the jQuery time entry plugin. Defaults to false.</dd>
	<dt>timeSetup (any)</dt>
		<dd>Commands to load for the jQuery time entry plugin. Can be provided as a string OR a struct.
			If it is a string, it will be loaded as-is. If it is a struct, it will be looped over and
			a string of key-value pairs will be created. Defaults to an empty string.</dd>
	<dt>loadMaskUI (boolean)</dt>
		<dd>Indicates whether or not to load the prerequisite files for the jQuery masked input plugin. Defaults to false.</dd>
	<dt>configMaskUI (boolean)</dt>
		<dd>Indicates whether or not to run configuration routines for the jQuery masked input plugin. Defaults to false.</dd>
	<dt>loadValidation (boolean)</dt>
		<dd>Indicates whether or not to load the prerequisite files for the jQuery form validation plugin. Defaults to false.</dd>
	<dt>configValidation (boolean)</dt>
		<dd>Indicates whether or not to run configuration routines for the jQuery form validation plugin. Defaults to false.</dd>
	<dt>validationSetup (any)</dt>
		<dd>Commands to load for the jQuery validation plugin. Can be provided as a string OR a struct.
			If it is a string, it will be loaded as-is. If it is a struct, it will be looped over and
			a string of key-value pairs will be created. Defaults to an empty string.</dd>
	<dt>loadRatingUI (boolean)</dt>
		<dd>Indicates whether or not to load the prerequisite files for the jQuery star-ratings plugin. Defaults to false.</dd>
	<dt>configRatingUI (boolean)</dt>
		<dd>Indicates whether or not to run configuration routines for the jQuery star-ratings plugin. Defaults to false.</dd>
	<dt>loadjQuery (boolean)</dt>
		<dd>Indicates whether or not to load the jQuery core library. Defaults to false.</dd>
	<dt>loadTextareaResize (boolean)</dt>
		<dd>Indicates whether or not to load the prerequisite files for the jQuery PrettyComments plugin. Defaults to false.</dd>
	<dt>configTextareaResize (boolean)</dt>
		<dd>Indicates whether or not to run configuration routines for the jQuery PrettyComments plugin. Defaults to false.</dd>
	<dt>addJStoHead (boolean)</dt>
		<dd>Indicates whether or not cfUniForm should add the JS to the &lt;head&gt; of the document. If 'false', it will be added 
			immediately after the form markup. Defaults to true.</dd>
	<dt>jsConfigVar (string)</dt>
		<dd>The name of the variable that should be used to return the jsConfig to the caller. If not provided, the 
			jsConfig will be added automatically. (Default behavior.) If provided, cfUniForm will set the variable 
			in the calling page.</dd>
	<dt>configForm (boolean)</dt>
		<dd>Indicates whether or not cfUniForm should call jQuery().uniform() on this specific form. Useful if you 
			have all of the assets already loaded and are loading the form into the page via ajax. Defaults to false.</dd>
</dl>
<p>
	You can provide any or all of these attributes explicitly, or you may use a <a href="globalConfig.cfm">global config struct</a> 
	to provide global settings.
</p>
<p>
	View the <a href="preLoadedCode.cfm">code used to generate the form</a>.
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
				1) have the tag library load jQuery and the following jQuery plugin prerequisites: 
					a) datepicker plugin
					b) timeentry plugin
					c) textarea resize plugin
				2) utilize the config attribute to load our global config struct.
		 --->
		<uform:form action="#cgi.script_name#"
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
							value="#form.task#" 
							hint="Enter a name to remember your task by (e.g. Pick up laundry)" />
				
				<uform:field label="Start Date"
							name="startDate"
							isRequired="true"
							type="date"
							value="#startDate#" />
				
				<uform:field label="Start Time"
							name="startTime"
							isRequired="true"
							type="time"
							value="#form.startTime#" />
				
				<uform:field label="End Date"
							name="endDate"
							isRequired="true"
							type="date"
							value="#endDate#" />
				
				<uform:field label="End Time"
							name="endTime"
							isRequired="true"
							type="time"
							value="#endTime#" />
				
				<uform:field label="Zip / Postal Code"
							name="zip"
							isRequired="true"
							type="text"
							value="#form.zip#"
							mask="99999?-9999" />
				
				<uform:field label="Detailed Description"
							name="description"
							isRequired="true"
							type="textarea"
							value="#form.description#"
							hint="Enter a detailed description of the task (e.g. directions to the cleaners)." />
			</uform:fieldset>
		</uform:form>
	</div>
</div>

<hr />

<ul>
	<li><a href="preLoadedCode.cfm">View the code</a></li>
	<li><a href="index.cfm">Back to the cfUniForm demo home</a></li>
	<li><a href="http://cfuniform.riaforge.org/">Download cfUniForm from RIAForge.org</a></li>
	<li><a href="http://www.quackfuzed.com/index.cfm/UniForm-Tag-Library">View my blog</a></li>
</ul>

	<script type="text/javascript" src="/commonassets/scripts/jQuery/jquery-1.3.2.min.js"></script>
	<script type="text/javascript" src="/commonassets/scripts/jQuery/forms/jquery.validate-1.6.0.min.js"></script>
	<script type="text/javascript" src="/commonassets/scripts/jQuery/forms/jquery.datepick-3.7.5.min.js"></script>
	<script type="text/javascript" src="/commonassets/scripts/jQuery/forms/jquery.timeentry-1.4.6.min.js"></script>
	<script type="text/javascript" src="/commonassets/scripts/jQuery/forms/jquery.maskedinput-1.2.2.min.js"></script>
	<script type="text/javascript" src="/commonassets/scripts/jQuery/forms/jquery.prettyComments-1.4.pack.js"></script>
	<script type="text/javascript" src="/commonassets/scripts/jQuery/forms/uni-form.jquery.js"></script>
		<cfoutput>#myJSconfig#</cfoutput>
</body>
</html>
