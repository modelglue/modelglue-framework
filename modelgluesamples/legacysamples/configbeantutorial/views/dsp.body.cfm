<!---
LICENSE INFORMATION:

Copyright 2007, Joe Rinehart
 
Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. 

You may obtain a copy of the License at 

	http://www.apache.org/licenses/LICENSE-2.0 
	
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.

VERSION INFORMATION:

This file is part of Model-Glue Model-Glue: ColdFusion (2.0.304).

The version number in parenthesis is in the format versionNumber.subversion.revisionNumber.
--->


<cfoutput>
Time: #viewState.getValue("currentTime")#<br />
Long Date: #viewState.getValue("currentDateLong")#<br />
Short Date: #viewState.getValue("currentDateShort")#<br />
</cfoutput>
<br />
<strong>Eat Your Beans:  ConfigBeans in Model-Glue</strong>
		<div class="body">
		The Model-Glue Framework has a really nice feature called ConfigBeans, powered by a little tool I wrote called ChiliBeans.  By using ConfigBeans instead of inserting configuration values, like Datasource names, into your ModelGlue.xml file, you can seperate your configuration from your application.  This post gives a quick overview of creating a new ConfigBean and using it in your application.  Once you've seen how to create one from scratch, you should have no problem using the default ConfigBeans provided with the framework.    <P>

<em>Note:  I'm typing this in between running some huge queries, so it may be a bit choppy in flow.</em>    <P>
Download the example code for this tutorial at <a href="http://clearsoftware.net/configbeantutorial.zip">http://clearsoftware.net/configbeantutorial.zip</a>.    <P>
<strong>ConfigBeans:  Why bother?</strong>    <P>
Why use a ConfigBean instead of putting a new <setting> tag into your ModelGlue.xml file?  Here's a few reasons:    <P>
<ol>  <li>ConfigBeans keep your application code (which includes ModelGlue.xml) seperate from yor configuration</li>  <li>Configuration properties managed through a ConfigBean can be complex values (arrays or structs), so that you can keep your configuration in a much neater package</li>  <li>It's a lot easier to instantiate a ConfigBean and pass it along to your viewstate than it is to pass a huge number of individual strings.  For example, you can pass a bean for a datasource, rather than a DatasourceName, DatasourcePassword, and DatasourceUsername settings</li>  <li>It's a good design principle to favor passing objects (interfaces) over simple values (implementations).  </ol>    <P>

<strong>Example:  Basic internationalization</strong>    <P>
In our example, we'll create a ConfigBean that manages basic internationalization of time and date formats.  It'll manage two settings:     <P>
<ol>  <li>1.  Timeformat will define a TimeFormat() mask that we'll use</li>  <li>2.  Dateformat will be a struct, with Dateformat.long looking something like "January 1, 2005," and Dateformat.short looking something like "1/1/2005."    </ol>    <P>
Then, we'll show how to use our bean to customize how users see dates and times.    <P>
<strong>Step 1:  Create a "bean"-style CFC to hold these settings</strong>    <P>
First, we make our "bean" itself.  It's a basic little CFC that has an Init() method, and Getter/Setter methods for each of our configuration properties.  Naming is important here:  when we get to the bean XML, it's going to look for methods named Get[NAME] and Set[NAME]!.     <P>

