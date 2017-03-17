<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Abr.aspx.cs" Inherits="BrexAndAbr.Abr" %>


<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <style type="text/css">
        body {
            overflow-y: scroll;
        }
        .col {
            float: left;
        }

        button#search {
            width: 100%;
        }

        input#countryCode {
            width: 150px;
        }

        input#searchString {
            max-width: 350px;
            width: 350px;
        }

        .table-bordered .btn-group {
            width: 100%;
        }

            .table-bordered .btn-group button {
                width: 33.3%;
            }

        .modal-dialog {
            width: 80%;
        }

        #loadingDiv {
            width: 100%;
            height: 200px;
            display: none;
            background-image: url(Content/images/loadingRing.svg);
            background-repeat: no-repeat;
            background-size: 100px;
            background-position: 50% 50%;
        }

        #noResultContent,
        #errorResultContent {
            display: none;
            text-align: center;
            color: brown;
            line-height: 100px;
        }

        #resultXml {
            display: none;
        }

        pre {
            font-size: 10pt;
        }
    </style>
    <script type="text/javascript" src="Scripts/knockout-3.4.1.js"></script>
    <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/highlight.js/9.9.0/styles/default.min.css">
    <script src="//cdnjs.cloudflare.com/ajax/libs/highlight.js/9.9.0/highlight.min.js"></script>
    <h2>ABN lookup (Australian government)</h2>
    <br />
    <div class="row">
        <div class="col-md-6">
            <div class="panel panel-default panel-authGuid">
                <div class="panel-heading">Authentication GUID</div>
                <div class="panel-body">
                    <input type="text" class="form-control" name="authGuid" id="authGuid" 
                        placeholder="Enter authentication GUID" value="<%= abrGUID %>">
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col" style="margin-left: 30px; float: left;">
            <div class="form-group">
                <label for="searchString" id="searchLabel">Enter search value</label>
                <input type="text" class="form-control" id="searchString" placeholder="" valuee="82662911516">
            </div>
        </div>
        <div class="col" style="margin-left: 20px; float: left; margin-top: 25px;">
            <a class="btn btn-default" id="btnHistory">Include Historical details</a>
        </div>
    </div>
    <div class="row">
        <div class="col-md-6" style="margin-left: 15px;">
            <a id="searchBtn" class="btn btn-primary btn-lg">Search</a>
        </div>
    </div>
    <br />
    <div class="resultHolder">
        <div id="loadingDiv"></div>
        <pre id="resultXml">
            <code  id="resultXmlContent"></code>
        </pre>
    </div>

    <script type="text/javascript">
        var viewModel = {
            companies: ko.observableArray([]),
            currCompany: ko.observable()
        }
      
        var includeHisotry = false;

       

        function GetCompanies(successCallback, failureCallback) {
            $('#loadingDiv').show();
            $('#noResultContent').hide();
            $('#errorResultContent').hide();
            $('#resultXmlContent').html('');
            $('#resultXml').hide();
            $('.panel-authGuid').removeClass('panel-danger');
            $('.panel-authGuid').addClass('panel-default');
            $('#searchLabel').css('color', 'black');
            $('#searchString').css('border-color', '#cccccc');
            viewModel.companies.removeAll();
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "Abr.aspx/SearchCompanies",
                data: JSON.stringify({
                    authGuid: $('#authGuid').val(),
                    searchValue: $('#searchString').val(),
                    //includeHistory: document.getElementById("history").checked
                    includeHistory: includeHisotry
                }),
                success: function (data) {
                    successCallback(data);
                    //if (data.d.indexOf('{') < 0) {
                    //    $('#errorResultContent').html(data.d);
                    //    $('#errorResultContent').show();
                    //}
                    //else {
                    //    //successCallback(JSON.parse(data.d));
                    //}
                },
                error: function (data) {
                    //failureCallback(data);
                    //$('#loadingDiv').hide();
                }
            });
        }

        function printResult(data) {
            $('#loadingDiv').hide();
            $('#resultXmlContent').html(data.d);
            $('#resultXml').show();
            $('pre code').each(function (i, block) {
                hljs.highlightBlock(block);
            });
            if (data.d.indexOf('The GUID entered is not recognised as a Registered Party') > -1) {
                $('.panel-authGuid').addClass('panel-danger');
                $('.panel-authGuid').removeClass('panel-default');
            }
            else if (data.d.indexOf('Search text is not a valid ABN or ACN') > -1) {
                $('#searchLabel').css('color', 'red');
                $('#searchString').css('border-color', 'red');
            }
        }

        $(function () {
            hljs.initHighlightingOnLoad();
            ko.applyBindings(viewModel);
            $('#searchByName').addClass('btn-primary');

            $('#searchBtn').click(function () {
                GetCompanies(printResult, function (data) { /*console.log(data);*/ });
            });

            $('#btnHistory').click(function () {
                includeHisotry = !includeHisotry;
                $('#btnHistory').toggleClass('btn-primary');
            });
        });
    </script>

</asp:Content>
