component persistent="true" output="false"
{
	property name="ProvinceId" fieldtype="id" generator="increment" type="numeric";
	property name="ProvinceName" notnull="true";
	property name="SortSequence" notnull="true" ormtype="integer";
	property name="Country" fieldtype="many-to-one" cfc="Country" fkcolumn="CountryId";
	
}