The directory that you create the bean in is important - it must be one of the mappings listed in your ModelGlue.xml's beanMappings setting.  In the code that accompanies this tutorial, you'll find this bean at /config/beans/DateTimeFormatBean.cfc .    <P>
Without further ado, here's the bean:    <P>
<div class="code"><FONT COLOR=MAROON>&lt;cfcomponent output=<FONT COLOR=BLUE>"false"</FONT>&gt;</FONT><br> <br> <FONT COLOR=MAROON>&lt;cffunction name=<FONT COLOR=BLUE>"Init"</FONT> output=<FONT COLOR=BLUE>"false"</FONT>&gt;</FONT><br>   <FONT COLOR=MAROON>&lt;cfset variables.timeFormat = <FONT COLOR=BLUE>""</FONT> /&gt;</FONT><br>   <FONT COLOR=MAROON>&lt;cfset variables.dateFormat = structNew() /&gt;</FONT><br>   <FONT COLOR=MAROON>&lt;cfset variables.dateFormat.short = <FONT COLOR=BLUE>""</FONT> /&gt;</FONT><br>   <FONT COLOR=MAROON>&lt;cfset variables.dateFormat.long = <FONT COLOR=BLUE>""</FONT> /&gt;</FONT><br>   <FONT COLOR=MAROON>&lt;cfreturn this /&gt;</FONT><br> <FONT COLOR=MAROON>&lt;/cffunction&gt;</FONT><br> <br> <FONT COLOR=MAROON>&lt;cffunction name=<FONT COLOR=BLUE>"SetTimeFormat"</FONT> output=<FONT COLOR=BLUE>"false"</FONT>&gt;</FONT><br>   <FONT COLOR=MAROON>&lt;cfargument name=<FONT COLOR=BLUE>"value"</FONT> type=<FONT COLOR=BLUE>"string"</FONT> required=<FONT COLOR=BLUE>"true"</FONT> /&gt;</FONT><br>   <FONT COLOR=MAROON>&lt;cfset variables.timeFormat = arguments.value /&gt;</FONT> <br> <FONT COLOR=MAROON>&lt;/cffunction&gt;</FONT><br> <br> <FONT COLOR=MAROON>&lt;cffunction name=<FONT COLOR=BLUE>"GetTimeFormat"</FONT> output=<FONT COLOR=BLUE>"false"</FONT>&gt;</FONT><br>   <FONT COLOR=MAROON>&lt;cfreturn variables.timeFormat /&gt;</FONT><br> <FONT COLOR=MAROON>&lt;/cffunction&gt;</FONT><br>  <br> <FONT COLOR=MAROON>&lt;cffunction name=<FONT COLOR=BLUE>"SetDateFormat"</FONT> output=<FONT COLOR=BLUE>"false"</FONT>&gt;</FONT><br>   <FONT COLOR=MAROON>&lt;cfargument name=<FONT COLOR=BLUE>"value"</FONT> type=<FONT COLOR=BLUE>"struct"</FONT> required=<FONT COLOR=BLUE>"true"</FONT> /&gt;</FONT><br>   <FONT COLOR=MAROON>&lt;cfset variables.dateFormat = arguments.value /&gt;</FONT> <br> <FONT COLOR=MAROON>&lt;/cffunction&gt;</FONT><br> <br> <FONT COLOR=MAROON>&lt;cffunction name=<FONT COLOR=BLUE>"GetDateFormat"</FONT> output=<FONT COLOR=BLUE>"false"</FONT>&gt;</FONT><br>   <FONT COLOR=MAROON>&lt;cfreturn variables.dateFormat /&gt;</FONT><br> <FONT COLOR=MAROON>&lt;/cffunction&gt;</FONT><br> <br> <FONT COLOR=MAROON>&lt;/cfcomponent&gt;</FONT></div>    <P>

