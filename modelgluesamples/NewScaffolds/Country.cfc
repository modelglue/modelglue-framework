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


component persistent="true" orderedPropertyList="CountryCode,CountryName,SortSequence,Provinces,Languages"
{
	property name="CountryId" fieldtype="id" generator="increment" type="numeric";
	property name="CountryCode" length="2" notnull="true";
	property name="CountryName" notnull="true";
	property name="SortSequence" notnull="true" ormtype="integer";
	property name="Provinces" fieldtype="one-to-many" cfc="Province" type="array" singularname="Province" fkcolumn="CountryId" inverse="true";
	property name="Languages" fieldtype="many-to-many" cfc="Language" type="struct" structkeycolumn="LanguageName" structkeytype="string" linktable="CountryLanguage" singularname="Language" fkcolumn="CountryId";
	
	public Country function init() {
		if (isNull(variables.Languages)) {
			variables.Languages = {};
		}
		return this;
	}
	
	public void function addLanguage(required string key,required Language Language) 
		hint="set both sides of the bi-directional relationship" {
		// set this side
		variables.Languages[arguments.key] = arguments.Language;
		// set the other side
		if (not arguments.Language.hasCountry(this)) {
			arrayAppend(arguments.Language.getCountries(),this);
			//arguments.Language.addCountry(this);
		}
	}

	public void function removeLanguage(required string key) 
		hint="set both sides of the bi-directional relationship" {
		// set the other side
		var Language = (structKeyExists(variables.Languages,arguments.key) ? variables.Languages[arguments.key] : "");
		if (isObject(Language) and Language.hasCountry(this)) {
			var Countries = Language.getCountries();
			var index = arrayFind(Countries,this);
			if (index gt 0) {
				arrayDeleteAt(Countries,index);
			}
			//Language.removeCountry(this);
		}
		// set this side
		structDelete(variables.Languages,arguments.key);
	}

}
