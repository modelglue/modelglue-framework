<!---
	Name         : C:\projects\lighthousepro\wwwroot\lighthousepro\includes\udfs.cfm
	Author       : Raymond Camden 
	Created      : earlier
	Last Updated : 3/1/08
	History      : 
--->

<cfscript>
/**
 * An &quot;enhanced&quot; version of ParagraphFormat.
 * Added replacement of tab with nonbreaking space char, idea by Mark R Andrachek.
 * Rewrite and multiOS support by Nathan Dintenfas.
 * 
 * @param string 	 The string to format. (Required)
 * @return Returns a string. 
 * @author Ben Forta (ben@forta.com) 
 * @version 3, June 26, 2002 
 */
function ParagraphFormat2(str) {
	//first make Windows style into Unix style
	str = replace(str,chr(13)&chr(10),chr(10),"ALL");
	//now make Macintosh style into Unix style
	str = replace(str,chr(13),chr(10),"ALL");
	//now fix tabs
	str = replace(str,chr(9),"&nbsp;&nbsp;&nbsp;","ALL");
	//now return the text formatted in HTML
	return replace(str,chr(10),"<br />","ALL");
}


</cfscript>

<!--- This method written by Ben Garret (http://www.civbox.com/) --->
<cffunction name="UnicodeWin1252" hint="Converts MS-Windows superset characters (Windows-1252) into their XML friendly unicode counterparts" returntype="string">
	<cfargument name="value" type="string" required="yes">
	<cfscript>
		var string = value;
		string = replaceNoCase(string,chr(8218),'&##8218;','all');	// ‚ 
		string = replaceNoCase(string,chr(402),'&##402;','all');		// ƒ 
		string = replaceNoCase(string,chr(8222),'&##8222;','all');	// „ 
		string = replaceNoCase(string,chr(8230),'&##8230;','all');	// … 
		string = replaceNoCase(string,chr(8224),'&##8224;','all');	// † 
		string = replaceNoCase(string,chr(8225),'&##8225;','all');	// ‡ 
		string = replaceNoCase(string,chr(710),'&##710;','all');		// ˆ 
		string = replaceNoCase(string,chr(8240),'&##8240;','all');	// ‰ 
		string = replaceNoCase(string,chr(352),'&##352;','all');		// Š 
		string = replaceNoCase(string,chr(8249),'&##8249;','all');	// ‹ 
		string = replaceNoCase(string,chr(338),'&##338;','all');		// Œ 
		string = replaceNoCase(string,chr(8216),'&##8216;','all');	// ‘ 
		string = replaceNoCase(string,chr(8217),'&##8217;','all');	// ’ 
		string = replaceNoCase(string,chr(8220),'&##8220;','all');	// “ 
		string = replaceNoCase(string,chr(8221),'&##8221;','all');	// ” 
		string = replaceNoCase(string,chr(8226),'&##8226;','all');	// • 
		string = replaceNoCase(string,chr(8211),'&##8211;','all');	// – 
		string = replaceNoCase(string,chr(8212),'&##8212;','all');	// — 
		string = replaceNoCase(string,chr(732),'&##732;','all');		// ˜ 
		string = replaceNoCase(string,chr(8482),'&##8482;','all');	// ™ 
		string = replaceNoCase(string,chr(353),'&##353;','all');		// š 
		string = replaceNoCase(string,chr(8250),'&##8250;','all');	// › 
		string = replaceNoCase(string,chr(339),'&##339;','all');		// œ 
		string = replaceNoCase(string,chr(376),'&##376;','all');		// Ÿ 
		string = replaceNoCase(string,chr(376),'&##376;','all');		// Ÿ 
		string = replaceNoCase(string,chr(8364),'&##8364','all');		// € 
		string = replaceNoCase(string, chr(183), '*', 'all'); // bullet
		string = replaceNoCase(string, chr(8213), '--', 'all'); // a dash
		
	</cfscript>
	<cfreturn string>
</cffunction>
