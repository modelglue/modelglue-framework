<?xml version="1.0" encoding="UTF-8"?>
<modelglue>
	<controllers>
		<controller id="Controller" type="controller.Controller">
			<message-listener message="onRequestStart" />
		</controller>
	</controllers>

	<event-types>
		<event-type name="templatedPage">
			<after>
				<results>
					<result do="display.template" />
				</results>
			</after>
		</event-type>
	</event-types>

	<event-handlers>
		<event-handler name="display.template">
			<broadcasts />
			<results />
			<views>
				<include name="template" template="dspDisplayTemplate.cfm" />
			</views>
		</event-handler>
		
		<scaffold object="Country" type="view,list,edit,grid,commit,delete" propertylist="countrycode,countryname,sortsequence,provinces" event-type="templatedPage">
		</scaffold>

		<scaffold object="Province" event-type="templatedPage">
		</scaffold>

	</event-handlers>
</modelglue>

