/*
LICENSE INFORMATION:

Copyright 2011, Joe Rinehart, Dan Wilson

Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. 

You may obtain a copy of the License at 

	http://www.apache.org/licenses/LICENSE-2.0 
	
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.

VERSION INFORMATION:

This file is part of @versionLabel@ (@versionNumber@).

The version number in parentheses is in the format versionNumber.subversion.revisionNumber.

If the version number appears as 'versionNumber' surrounded by @ symbols
then this file is a working copy and not part of a release build.
*/


component persistent="true" table="Lang"
{
	property name="LanguageId" fieldtype="id" generator="increment" type="numeric";
	property name="LanguageName" notnull="true" default="";
	property name="Countries" fieldtype="many-to-many" cfc="Country" type="array" linktable="CountryLanguage" inverse="true" singularname="Country" fkcolumn="LanguageId";
	
	public Language function init() {
		if (isNull(variables.Countries)) {
			variables.Countries = [];
		}
		return this;
	}
	
	public void function addCountry(required Country Country) 
		hint="set both sides of the bi-directional relationship" {
		arguments.Country.addLanguage(variables.LanguageName,this);
		/*
		// set this side
		if (not hasCountry(arguments.Country)) {
			arrayAppend(variables.Countries,arguments.Country);
		}
		// set the other side
		if (not arguments.Country.hasLanguage(variables.LanguageName)) {
			arguments.Country.addLanguage(variables.LanguageName,this);
		}
		*/
	}

	public void function removeCountry(required Country Country) 
		hint="set both sides of the bi-directional relationship" {
		arguments.Country.removeLanguage(variables.LanguageName);
		/*
		// set this side
		var index = arrayFind(variables.Countries,arguments.Country);
		if (index gt 0) {
			arrayDeleteAt(variables.Countries,index);
		}
		// set the other side
		if (arguments.Country.hasLanguage(variables.LanguageName)) {
			arguments.Country.removeLanguage(variables.LanguageName);
		}
		*/
	}

}

/*

That's a great idea, Barney.

In the cfc that is simply delegating you'd still have to check whether the action needs to be done or not, using the appropriate has() method, right?  I just tried a quick test where I simply delegated without a check and I ended up with an infinite loop.

*/
