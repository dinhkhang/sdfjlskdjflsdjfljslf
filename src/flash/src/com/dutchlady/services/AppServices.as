package com.dutchlady.services {
	import com.dutchlady.constants.QueryParameter;
	import com.dutchlady.http.HttpService;
	/**
	 * ...
	 * @author Hai Nguyen
	 */
	public class AppServices extends HttpService {
		
		public function AppServices(serviceUrl: String) {
			super(serviceUrl);
		}
		
		public function getTotalMoney():void {
			invokeService();
		}
		
		public function sendProfile(photoUrl: String, fullName: String, email: String, phone: String):void {
			var params: Object = { };
			params[QueryParameter.PHOTO_URL] = photoUrl;
			params[QueryParameter.FULL_NAME] = fullName;
			params[QueryParameter.EMAIL] = email;
			params[QueryParameter.PHONE] = phone;
			invokeService(params);
		}
		
		public function getTourNews():void {
			invokeService();
		}
		
		public function getProfile():void {
			invokeService();
		}
		
		public function updateDonate(functionName: String):void {
			var params: Object = { };
			params[QueryParameter.FUNCTION_NAME] = functionName;
			invokeService(params);
		}
	}

}