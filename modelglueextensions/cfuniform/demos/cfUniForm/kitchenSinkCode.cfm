<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<cfsilent>
<!--- 
filename:		cfMgmtDemos/cfUniForm/demos/kitchenSinkCode.cfm
date created:	10/1/2008
author:			Matt Quackenbush (http://www.quackfuzed.com)
purpose:		I display the code for the 'Kitchen Sink Demo'
				
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
	10/1/2008		New																				MQ
	
 --->

</cfsilent>

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-us" lang="en-us">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="/demos/assets/css/demostyles.css" type="text/css" rel="stylesheet" media="all" />
	<title>cfUniForm - Kitchen Sink Demo - The Code</title>
</head>

<body>

<p>
	This page shows you the code used to generate the form 
	on the <a href="kitchenSink.cfm">kitchen sink demo page</a>.
</p>
<ul>
	<li><a href="index.cfm">Back to the cfUniForm demo home</a></li>
	<li><a href="http://cfuniform.riaforge.org/">Download cfUniForm from RIAForge.org</a></li>
	<li><a href="http://www.quackfuzed.com/index.cfm/UniForm-Tag-Library">View my blog</a></li>
</ul>

<hr />

<cfoutput>
#htmlCodeFormat(replace('
<div id="wrap">
	<div class="cfUniForm-form-container">
		<!--- 
			The opening tag demonstrates optional attributes to do the following:
				1) determine where to place the error messages [valid options: top, inline, both, none]
				2) have the tag library load jQuery and the following jQuery plugin prerequisites: 
					a) validation plugin
					b) masked entry plugin
					c) datepicker plugin
					d) timeentry plugin
					e) textarea resize plugin
				3) utilize the dateSetup attribute to set a global default year range for the dropdown in the datepicker popup
		 --->
		<uform:form action="##cgi.script_name##" 
					id="myDemoForm" 
					errors="##errs##" 
					errorMessagePlacement="both" 
					okMsg="This is where an optional success message can be placed." 
					submitValue=" Sign Me Up " 
					loadjQuery="true" 
					loadValidation="true" 
					loadMaskUI="true" 
					loadDateUI="true" 
					dateSetup="{yearRange: ''1927:##year(now())##''}" 
					loadTimeUI="true" 
					loadTextareaResize="true">
			
			<p>This first fieldset features the default layout (class="inlineLabels").  No class attribute is required.</p>
			
			<uform:fieldset legend="Required Fields">
				<input type="hidden" name="foo" value="1" />
				<uform:field label="Email Address" 
							name="emailAddress" 
							isRequired="true" 
							type="text" 
							value="##form.emailAddress##" 
							hint="Note: Your email is your username.  Use a valid email address." />
				
				<uform:field label="Choose Password" 
							name="password" 
							isRequired="true" 
							type="password" /><!--- for security purposes, we don''t populate the password --->
				
				<uform:field label="Re-enter Password" 
							name="password2" 
							isRequired="true" 
							type="password" /><!--- for security purposes, we don''t populate the password --->
				
				<uform:field label="First Name" 
							name="firstName" 
							isRequired="true" 
							type="text" 
							value="##form.firstName##" />
				
				<uform:field label="Last Name" 
							name="lastName" 
							isRequired="true" 
							type="text" 
							value="##form.lastName##" />
				
				<!--- 
					This demonstrates combining the cfUniForm type="custom" with the new 
					multiField class in the Uni-Form markup.
				 --->
				<uform:field type="custom">
					<p class="label">
						<em>*</em> Date of Birth
					</p>
					<div class="multiField">
						<label for="dob_month" class="blockLabel">
							Month 
							<select id="dob_month" 
									name="dob_month">
								<option value="1">January</option>
							</select>
						</label>
						<label for="dob_day" class="blockLabel">
							Day 
							<select id="dob_day" 
									name="dob_day">
								<option value="1">1</option>
							</select>
						</label>
						<label for="dob_year" class="blockLabel">
							Year 
							<select id="dob_year" 
									name="dob_year">
								<option value="1">1908</option>
							</select>
						</label>
					</div>
					<p class="formHint">Don''t lie!</p>
				</uform:field>
				
				<uform:field label="Skills and Interests" 
							name="skillsInterests" 
							isRequired="true" 
							type="textarea" 
							value="##form.skillsInterests##" 
							hint=''Enter your skills and interests by terms separated with commas (E.g. computers, GTD, running). 
									Will be presented on your profile as a 
									<a href="http://en.wikipedia.org/wiki/Tag_cloud" title="Definition of a tag cloud on Wikipedia">tag cloud</a>.'' />
				
				<uform:field label="Screen Name" 
							name="screenName" 
							isRequired="true" 
							type="text" 
							value="##form.screenName##" 
							hint="Note: Used on the message board." />
				
				<uform:field label="Age Group" name="age" type="radio" isRequired="true">
					<uform:radio label="18-25" 
								value="1" 
								isChecked="##form.age EQ 1##" />
					
					<uform:radio label="26-40" 
								value="2" 
								isChecked="##form.age EQ 2##" />
					
					<uform:radio label="41-60" 
								value="3" 
								isChecked="##form.age EQ 3##" />
					
					<uform:radio label="61+" 
								value="4" 
								isChecked="##form.age EQ 4##" />
				</uform:field>
				
				<uform:field label="Upload Picture" 
							name="upload" 
							type="file" 
							hint="Your image will be resized to 80x80 pixels." />
				
				<uform:field label="Rate your picture"
							name="picRating"
							type="rating"
							hint="A ratings hint." />
				
				<uform:field label="Display Options" 
							name="displayOptions" 
							type="checkboxgroup">
							<!--- this is a checkboxgroup, so the submitted form will result in a comma-delimmited 
									list of values (one for each item that is checked) --->
					
					<uform:checkbox label="Display my email address" 
									value="email" 
									isChecked="##listFindNoCase(form.displayOptions, ''email'') GT 0##" />
					
					<uform:checkbox label="Display my picture" 
									value="pic" 
									isChecked="##listFindNoCase(form.displayOptions, ''pic'') GT 0##" />
				</uform:field>
			</uform:fieldset>
			
			<uform:fieldset legend="Optional Fields" 
							class="blockLabels">
			
				<p>This fieldset has the class <code>blockLabels</code> applied to it, 
					and as a result we get a different form layout.</p>
				
				<uform:field label="Country" 
							name="country" 
							type="select" 
							isRequired="true">
					<uform:countryCodes defaultCountry="US" />
				</uform:field>
				
				<uform:field label="State / Province" 
							name="state" 
							type="select">
					<uform:states-us defaultState="TX" showUS="true" />
					<uform:states-can showSelect="false" />
				</uform:field>
				
				<uform:field label="Address" 
							name="address" 
							type="text" 
							value="##form.address##" 
							hint="e.g.: 123 Any Street" />
				
				<uform:field label="City" 
							name="city" 
							type="text" 
							value="##form.city##" />
				
				<uform:field label="Zip / Postal Code" 
							name="zip" 
							type="text" 
							value="##form.zip##" />
				
				<uform:field label="Telephone" 
							name="phone" 
							type="text" 
							value="##form.phone##" 
							hint="e.g.: 202-555-1212"
							mask="(999) 999-9999" />
				
				<uform:field label="Cell Phone" 
							name="cellPhone" 
							type="text" 
							value="##form.cellPhone##" 
							hint="e.g.: 202-555-1212"
							mask="(999) 999-9999" />
				
				<uform:field label="Gender" name="gender" type="radio">
					<uform:radio label="Male" 
								value="1" 
								isChecked="##form.gender EQ 1##" />
					
					<uform:radio label="Female" 
								value="2" 
								isChecked="##form.gender EQ 2##" />
				</uform:field>
				
				<!--- 
					Another demonstration of type="custom" with multiField class, this time with blockLabels.
				 --->
				<uform:field type="custom">
					<p class="label">
						<em>*</em> Date of Birth
					</p>
					<div class="multiField">
						<label for="dob_month2" class="blockLabel">
							Month 
							<select id="dob_month2" 
									name="dob_month2">
								<option value="1">January</option>
							</select>
						</label>
						<label for="dob_day2" class="blockLabel">
							Day 
							<select id="dob_day2" 
									name="dob_day2">
								<option value="1">1</option>
							</select>
						</label>
						<label for="dob_year2" class="blockLabel">
							Year 
							<select id="dob_year2" 
									name="dob_year2">
								<option value="1">1908</option>
							</select>
						</label>
					</div>
					<p class="formHint">Don''t lie!</p>
				</uform:field>
				
				<uform:field label="Date of Birth" 
							name="contactDOB" 
							isRequired="true" 
							type="date" 
							inputClass="date" />
				
				<!--- 
					This is simply to demonstrate that you can have granular control over your datepicker fields.  
					In the field above (date of birth), we utilize the global yearRange set in the opening form tag, 
					but here for our ''appointment date'' field, we''re going to override that setting and pass in 
					a date range in the future.
				 --->
				<uform:field label="Appointment Date" 
							name="appointmentDate" 
							isRequired="false" 
							type="date" 
							pluginSetup="{yearRange: ''##year(now())##:##year(dateAdd(''yyyy'', 2, now()))##''}" />
				
				<!--- 
					Similar to the datepicker field above, we''re setting timeEntry plugin rules that apply only 
					to this field.  However, instead of passing a string, we''re setting and passing a struct 
					instead.
					
					We could have used the ''timeSetup'' attribute on the opening form tag if 
					we wanted to set a global rule for the form.
				 --->
				<cfscript>
					timeConfig = structNew();
					timeConfig[''show24Hours''] = true;
					timeConfig[''showSeconds''] = false;
				</cfscript>
				<uform:field label="Appointment Time"
							name="appointmentTime"
							isRequired="false"
							type="time"
							pluginSetup="##timeConfig##" />
				
				<uform:field label="About You" 
							name="aboutYou" 
							type="textarea" 
							value="##form.aboutYou##" 
							hint="Tell us something about yourself in 300 words or less." />
				
				<uform:field name="newsletter" 
							label="Send me your news and information (a.k.a. junk)" 
							type="checkbox" 
							value="1" 
							isChecked="##structKeyExists(form, ''newsletter'')##" />
							<!--- regular checkbox; it will either exist or not exist when the form is submitted --->
				
				<!--- 
					Here we are using the captchaWidth, captchaMinChars, and captchaMaxChars
					attributes to override the defaults.
					
					NOTE: captchaMaxChars should be less than or equal to 8.
				 --->
				<uform:field name="solveIt2"
							label="Please enter the letters/numbers you see"
							type="captcha"
							captchaWidth="400"
							captchaMinChars="5"
							captchaMaxChars="8" />
				
				<!--- 
					Here we are changing the default star count from 5 to 10, as well as
					splitting our stars into half-star ratings.  Additionally, we are 
					using the ''starTitles'' attribute to provide an array of titles for our 
					stars, and setting ''showStarTips'' to true to display "star tips", 
					which will appear to the right of the rating stars when the stars 
					are hovered over.
				 --->
				<cfscript>
					starTitles = [
						"You Call That A Challenge???",
						"Seriously?",
						"Somewhat Easy",
						"Getting Easy",
						"Not Too Bad",
						"Getting Difficult",
						"Somewhat Difficult",
						"Pretty Difficult",
						"Ouch!!",
						"OMG!!!"
					];
				</cfscript>
				<uform:field label="Rate the image above"
							name="captchaRating"
							type="rating"
							starCount="10"
							starSplit="2"
							starTitles="##starTitles##"
							showStarTips="true" />
				
				<uform:field name="i_agree" 
							label="I have read and agree to your <a href=''/''>privacy policy</a>" 
							value="1" 
							type="checkbox" 
							isChecked="##structKeyExists(form, ''i_agree'')##" />
							<!--- regular checkbox; it will either exist or not exist when the form is submitted --->
			</uform:fieldset>
		</uform:form>
	</div>
</div>
' ,chr(9), " ", "all"))#
</cfoutput>

<hr />

<ul>
	<li><a href="kitchenSink.cfm">View the "Kitchen Sink" demo form</a></li>
	<li><a href="index.cfm">Back to the cfUniForm demo home</a></li>
	<li><a href="http://cfuniform.riaforge.org/">Download cfUniForm from RIAForge.org</a></li>
	<li><a href="http://www.quackfuzed.com/index.cfm/UniForm-Tag-Library">View my blog</a></li>
</ul>

</body>
</html>

