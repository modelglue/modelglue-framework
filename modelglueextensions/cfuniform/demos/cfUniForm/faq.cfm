<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<cfsilent>
<!--- 
filename:		cfUniForm/demos/faq.cfm
date created:	2/22/2009
author:			Matt Quackenbush (http://www.quackfuzed.com)
purpose:		I display frequently asked questions for cfUniForm
				
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
	2/22/2009	New																					MQ
	
 --->

<!--- 
	FOR DETAILS ON USAGE, SEE MY BLOG AT http://www.quackfuzed.com/index.cfm/UniForm-Tag-Library
	
	YOU CAN ALSO VIEW THE 'use example' COMMENTS AT THE TOP OF EACH OF THE TAG FILES LOCATED IN THE 
	/tags/forms/cfUniForm/ DIRECTORY.
 --->

<!--- import the tag library --->
<cfimport taglib="/tags/forms/cfUniForm" prefix="uform" />
</cfsilent>


<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-us" lang="en-us">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />	
	<link href="/demos/assets/css/demostyles.css" type="text/css" rel="stylesheet" media="all" />
	<title>cfUniForm FAQ</title>
</head>

<body>

<p>
	Here is a list of Frequently Asked Questions regarding the cfUniForm tag library.
</p>
<ul>
	<li><a href="index.cfm">Back to the cfUniForm demo home</a></li>
	<li><a href="http://cfuniform.riaforge.org/">Download cfUniForm from RIAForge.org</a></li>
	<li><a href="http://www.quackfuzed.com/index.cfm/UniForm-Tag-Library">View my blog</a></li>
</ul>

<hr />

<div id="wrap">
	<ol>
		<li>
			<h4>Q. Does cfUniForm include a WYSIWYG editor?</h4>
			<p>
				No, it does not.  There are numerous WYSIWYG editors available for use, 
				and different people use different ones.  As such, the library does not 
				natively force the user into using any particular editor.
			</p>
			<p>
				However, cfUniForm certainly supports the use of a WYSIWYG editor.  Here's 
				an example of using FCKEditor with cfUniForm:
			</p>
<cfoutput>
#htmlCodeFormat(replace('
<div id="wrap">
	<div class="cfUniForm-form-container">
		<uform:form action="##cgi.script_name##" 
					id="myDemoForm">
				
				<uform:field type="custom">
					<label for="skillsInterests" class="blockLabels"><em>*</em> Skills and Interests</label>
					<cfmodule template="/fckeditor/fckeditor.cfm"
						basePath="/fckeditor/" 
						instanceName="skillsInterests" 
						value="##form.skillsInterests##" />
					<p class="formHint">
						Enter your skills and interests by terms separated with commas (E.g. computers, GTD, running). 
						Will be presented on your profile as a 
						<a href="http://en.wikipedia.org/wiki/Tag_cloud" 
							title="Definition of a tag cloud on Wikipedia">tag cloud</a>.
					</p>
				</uform:field>
			</uform:fieldset>
		</uform:form>
	</div>
</div>
' ,chr(9), " ", "all"))#
</cfoutput>
		</li>
		<li>
			<h4>Q. I can't get my &lt;cfform&gt;-based forms to work with cfUniForm.  What am I doing wrong?</h4>
			<p>
				You aren't doing anything wrong.  cfUniForm does not use or support 
				<code>&lt;cfform&gt;</code> or any of its associated tags.
			</p>
		</li>
		<li>
			<h4>Q. Does cfUniForm support the WYSIWYG editor included with CF8+?</h4>
			<p>
				No, it does not.  cfUniForm does not use <code>&lt;cfform&gt;</code>, 
				so therefore it does not support any of the <code>&lt;cfform&gt;</code> 
				related tags.
			</p>
		</li>
		<li>
			<h4>Q. Why does the 'Cancel' button submit the form?</h4>
			<p>
				cfUniForm was written with the intention of the developer doing with 
				(or without) the cancel button what he/she chooses to do. In my 
				applications I use it to redirect the request and/or perform other 
				operations (server-side) if it has been clicked. Something like so...
			</p>
<cfoutput>
#htmlCodeFormat(replace('
<cfif event.valueExists("cancel")>
	<!--- 
		process any cancel functions as required...
		redirect the request to the appropriate place
	 --->
</cfif>
' ,chr(9), " ", "all"))#
</cfoutput>
			<p>
				If you want to handle your cancel redirects client-side, you can 
				use the 'cancelAction' attribute to do this.  Just supply the URL 
				you wish to redirect to.  You can use a full URL (e.g. 
				http://www.domain.com/index.cfm) or just the file name (e.g. index.cfm).
			</p>
<cfoutput>
#htmlCodeFormat(replace('
<div id="wrap">
	<div class="cfUniForm-form-container">
		<uform:form action="##cgi.script_name##" 
					cancelAction="##_cancelURL##" 
					id="myDemoForm">
		</uform:form>
	</div>
</div>
' ,chr(9), " ", "all"))#
</cfoutput>
		</li>
		<li>
			<h4>Q. How can I add validation error messages to a custom field?</h4>
			<p>
				To add server-side validation error messages, simply use a 
				<code>&lt;cfif&gt;</code> statement to check for an error message 
				for the custom field.  If it exists, add a containerClass attribute 
				to add the error class, and then use the 
				<a href="http://sprawsm.com/uni-form/community/page/documentation">appropriate Uni-Form markup</a> 
				to display the message.
			</p>
<cfoutput>
#htmlCodeFormat(replace('
<uform:field type="custom" 
		containerClass="<cfif structKeyExists(errors, ''skillsInterests'')>error</cfif>">
<cfif structKeyExists(errors, "skillsInterests")>
	<p id="error-skillsInterests" class="errorField">
		Please enter your skills and interests.
	</p>
</cfif>
	<label for="skillsInterests" class="blockLabels"><em>*</em> Skills and Interests</label>
	<cfmodule template="/fckeditor/fckeditor.cfm"
		basePath="/fckeditor/" 
		instanceName="skillsInterests" 
		value="##form.skillsInterests##" />
	<p class="formHint">
		Enter your skills and interests by terms separated with commas (E.g. computers, GTD, running). 
		Will be presented on your profile as a 
		<a href="http://en.wikipedia.org/wiki/Tag_cloud" 
			title="Definition of a tag cloud on Wikipedia">tag cloud</a>.
	</p>
</uform:field>
' ,chr(9), " ", "all"))#
</cfoutput>
			<p>
				For client-side validation, add the rules that you want applied 
				using the validationSetup attribute on the opening form tag.  
				See the <a href="customValidation.cfm">custom validation demo</a> 
				for an example of how to do this.
			</p>
		</li>
		<li>
			<h4>Q. I have an AJAX-based, one-page "application".  How can I incorporate cfUniForm into that environment?</h4>
			<p>
				cfUniForm has configuration options that will allow you to pre-load all of your CSS and JavaScript 
				files, rather than having cfUniForm load them for you.  Utilize these settings to seamlessly use 
				cfUniForm-powered forms in your AJAX application.  Take a look at the 
				<a href="preLoaded.cfm">"Pre-Loaded CSS/JS Demo"</a> for more details.
			</p>
		</li>
		<li>
			<h4>Q. I want to change the color scheme and/or alignment of my cfUniForm forms.  How can I do that?</h4>
			<p>
				In a nutshell, CSS.  You will want to either override the rules in your 
				application's CSS file, or you can configure cfUniForm to use a different
				stylesheet.  Be sure to check this 
				<a href="http://www.quackfuzed.com/index.cfm/2010/2/17/cfUniForm--RightAligned-Labels-and-No-Asterisk">simple example on my blog</a>.
			</p>
		</li>
		<li>
			<h4>Q. Can I submit an example of cfUniForm being used in the wild?</h4>
			<p>
				Absolutely!  If you have a public-facing form that is being 
				rendered by cfUniForm and would like to show off your use case, 
				please feel free to 
				<a href="http://www.quackfuzed.com/contact.cfm">submit the URL to me</a>, and 
				I will add it to the examples list.
			</p>
		</li>
	</ol>
</div>

<hr />

<ul>
	<li><a href="index.cfm">Back to the cfUniForm demo home</a></li>
	<li><a href="http://cfuniform.riaforge.org/">Download cfUniForm from RIAForge.org</a></li>
	<li><a href="http://www.quackfuzed.com/index.cfm/UniForm-Tag-Library">View my blog</a></li>
</ul>

</body>
</html>
