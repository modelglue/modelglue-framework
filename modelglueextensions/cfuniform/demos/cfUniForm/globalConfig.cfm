<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<cfsilent>
<!--- 
filename:		cfUniForm/demos/globalConfig.cfm
date created:	11/12/2008
author:			Matt Quackenbush (http://www.quackfuzed.com)
purpose:		I demonstrate the use of a global config struct with the cfUniForm tag library
				
	// **************************************** LICENSE INFO **************************************** \\
	
	Copyright 2008, Matt Quackenbush
	
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
	11/12/2008		New																				MQ
	
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
<cfparam name="form.description" type="string" default="" />

<cfscript>
	cfUniFormConfig = structNew();
	// use the 'pathConfig' key to create a struct of pathConfigs for altering file paths
	cfUniFormConfig.pathConfig = structNew();
	cfUniFormConfig.pathConfig.dateJS = "../assets/scripts/this.here.datepick.is.for.demo.only.js";
	
	// example of providing load instructions via a global config object
	cfUniFormConfig.loadjQuery = true;
	cfUniFormConfig.loadDateUI = true;
	cfUniFormConfig.loadTimeUI = true;
	cfUniFormConfig.loadTextareaResize = true;
	
	// example of providing dateSetup via a global config object
	cfUniFormConfig.dateSetup = structNew();
	cfUniFormConfig.dateSetup['yearRange'] = "'#year(now())#:#year(dateAdd('yyyy', 1, now()))#'";
	cfUniFormConfig.dateSetup['changeYear'] = false;
	
	// example of providing timeSetup via a global config object
	cfUniFormConfig.timeSetup = structNew();
	cfUniFormConfig.timeSetup['separator'] = "'='";
	cfUniFormConfig.timeSetup['spinnerImage'] = "'/commonassets/images/timeEntry/spinnerGem.png'";
	
	// example of providing textareaSetup via a global config object
	cfUniFormConfig.textareaSetup = structNew();
	cfUniFormConfig.textareaSetup['maxHeight'] = 800;
	cfUniFormConfig.textareaSetup['animate'] = true;
	cfUniFormConfig.textareaSetup['animationSpeed'] = "'slow'";
</cfscript>
</cfsilent>

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-us" lang="en-us">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="/demos/assets/css/demostyles.css" type="text/css" rel="stylesheet" media="all" />
	<title>cfUniForm Global Config Demo</title>
</head>

<body>

<p>
	This page displays the "Global Config" demo form.
	You can create a GlobalConfig struct in CFML, or if you are utilizing a DI framework such as 
	ColdSpring, you can create your config inside of it.  (See the <a href="globalConfigCode.cfm">code page</a> for an example.)
</p>
<p>
	You can use keys matching <em>any <strong>valid</strong> attribute</em> on the form tag.  Then simply provide
	your config struct to the form via the attributeCollection, as shown below.
</p>
<code>
	&lt;uform:form attributeCollection="#cfUniFormConfig#"&gt;
</code>
<p>
	By utilizing the attributeCollection, we can take advantage of ColdFusion's handling of 
	attributeCollection keys vs. explicitly declared keys.  What do I mean by that?  Well, 
	if you have a key in the struct that is passed via attributeCollection but also explicitly 
	provide that same key, ColdFusion will automatically use the value provided by the explicit 
	key instead.  This allows us to provide a global config, and yet still override it at the 
	form level!
</p>
<p>
	We demonstrate this in the form on this page by explicitly providing the 'dateSetup' key, 
	even though it exists in the attributeCollection.  Note that the cfUniFormConfig struct's 
	dateSetup sets the yearRange to year(now()) [2010] through year(now()+2) [2012].
</p>	
<code>
	cfUniFormConfig.dateSetup['yearRange'] = "'#year(now())#:#year(dateAdd('yyyy', 1, now()))#'";
</code>
<p>
	However, since we've explicitly provided a range of 2000-2005 via the 'dateSetup' key...
</p>
<code>
	&lt;uform:form attributeCollection="#cfUniFormConfig#" dateSetup="{yearRange:'2000:2005'}"&gt;
</code>
<p>
	...ColdFusion gives precedence to the explicit declaration, and the form contains the latter 
	setup.  Thank you, CF!!
</p>
<p>
	  A few important notes:
</p>
<ul>
	<li>
		<p>
		For a full list of valid keys that you can pass to the attributeCollection, see the 
		comments at the top of the form.cfm template (/tags/forms/cfUniForm/form.cfm).
		</p>
	</li>
	<li>
		<p>
		One of the most common configuration changes made is to provide alternate paths to 
		the various CSS and JavaScript files.  These can be provided via the 'pathConfig' key, 
		which must be a struct.  Valid keys for the 'pathConfig' struct are as follows 
		(all keys are optional):
		</p>
		<ul>
			<li><strong>jQuery</strong> (path to jquery.js)</li>
			<li><strong>renderer</strong> (path to the renderValidationErrors.cfm custom tag)</li>
			<li><strong>uniformCSS</strong> (path to the uni-form-styles.css)</li>
			<li><strong>uniformJS</strong> (path to the uni-form.jquery.js)</li>
			<li><strong>validationJS</strong> (path to the jQuery validation js file)</li>
			<li><strong>dateCSS</strong> (path to jquery.datepick.css)</li>
			<li><strong>dateJS</strong> (path to jquery.datepick.js)</li>
			<li><strong>dateSetup</strong> (struct of var:value pairs to config the datepick plugin)</li>
			<li><strong>timeCSS</strong> (path to timeentry.css)</li>
			<li><strong>timeJS</strong> (path to timeentry.js)</li>
			<li><strong>timeSetup</strong> (struct of var:value pairs to config the timeentry plugin)</li>
			<li><strong>maskJS</strong> (path to maskedinput.js)</li>
			<li><strong>textareaJS</strong> (path to prettyComments.js)</li>
			<li><strong>textareaSetup</strong> (struct of var:value pairs to config the prettyComments plugin)</li>
			<li><strong>ratingCSS</strong> (path to jquery.rating.css)</li>
			<li><strong>ratingJS</strong> (path to jquery.rating.js)</li>
		</ul>
		<p>
		NOTE: Prior to cfUniForm v4.0 the key name for the 'pathConfig' struct was known as 'config'. The 
		'config' key <strong>has been deprecated in v4.0</strong>, and **will** be removed in a future version.  
		Please be sure to do a find/replace on all of your forms and replace calls to 'config' with calls to 'pathConfig'.
		</p>
	</li>
	<li>
		<p>
		JavaScript is cAsE-sEnSiTiVe.  Therefore, when creating config keys for your plugin setups, 
		you *must* utilize array notation.  If you don't, ColdFusion will automatically 
		render the key in UPPERCASE.  So, instead 
		of 
		</p>
		<p>
		&lt;cfset myStruct.dateSetup.yearRange = "'2008:2040'" /&gt;
		</p>
		<p>
		you would write it as 
		</p>
		<p>
		&lt;cfset myStruct.dateSetup['yearRange'] = "'2008:2040'" /&gt;
		</p>
	</li>
	<li>
		<p>
		Certain plugin setup rules require single quotes (e.g. strings).  Others require no quotes (e.g. true|false). 
		The <span class="bold">cfUniForm tags assume that you know what you're doing</span> and will output 
		<em>exactly</em> what you've written.  If the JavaScript breaks, it's likely because of quotes not being where 
		they should be, or vice-versa. 
		</p>
	</li>
	<li>
		<p>
		As noted above, even if you've supplied plugin setup rules in your GlobalConfig struct, you can still override them 
		on an individual form by utilizing the attributes provided on the form tag (e.g. @dateSetup or @timeSetup).  
		However, it is important to understand that the explicit key <em>overrides, or supercedes</em>, the attributeCollection 
		key.  It *does not* merge the two.
		</p>
		<p>
		So if you have a configuration setting in your global config struct (provided to attributeCollection) but do not have 
		that same key in the explicit config struct (provided to 'dateSetup'), it will be ignored.  No need to fret though, 
		it is quite easy to have the best of both worlds.  How?  Use structAppend() to merge your two structs into one and 
		don't bother with the explicit key!
		</p>
		<pre>
		<code>
	&lt;cfscript&gt;
		// declare your local (explicit) date setup
		myLocalDateSetup = structNew();
		myLocalDateSetup['yearRange'] = "'2000:2005'";
		
		// next, create a duplicate of our globals struct to hold the merged configs
		myMergedConfig = duplicate(cfUniFormConfig);
		/*
		* IMPORTANT! If you do not use duplicate() above, you will overwrite the
		* 'dateSetup' portion of your cfUniFormConfig struct when you do the 
		* structAppend() on the next line!
		*/
		
		// merge our local date setup into the date setup of our merged struct (overwrite=true)
		structAppend(myMergedConfig.dateSetup,myLocalDateSetup,true);
	&lt;/cfscript&gt;
	
	&lt;--- use our merged config struct instead of our global one (don't pass the explicit 'dateSetup') ---&gt;
	&lt;uform:form attributeCollection="#myMergedConfig#"&gt;
		</code>
		</pre>
		<p>
		In our demo form here, we're skipping the merging.  As a result you will see that because we did not declare 
		the 'changeYear' setting in our 'dateSetup' config string, the calendars will allow you to change years, even 
		though our global config struct has it set to false.  Give the merge a try and watch that option disappear! :-)
		</p>
	</li>
	<li>
		<p>
		You may also override plugin setups (e.g. date/time configuration) on an individual field by utilizing the 
		'pluginSetup' attribute on the field tag.  When utilizing the 'pluginSetup' attribute for date or time 
		configuration, the settings you provide are automatically merged (by the plugin) with any global settings 
		provided.
		</p>
	</li>
</ul>
<p>
	View the 
	<a href="globalConfigCode.cfm">code used to generate the form</a>.
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
			The opening tag demonstrates how to utilize attributeCollection to pass in our global 
			cfUniFormConfig object (struct).
			
			We are also taking advantage of ColdFusion's handling of attributeCollection keys vs. explicitly declared
			keys.  What do I mean by that?  Well, if you have a key in the struct that is passed via attributeCollection 
			but also explicitly provide that same key, ColdFusion will automatically use the value provided by 
			the explicit key instead.  This allows us to provide a global config, and yet still override it at
			the form level!  This is demonstrated here by explicitly providing the 'dateSetup' key, even though
			it exists in the attributeCollection.  Note that the cfUniFormConfig struct's dateSetup sets the yearRange
			to year(now()) [2010] through year(now()+2) [2012].  However, we've explicitly provided a range of 2000-2005
			via the 'dateSetup' key.  ColdFusion gives precedence to the explicit declaration, and the form contains the 
			latter setup.
		 --->
		<uform:form action="#cgi.script_name#"
					id="myDemoForm"
					submitValue=" Add Task "
					attributeCollection="#cfUniFormConfig#"
					dateSetup="{yearRange:'2000:2005'}">
			
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
							type="date" />
				
				<uform:field label="Start Time"
							name="startTime"
							isRequired="true"
							type="time" />
				
				<!--- 
					This is simply to demonstrate that you can have granular control over your individual datepicker fields.  
					Even though we have declared global rules in our config struct (config.dateSetup) and form-leve rules in 
					the dateSetup attribute, we can still override them all on an individual field if so desired by passing
					configs into the pluginSetup attribute.
				 --->
				<uform:field label="End Date"
							name="endDate"
							isRequired="true"
							type="date"
							pluginSetup="{showWeeks:false,buttonImage:'../assets/images/calendar.gif'}" />
				
				<!--- 
					This is simply to demonstrate that you can have granular control over your individual timeEntry fields.  
					Even though we have declared global rules in our config struct (config.timeSetup) and form-leve rules in 
					the timeSetup attribute, we can still override them all on an individual field if so desired by passing
					configs into the pluginSetup attribute.
				 --->
				<uform:field label="End Time"
							name="endTime"
							isRequired="true"
							type="time"
							pluginSetup="{show24Hours:false,separator:':',
										spinnerImage:'/commonassets/images/timeentry/spinnerGreen.png',
										spinnerBigImage:'/commonassets/images/timeentry/spinnerGreenBig.png'}" />
				
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
	<li><a href="globalConfigCode.cfm">View the code</a></li>
	<li><a href="index.cfm">Back to the cfUniForm demo home</a></li>
	<li><a href="http://cfuniform.riaforge.org/">Download cfUniForm from RIAForge.org</a></li>
	<li><a href="http://www.quackfuzed.com/index.cfm/UniForm-Tag-Library">View my blog</a></li>
</ul>

</body>
</html>
