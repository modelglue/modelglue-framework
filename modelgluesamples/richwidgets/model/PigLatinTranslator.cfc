<!---
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
--->


<cfcomponent name="PigLatinTranslator" output="false">

<cffunction name="init" returntype="any" access="public" output="false">
<cfargument name="vowels" type="string" required="true" />

<cfset variables.vowels = arguments.vowels />

<cfreturn this />
</cffunction>

<cffunction name="translate" returntype="string" access="public" output="false">
	<cfargument name="phrase" />
 
	<cfset var result = "" />
	<cfset var word = "" />
	
	<cfloop list="#arguments.phrase#" delimiters=" " index="word">
		<cfset result = result & translateWord(word) & " " /> 
	</cfloop>
	
	<cfreturn result />
</cffunction>

<cffunction name="translateWord" returntype="string" access="public" output="false">
<cfargument name="phrase" />
 
<cfset var firstVowel = reFindNoCase("[#variables.vowels#]", arguments.phrase) - 1/>
<cfset var result = trim(arguments.phrase) />
 
<!--- We started with a consonant --->
<cfif len(result) and firstVowel gt 0>
<cfset result = right(arguments.phrase, len(arguments.phrase) - firstVowel) & left(arguments.phrase, firstVowel) & "ay" />
<!--- We started with a vowel --->
<cfelseif len(result)>
<cfset result = result & "ay" />
</cfif>
 
<cfreturn result />
</cffunction>

 

</cfcomponent>
