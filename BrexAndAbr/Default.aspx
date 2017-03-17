<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="BrexAndAbr._Default" %>


<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">  
     <style type="text/css">
         input {
             width: 100%;
             max-width: none;
             margin-top: 20px;
         }
     </style> 
    <br />
    <div class="row">
        <div class="col-md-6">
          <asp:Button runat="server" OnClick="GoToBrex_Click" Text="Brex.io" CssClass="btn btn-primary btn-lg" />
        </div>
        <%--<br />--%>
        <div class="col-md-6">
          <asp:Button runat="server" OnClick="GoToAbr_Click" Text="ABR" CssClass="btn btn-primary btn-lg" />           
        </div>
    </div>

</asp:Content>
