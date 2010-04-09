<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<cfsilent>
<!--- 
filename:		cfMgmtDemos/cfUniForm/demos/globalConfigCode.cfm
date created:	11/12/2008
author:			Matt Quackenbush (http://www.quackfuzed.com)
purpose:		I display the code for the 'Global Config Demo'
				
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

</cfsilent>

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-us" lang="en-us">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="/demos/assets/css/demostyles.css" type="text/css" rel="stylesheet" media="all" />
	<title>cfUniForm - Global Config Demo - The Code</title>
</head>

<body>

<p>
	This page shows you the code used to generate the form 
	on the <a href="globalConfig.cfm">global config demo page</a>.
</p>
<ul>
	<li><a href="index.cfm">Back to the cfUniForm demo home</a></li>
	<li><a href="http://cfuniform.riaforge.org/">Download cfUniForm from RIAForge.org</a></li>
	<li><a href="http://www.quackfuzed.com/index.cfm/UniForm-Tag-Library">View my blog</a></li>
</ul>

<hr />

<cfoutput>
#htmlCodeFormat(replace('
<!--- 
	This is an example of declaring the config struct in CFML.
 --->
<cfscript>
	cfUniFormConfig = structNew();
	// use the ''pathConfig'' key to create a struct of pathConfigs for altering file paths
	cfUniFormConfig.pathConfig = structNew();
	cfUniFormConfig.pathConfig.dateJS = "../assets/scripts/jquery.datepick-3.7.5.min.js";
	
	// example of providing load instructions via a global config object
	cfUniFormConfig.loadjQuery = true;
	cfUniFormConfig.loadDateUI = true;
	cfUniFormConfig.loadTimeUI = true;
	cfUniFormConfig.loadTextareaResize = true;
	
	// example of providing dateSetup via a global config object
	cfUniFormConfig.dateSetup = structNew();
	cfUniFormConfig.dateSetup[''yearRange''] = "''##year(now())##:##year(dateAdd(''yyyy'', 1, now()))##''";
	cfUniFormConfig.dateSetup[''changeYear''] = false;
	
	// example of providing timeSetup via a global config object
	cfUniFormConfig.timeSetup = structNew();
	cfUniFormConfig.timeSetup[''separator''] = "''=''";
	cfUniFormConfig.timeSetup[''spinnerImage''] = "''/commonassets/images/timeEntry/spinnerGem.png''";
	
	// example of providing textareaSetup via a global config object
	cfUniFormConfig.textareaSetup = structNew();
	cfUniFormConfig.textareaSetup[''maxHeight''] = 800;
	cfUniFormConfig.textareaSetup[''animate''] = true;
	cfUniFormConfig.textareaSetup[''animationSpeed''] = "''slow''";
</cfscript>

<!--- 
	This is an example of declaring the global config struct in a cfUniFormConfig bean within ColdSpring.
 --->
<bean id="cfUniFormConfig" class="coldspring.beans.factory.config.MapFactoryBean">
	<property name="SourceMap">
		<map>
			<entry key="pathConfig">
				<map>
					<entry key="jQuery"><value>path/to/jquery.js</value></entry>
					<entry key="renderer"><value>path/to/renderValidationErrors.cfm</value></entry>
					<entry key="uniformCSS"><value>path/to/uni-form-styles.css</value></entry>
					<entry key="uniformJS"><value>path/to/uni-form.jquery.js</value></entry>
					<entry key="validationJS"><value>path/to/jquery.validate.js</value></entry>
					<entry key="dateCSS"><value>path/to/jquery.datepick.css</value></entry>
					<entry key="dateJS"><value>path/to/jquery.datepick.js</value></entry>
					<entry key="timeCSS"><value>path/to/timeplugin/jquery.timeentry.css</value></entry>
					<entry key="timeJS"><value>path/to/jquery.timeentry.js</value></entry>
					<entry key="maskJS"><value>path/to/jquery.maskedinput.js</value></entry>
					<entry key="textareaJS"><value>path/to/jquery.prettyComments.js</value></entry>
					<entry key="ratingCSS"><value>path/to/jquery.rating.css</value></entry>
					<entry key="ratingJS"><value>path/to/jquery.rating.js</value></entry>
				</map>
			</entry>
			<entry key="dateSetup">
				<map>
					<entry key="buttonImage"><value>''path/to/calendar.gif''</value></entry>
				</map>
			</entry>
			<entry key="textareaSetup">
				<map>
					<entry key="maxHeight"><value>800</value></entry>
				</map>
			</entry>
			<entry key="timeSetup">
				<map>
					<entry key="show24Hours"><value>true</value></entry>
					<entry key="showSeconds"><value>false</value></entry>
					<entry key="spinnerImage"><value>''path/to/spinner/image.png''</value></entry>
				</map>
			</entry>
		</map>
	</property>
</bean>

<!--- build the form --->
<div id="wrap">
	<div class="cfUniForm-form-container">
		<!--- 
			The opening tag demonstrates how to utilize attributeCollection to pass in our global 
			cfUniFormConfig object (struct).
			
			We are also taking advantage of ColdFusion''s handling of attributeCollection keys vs. explicitly declared
			keys.  What do I mean by that?  Well, if you have a key in the struct that is passed via attributeCollection 
			but also explicitly provide that same key, ColdFusion will automatically use the value provided by 
			the explicit key instead.  This allows us to provide a global config, and yet still override it at
			the form level!  This is demonstrated here by explicitly providing the ''dateSetup'' key, even though
			it exists in the attributeCollection.  Note that the cfUniFormConfig struct''s dateSetup sets the yearRange
			to year(now()) [2010] through year(now()+2) [2012].  However, we''ve explicitly provided a range of 2000-2005
			via the ''dateSetup'' key.  ColdFusion gives precedence to the explicit declaration, and the form contains the 
			latter setup.
		 --->
		<uform:form action="##cgi.script_name##"
					id="myDemoForm"
					submitValue=" Add Task "
					attributeCollection="##cfUniFormConfig##"
					dateSetup="{yearRange:''2000:2005''}">
			
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
							pluginSetup="{buttonImage:''../assets/images/calendar.gif''}" />
				
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
							pluginSetup="{show24Hours:false,separator:'':'',
										spinnerImage:''/commonassets/images/timeentry/spinnerGreen.png'',
										spinnerBigImage:''/commonassets/images/timeentry/spinnerGreenBig.png''}" />
				
				<uform:field label="Detailed Description"
							name="description"
							isRequired="true"
							type="textarea"
							value="##form.description##"
							hint="Enter a detailed description of the task (e.g. directions to the cleaners)." />
			</uform:fieldset>
		</uform:form>
	</div>
</div>
' ,chr(9), " ", "all"))#
</cfoutput>

<hr />

<ul>
	<li><a href="globalConfig.cfm">View the "Global Config" demo form</a></li>
	<li><a href="index.cfm">Back to the cfUniForm demo home</a></li>
	<li><a href="http://cfuniform.riaforge.org/">Download cfUniForm from RIAForge.org</a></li>
	<li><a href="http://www.quackfuzed.com/index.cfm/UniForm-Tag-Library">View my blog</a></li>
</ul>

</body>
</html>

