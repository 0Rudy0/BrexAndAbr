using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Services;
using BrexAndAbr.Models;
using Newtonsoft.Json.Linq;
using System.Web.Script.Serialization;
using System.Web.Configuration;

namespace BrexAndAbr
{
	public partial class Brex : System.Web.UI.Page
	{
		protected string brexAPI = @WebConfigurationManager.AppSettings["BrexApiKey"];

		protected void Page_Load(object sender, EventArgs e)
		{
			Page.Title = "Company search on BREX";
		}

		[WebMethod]
		public static string SearchCompanies(string apiKey, string searchBy, string countryCode, string searchValue)
		{
			string url = @WebConfigurationManager.AppSettings["BrexApiUrl"];
			url = searchBy == "name" ? url + "company/search/name/" : url + "company/search/number/";
			url += HttpUtility.HtmlEncode(countryCode) + '/' + HttpUtility.HtmlEncode(searchValue);
			List<string> headers = new List<string>();
			headers.Add("User_key: " + apiKey);
			string requestResponse = Helper.GetRequest(url, headers, true);
			JArray jarray = JArray.Parse(requestResponse);
			List<CompanyMini> companies = new List<CompanyMini>();
			foreach (JObject o in jarray.Children<JObject>())
			{
				CompanyMini c = new CompanyMini(o);
				companies.Add(c);
			}
			var serializer = new JavaScriptSerializer();
			return serializer.Serialize(companies);
		}

		[WebMethod]
		public static string GetCompanyDetails(string companyId, string apiKey, string dataSet)
		{
			string url = @WebConfigurationManager.AppSettings["BrexApiUrl"];
			url += "company/" + companyId + '/' + dataSet;
			List<string> headers = new List<string>();
			headers.Add("User_key: " + apiKey);
			string response = Helper.GetRequest(url, headers, true);

			return response;
		}
	}
}