Pretty simple little nugget of information, no?    <P>
<strong>Step 2:  Create an XML file containing your configuration properties</strong>    <P>
Ok, now we need a place to actually store your application-specific configuration information.  We store this in an XML file that maps to the CFC we just created - we'll put it in /config/beans/DateTimeFormat.xml.  Then, in your Model-Glue application, when you ask for a bean from this XML file, you receive an instance of the CFC whose properties are populated with the information in your XML file.  It may sounds confusing, but it's really pretty simple once you see it in action.    <P>
Here's our XML:  it shows how to define properties that are simple (timeformat) and struct (dateFormat).  (Aside: If you look in /ModelGlue/Bean/CommonBeans/ExampleBean.xml, you'll see a full example that shows how to create all the complex data types).    <P>
<div class="code"><FONT COLOR=NAVY>&lt;bean class=<FONT COLOR=BLUE>"modelgluesamples.legacysamples.configbeantutorial.config.beans.DateTimeFormatBean"</FONT> singleton=<FONT COLOR=BLUE>"true"</FONT>&gt;</FONT><br>   <FONT COLOR=GRAY><I>&lt;!-- Time Format --&gt;</I></FONT><br>   <FONT COLOR=NAVY>&lt;property name=<FONT COLOR=BLUE>"TimeFormat"</FONT>&gt;</FONT><br>   &nbsp;&nbsp;&nbsp;<FONT COLOR=NAVY>&lt;value&gt;</FONT>H:MM TT<FONT COLOR=NAVY>&lt;/value&gt;</FONT><br>   <FONT COLOR=NAVY>&lt;/property&gt;</FONT><br>   <br>   <FONT COLOR=GRAY><I>&lt;!-- Date Format --&gt;</I></FONT><br>   <FONT COLOR=NAVY>&lt;property name=<FONT COLOR=BLUE>"DateFormat"</FONT>&gt;</FONT><br> &nbsp;&nbsp;&nbsp;<FONT COLOR=NAVY>&lt;struct&gt;</FONT><br> &nbsp;&nbsp;&nbsp;  <FONT COLOR=NAVY>&lt;element key=<FONT COLOR=BLUE>"Long"</FONT>&gt;</FONT><br> &nbsp;&nbsp;&nbsp;    <FONT COLOR=NAVY>&lt;value&gt;</FONT>mmm d, yyyy<FONT COLOR=NAVY>&lt;/value&gt;</FONT><br> &nbsp;&nbsp;&nbsp;  <FONT COLOR=NAVY>&lt;/element&gt;</FONT><br> &nbsp;&nbsp;&nbsp;  <FONT COLOR=NAVY>&lt;element key=<FONT COLOR=BLUE>"Short"</FONT>&gt;</FONT><br> &nbsp;&nbsp;&nbsp;    <FONT COLOR=NAVY>&lt;value&gt;</FONT>m/d/yy<FONT COLOR=NAVY>&lt;/value&gt;</FONT><br> &nbsp;&nbsp;&nbsp;  <FONT COLOR=NAVY>&lt;/element&gt;</FONT><br> &nbsp;&nbsp;&nbsp;<FONT COLOR=NAVY>&lt;/struct&gt;</FONT><br>   <FONT COLOR=NAVY>&lt;/property&gt;</FONT><br> <FONT COLOR=NAVY>&lt;/bean&gt;</FONT></div>    <P>

Let's look at that line by line:    <P>
<div class="code"><FONT COLOR=NAVY>&lt;bean class=<FONT COLOR=BLUE>"ConfigBeanTutorial.config.beans.DateTimeFormatBean"</FONT> singleton=<FONT COLOR=BLUE>"true"</FONT>&gt;</FONT></div>    <P>
This line states that when you ask ModelGlue for a bean from "DateTimeFormat.xml", you'll receive an instance of the CFC at modelgluesamples.legacysamples.configbeantutorial.config.beans.DateTimeFormatBean.  "Singleton" means that Model-Glue will save this instance in the application scope, and any further requests for the DateTimeFormat.xml bean will receive a reference to the same instance.    <P>
<div class="code"><FONT COLOR=GRAY><I>&lt;!-- Time Format --&gt;</I></FONT><br>   <FONT COLOR=NAVY>&lt;property name=<FONT COLOR=BLUE>"TimeFormat"</FONT>&gt;</FONT><br>   &nbsp;&nbsp;&nbsp;<FONT COLOR=NAVY>&lt;value&gt;</FONT>H:MM TT<FONT COLOR=NAVY>&lt;/value&gt;</FONT><br>   <FONT COLOR=NAVY>&lt;/property&gt;</FONT></div>    <P>

