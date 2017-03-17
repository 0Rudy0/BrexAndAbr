using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;


namespace BrexAndAbr.Models
{
	public class CompanyMini
	{
		public string id { get; set; }
		public string country { get; set; }
		public string registrationNumber { get; set; }
		public string name { get; set; }
		public CompanyMini(JObject jobject)
		{
			id = (string)jobject["id"];
			country = (string)jobject["country"];
			registrationNumber = (string)jobject["registrationNumber"];
			name = (string)jobject["name"];
		}
		public CompanyMini()
		{

		}
	}
}