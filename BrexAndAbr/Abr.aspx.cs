using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using Newtonsoft.Json.Linq;
using BrexAndAbr.Models;
using System.Web.Script.Serialization;
using System.Web.Configuration;

namespace BrexAndAbr
{
	public partial class Abr : System.Web.UI.Page
	{
		protected string abrGUID = @WebConfigurationManager.AppSettings["AbrGUID"];
		protected void Page_Load(object sender, EventArgs e)
		{
			Page.Title = "ABN lookup (Australian government)";
		}

		[WebMethod]
		public static string SearchCompanies(string authGuid, string searchValue, bool includeHistory)
		{
			string url = @WebConfigurationManager.AppSettings["AbrApiUrl"];
			string history = includeHistory ? "Y" : "N";

			url += "?searchString=" + HttpUtility.HtmlEncode(searchValue) +
				"&includeHistoricalDetails=" + history + "&authenticationGuid=" + HttpUtility.HtmlEncode(authGuid);
			string requestResponse = Helper.GetRequest(url, new List<string>(), false);

			return HttpUtility.HtmlEncode(requestResponse);
		}
	}
}