This defines the value of the TimeFormat property.  When ChiliBeans hits this block, it'll look for a function in DateTimeFormatBean.cfc called "TimeFormat", and try to set it to the value in the <value></value> blocks.    <P>
<div class="code"><FONT COLOR=GRAY><I>&lt;!-- Date Format --&gt;</I></FONT><br>   <FONT COLOR=NAVY>&lt;property name=<FONT COLOR=BLUE>"DateFormat"</FONT>&gt;</FONT><br> &nbsp;&nbsp;&nbsp;<FONT COLOR=NAVY>&lt;struct&gt;</FONT><br> &nbsp;&nbsp;&nbsp;  <FONT COLOR=NAVY>&lt;element key=<FONT COLOR=BLUE>"Long"</FONT>&gt;</FONT><br> &nbsp;&nbsp;&nbsp;    <FONT COLOR=NAVY>&lt;value&gt;</FONT>mmm d, yyyy<FONT COLOR=NAVY>&lt;/value&gt;</FONT><br> &nbsp;&nbsp;&nbsp;  <FONT COLOR=NAVY>&lt;/element&gt;</FONT><br> &nbsp;&nbsp;&nbsp;  <FONT COLOR=NAVY>&lt;element key=<FONT COLOR=BLUE>"Short"</FONT>&gt;</FONT><br> &nbsp;&nbsp;&nbsp;    <FONT COLOR=NAVY>&lt;value&gt;</FONT>m/d/yy<FONT COLOR=NAVY>&lt;/value&gt;</FONT><br> &nbsp;&nbsp;&nbsp;  <FONT COLOR=NAVY>&lt;/element&gt;</FONT><br> &nbsp;&nbsp;&nbsp;<FONT COLOR=NAVY>&lt;/struct&gt;</FONT><br>   <FONT COLOR=NAVY>&lt;/property&gt;</FONT></div>    <P>

This portion is much like the Timeformat block, but as you can see, we have a fairly easy to remember XML format for defining a structure and its members.  This will set the DateFormat property.    <P>
  <strong>Step 3:  Use your bean!</strong>    <P>
Now, in our application, we need to actually ask ModelGlue for the bean represented by DateTimeFormat.xml.  To do that, in our controller, we first use the GetModelGlue() function to ask for a reference to the framework (you can do a lot with this, like adding new controllers at runtime, but some of it is dangerous!).  Next, you use the GetConfigBean() method, passing it a filename to read.  In the sample application, we do this in our controller's constructor, and place the bean into the variables scope.  That effective "caches" the bean at the applicaiton level, and makes it available to any other methods that need it.  It looks like this:    <P>
<div class="code"><FONT COLOR=MAROON>&lt;cffunction name=<FONT COLOR=BLUE>"Init"</FONT> access=<FONT COLOR=BLUE>"Public"</FONT> returnType=<FONT COLOR=BLUE>"Controller"</FONT> output=<FONT COLOR=BLUE>"false"</FONT>&gt;</FONT><br>   <FONT COLOR=MAROON>&lt;cfargument name=<FONT COLOR=BLUE>"ModelGlue"</FONT>&gt;</FONT><br>   <br>   <FONT COLOR=MAROON>&lt;cfset super.Init(arguments.ModelGlue) /&gt;</FONT><br> <br>   <FONT COLOR=MAROON>&lt;cfset variables.dateTimeFormat = GetModelGlue().GetConfigBean(<FONT COLOR=BLUE>"DateTimeFormat.xml"</FONT>) /&gt;</FONT><br> <br>   <FONT COLOR=MAROON>&lt;cfreturn this /&gt;</FONT><br> <FONT COLOR=MAROON>&lt;/cffunction&gt;</FONT></div>    <P>

