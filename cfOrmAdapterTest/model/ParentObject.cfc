component persistent="true" hint="An object to act as a parent to test inheritance." output="false"
{
	property name="mainId" fieldtype="id" generator="native";
	property name="aParentProperty";
	
	property name="parentmany2one" fieldtype="many-to-one" cfc="many2one" fkcolumn="parentmany2oneId";
	property name="parentone2many_array" fieldtype="one-to-many" cfc="parentone2many_array" fkcolumn="mainId" type="array" inverse="true";
	property name="parentone2one" fieldtype="one-to-one" cfc="parentone2one";
	property name="parentmany2many_array" fieldtype="many-to-many" cfc="parentmany2many_array" linktable="parentmain_many2many_array" type="array" inverse="true" fkcolumn="mainId";
	
}
