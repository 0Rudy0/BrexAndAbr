using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BrexAndAbr
{
	public partial class _Default : Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{

		}

		protected void GoToBrex_Click(object sender, EventArgs e)
		{
			Response.Redirect("Brex.aspx", false);
		}

		protected void GoToAbr_Click(object sender, EventArgs e)
		{
			Response.Redirect("Abr.aspx", false);
		}

		
	}
}