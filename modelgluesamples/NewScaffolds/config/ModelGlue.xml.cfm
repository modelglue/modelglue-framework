<?xml version="1.0" encoding="UTF-8"?>
<modelglue>
	<controllers>
		<controller id="Controller" type="controller.Controller">
			<message-listener message="onRequestStart" />
		</controller>
		<!--
		<controller id="Controller" type="controller.Controller">
			<message-listener message="onRequestStart" />
			<message-listener message="getUser" />
			<message-listener message="processLogin" />
			<message-listener message="processLogout" />
			<message-listener message="processRequestPasswordReset" />
			<message-listener message="findPasswordReset" />
			<message-listener message="processResetPassword" />
			<message-listener message="processAccount" />
			<message-listener message="getProduct" />
			<message-listener message="addToCart" />
			<message-listener message="updateCart" />
			<message-listener message="removeFromCart" />
			<message-listener message="changeCurrency" />
			<message-listener message="changeShippingMethod" />
			<message-listener message="checkout" />
			<message-listener message="getProvincesAndCountries" />
			<message-listener message="checkAuthorization" />
		</controller>
		<controller id="newController" type="controller.newController">
			<message-listener message="onSessionEnd" />
		</controller>
		
		<controller id="monerisController" type="controller.MonerisController">
			<message-listener message="requestMonerisVerification" />
			<message-listener message="monerisVerification" />
		</controller>
		-->
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
		
		<scaffold object="Country" type="edit,grid,commit,delete" propertylist="countrycode,countryname,sortsequence" event-type="templatedPage">
		</scaffold>

		<scaffold object="Province" event-type="templatedPage">
		</scaffold>

	</event-handlers>
</modelglue>

