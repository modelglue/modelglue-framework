component persistent="true" orderedPropertyList="CountryCode,CountryName,SortSequence,Provinces,Languages"
{
	property name="CountryId" fieldtype="id" generator="increment" type="numeric";
	property name="CountryCode" length="2" notnull="true";
	property name="CountryName" notnull="true";
	property name="SortSequence" notnull="true" ormtype="integer";
	property name="Provinces" fieldtype="one-to-many" cfc="Province" type="array" singularname="Province" fkcolumn="CountryId" inverse="true";
	property name="Languages" fieldtype="many-to-many" cfc="Language" type="struct" structkeycolumn="LanguageName" structkeytype="string" linktable="CountryLanguage" singularname="Language" fkcolumn="CountryId";
	
	public void function addLanguage(key,object) hint="set both sides of the bi-directional relationship" {
		var Countries = arguments.object.getCountries();
		if (not isArray(Countries)) {
			Countries = [];
		}
		arrayAppend(Countries,this);
		variables.Languages[arguments.key] = arguments.object;
	}

	public void function removeLanguage(key) hint="set both sides of the bi-directional relationship" {
		var Language = (structKeyExists(variables.Languages,arguments.key) ? variables.Languages[arguments.key] : "");
		if (isObject(Language)) {
			var Countries = Language.getCountries();
			if (isArray(Countries)) {
				var index = arrayFind(Countries,this);
				if (index gt 0) {
					arrayDeleteAt(Countries,index);
				}
			}
		}
		structDelete(variables.Languages,arguments.key);
	}
}
