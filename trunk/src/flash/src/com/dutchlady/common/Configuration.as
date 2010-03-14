package com.dutchlady.common {
	/**
	 * ...
	 * @author Hai Nguyen
	 */
	public class Configuration {
		private static var _instance: Configuration;
		
		public var configXml: XML;
		
		public function Configuration() {
			if (_instance) throw new Error("Configuration is singleton class");
			_instance = this;
		}
		
		public static function get instance(): Configuration { 
			if (!_instance) {
				_instance =  new Configuration();
			}
			return _instance; 
		}
		
		public function get defaultGateway():String {
			return configXml.services.gatewayUrl[0].toString();
			//return "http://demo.intelligent-content.net/FlashAPI/FlashServices.asmx";
		}
		
		public function get getTotalMoneyServiceUrl():String {
			return defaultGateway + "FlashServices.asmx/GetTotalMoney";
		}
		
		public function get uploadedImageBaseUrl(): String {
			return configXml.services.uploadedImageBaseUrl[0];
		}
		
		public function get uploadedThumbBaseUrl(): String {
			return uploadedImageBaseUrl;
		}
		
		public function get imageUploadServiceUrl():String {
			return defaultGateway + "/UploadImage.aspx";
		}
		
		public function get saveImageServiceUrl():String {
			return defaultGateway + "/SaveImage.aspx";
		}
		
		public function get sendProfileServiceUrl():String {
			return defaultGateway + "FlashServices.asmx/SendProfile";
		}
		
		public function get getProfileServiceUrl():String {
			return defaultGateway + "FlashServices.asmx/GetProfiles";
		}
		
		public function get getTourNewsServiceUrl():String {
			return defaultGateway + "FlashServices.asmx/GetContents";
		}
		
		public function get updateDonateServiceUrl():String {
			return defaultGateway + "FlashServices.asmx/UpdateDonate";
		}
		
		public function get sendToFriendServiceUrl():String {
			return defaultGateway + "FlashServices.asmx/SendToFriend";
		}
		
		public function get viewTourItemUrl():String {
			return configXml.services.viewTourItemUrl[0].toString();
		}
	}

}