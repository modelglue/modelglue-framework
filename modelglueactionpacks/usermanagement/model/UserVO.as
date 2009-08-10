
package modelglueactionpacks.usermanagement.model.User
{
	[RemoteClass(alias="modelglueactionpacks.usermanagement.model.User")]

	[Bindable]
	public class UserVO
	{

		public var userId:Number = null;
		public var username:String = "";
		public var password:String = "";
		public var emailAddress:String = "";
		
		public function UserVO(data:Object = null)
		{
			if (data != null) {
					this.userId = data.userId;
					this.username = data.username;
					this.password = data.password;
					this.emailAddress = data.emailAddress;
					
			}
		}

	}
}