Next, we need to actually use the settings from the bean.  In our OnRequestStart handler, we'll place formatted versions of the current datetime into the data bus.  Remember, variables.dateTimeFormat now contains our ConfigBean, and we can use its getTimeFormat() and getDateFormat() methods to get our formatting masks.    <P>
<div class="code"><FONT COLOR=MAROON>&lt;cffunction name=<FONT COLOR=BLUE>"OnRequestStart"</FONT> access=<FONT COLOR=BLUE>"Public"</FONT> returnType=<FONT COLOR=BLUE>"ModelGlue.Core.Event"</FONT> output=<FONT COLOR=BLUE>"false"</FONT> hint=<FONT COLOR=BLUE>"I am an event handler."</FONT>&gt;</FONT><br>   <FONT COLOR=MAROON>&lt;cfargument name=<FONT COLOR=BLUE>"event"</FONT> type=<FONT COLOR=BLUE>"ModelGlue.Core.Event"</FONT> required=<FONT COLOR=BLUE>"true"</FONT>&gt;</FONT><br> <br> &nbsp;&nbsp;&nbsp;<FONT COLOR=MAROON>&lt;cfset var currentTime = timeFormat(now(), variables.dateTimeFormat.getTimeFormat()) /&gt;</FONT><br> &nbsp;&nbsp;&nbsp;<FONT COLOR=MAROON>&lt;cfset var currentDateLong = dateFormat(now(), variables.dateTimeFormat.getDateFormat().long) /&gt;</FONT><br> &nbsp;&nbsp;&nbsp;<FONT COLOR=MAROON>&lt;cfset var currentDateShort = dateFormat(now(), variables.dateTimeFormat.getDateFormat().short) /&gt;</FONT><br> <br> &nbsp;&nbsp;&nbsp;<FONT COLOR=MAROON>&lt;cfset arguments.event.setValue(<FONT COLOR=BLUE>"currentTime"</FONT>, currentTime) /&gt;</FONT><br> &nbsp;&nbsp;&nbsp;<FONT COLOR=MAROON>&lt;cfset arguments.event.setValue(<FONT COLOR=BLUE>"currentDateLong"</FONT>, currentDateLong) /&gt;</FONT><br> &nbsp;&nbsp;&nbsp;<FONT COLOR=MAROON>&lt;cfset arguments.event.setValue(<FONT COLOR=BLUE>"currentDateShort"</FONT>, currentDateShort) /&gt;</FONT><br> <br>   <FONT COLOR=MAROON>&lt;cfreturn arguments.event /&gt;</FONT><br> <FONT COLOR=MAROON>&lt;/cffunction&gt;</FONT></div>    <P>

  Finally, we add a little code to our view to show the values:    <P>
<div class="code"><FONT COLOR=MAROON>&lt;cfoutput&gt;</FONT><br> Time: #viewState.getValue(<FONT COLOR=BLUE>"currentTime"</FONT>)#<FONT COLOR=NAVY>&lt;br /&gt;</FONT><br> Long Date: #viewState.getValue(<FONT COLOR=BLUE>"currentDateLong"</FONT>)#<FONT COLOR=NAVY>&lt;br /&gt;</FONT><br> Short Date: #viewState.getValue(<FONT COLOR=BLUE>"currentDateShort"</FONT>)#<FONT COLOR=NAVY>&lt;br /&gt;</FONT><br> <FONT COLOR=MAROON>&lt;/cfoutput&gt;</FONT></div>    <P>

Conclusion    <P>
Ok, not too shabby!  We've created a ConfigBean from scratch, and shown what we could do with it.  We've completely separated the configuration from our application.    <P>
What next?    <P>
Imagine you have a bunch of DAOs.  In your configuration, they just need a datasource name passed to their constructor.  However, a client's implementation requires a datasource name, username, and password.  Oops.  Time to edit some code and add more arguments...    <P>
Wait!  That's a great place to use ConfigBeans.  Instead of passing a datasource to the constructor, use the ModelGlue.Bean.CommonBeans.Datasource bean (or your own implementation).  That way, you can pass whatever you need, shrinking or growing what the bean contains, but not having to change the interface to your existing components. <P>
		
		 <P>


