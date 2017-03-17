using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net;
using System.IO;
using System.Web.Configuration;

namespace BrexAndAbr
{
	public static class Helper
	{		public static string GetRequest(string url, List<string> headers, bool isJson)
		{
			string html = string.Empty;
			try
			{
				HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
				request.AutomaticDecompression = DecompressionMethods.GZip;

				foreach (string header in headers)
				{
					request.Headers.Add(header);
				}
				if (isJson)
				{
					request.ContentType = "application/json";
					request.Accept = "application/json; charset=utf-8";
				}

				using (HttpWebResponse response = (HttpWebResponse)request.GetResponse())
				using (Stream stream = response.GetResponseStream())
				using (StreamReader reader = new StreamReader(stream))
				{
					html = reader.ReadToEnd();
				}
				return html;
			}
			catch (Exception ex)
			{
				return ex.Message;
			}
		}
	}
}