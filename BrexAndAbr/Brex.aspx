<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="True" CodeBehind="Brex.aspx.cs" Inherits="BrexAndAbr.Brex" %>


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

        #noResultContent {
            display: none;
            text-align: center;
            color: brown;
            line-height: 100px;
        }
    </style>
    <script type="text/javascript" src="Scripts/knockout-3.4.1.js"></script>
    <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/highlight.js/9.9.0/styles/default.min.css">
    <script src="//cdnjs.cloudflare.com/ajax/libs/highlight.js/9.9.0/highlight.min.js"></script>
    <h2>Company search on BREX</h2>
    <br />
    <div class="row">
        <div class="col-md-6">
            <div class="panel panel-default">
                <div class="panel-heading">API key</div>
                <div class="panel-body">
                    <input type="text" class="form-control" id="apiKey" name="apiKey" placeholder="Enter API key" value="<%= brexAPI %>">
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <label for="apiKeyTextBox">Search by</label>
            <br />
            <div class="btn-group" id="searchbyBtnGroup" role="group" aria-label="...">
                <button type="button" id="searchByName" data-search-by="name" class="btn btn-default">Name</button>
                <button type="button" id="searchByRegNum" data-search-by="regNum" class="btn btn-default">Registration number</button>
            </div>

        </div>
    </div>
    <br />
    <div class="row">
        <div class="col" style="padding-left: 15px;">
            <div class="form-group">
                <label for="countryCode">Enter country code</label>
                <input type="text" class="form-control" id="countryCode" placeholder="2 chars, e.g UK" valuee="UK">
            </div>
        </div>
        <div class="col" style="margin-left: 30px;">
            <div class="form-group">
                <label for="searchString">Enter search value</label>
                <input type="text" class="form-control" id="searchString" placeholder="" valuee="Motors">
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-6">
            <button type="button" id="searchBtn" class="btn btn-primary btn-lg">Search</button>
        </div>
    </div>
    <br />
    <div class="resultHolder">
        <div id="loadingDiv"></div>
        <div id="noResultContent">
            <h4>No result</h4>
        </div>
        <table class="table table-bordered" data-bind="foreach: companies">
            <tr>
                <td data-bind="text: name">
                </td>
                <td>
                    <div class="btn-group" role="group" aria-label="...">
                        <button type="button" class="btn btn-default" data-bind="click: viewMini">Mini</button>
                        <button type="button" class="btn btn-default" data-bind="click: viewMaster">Master</button>
                        <button type="button" class="btn btn-default" data-bind="click: viewFull">Full</button>
                    </div>
                </td>
            </tr>
        </table>
    </div>

    <div class="modal fade" id="companyDetailsModal" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">Company details</h4>
                </div>
                <div class="modal-body">
                    <pre>
                        <code class="json" data-bind="text: currCompany">

                        </code>
                    </pre>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        var searchBy = 'name';
        var viewModel = {
            companies: ko.observableArray([]),
            currCompany: ko.observable()
        }
        $('#searchByName').addClass('btn-primary');

        ko.applyBindings(viewModel);

        function GetCompanies(successCallback, failureCallback) {
            $('#loadingDiv').show();
            $('#noResultContent').hide();
            viewModel.companies.removeAll();
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "Brex.aspx/SearchCompanies",
                data: JSON.stringify({
                    apiKey: $('#apiKey').val(),
                    searchBy: searchBy,
                    countryCode: $('#countryCode').val(),
                    searchValue: $('#searchString').val()
                }),
                success: function (data) {
                    $('#loadingDiv').hide();
                    successCallback(JSON.parse(data.d));
                },
                error: function (data) {
                    $('#noResultContent').show();
                    //failureCallback(data);
                    $('#loadingDiv').hide();
                }
            });
        }

        function printResult(result) {
            if (result.length == 0) {
                $('#noResultContent').show();
            }
            else {
                for (var i = 0; i < result.length; i++) {
                    viewModel.companies.push(result[i]);
                }
            }
        }

        $(function () {
            $('#searchBtn').click(function () {
                GetCompanies(printResult, function (data) { /*console.log(data);*/ });
            });
        });

        function viewMini(item) {
            viewModel.currCompany(JSON.stringify(item, null, 4));
            $('#companyDetailsModal').modal('show');
            $('pre code').each(function (i, block) {
                hljs.highlightBlock(block);
            });
        }

        function viewMaster(item) {
            viewModel.currCompany({});
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "Brex.aspx/GetCompanyDetails",
                data: JSON.stringify({
                    companyId: item.id,
                    apiKey: $('#apiKey').val(),
                    dataSet: 'master'
                }),
                success: function (data) {
                    console.log(data.d);
                    viewModel.currCompany(data.d);
                    $('#companyDetailsModal').modal('show');
                    $('pre code').each(function (i, block) {
                        hljs.highlightBlock(block);
                    });
                },
                error: function (data) {
                    //failureCallback(data);
                }
            });
        }

        function viewFull(item) {
            viewModel.currCompany({});
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "Brex.aspx/GetCompanyDetails",
                data: JSON.stringify({
                    companyId: item.id,
                    apiKey: $('#apiKey').val(),
                    dataSet: 'full'
                }),
                success: function (data) {
                    console.log(data.d);
                    viewModel.currCompany(data.d);
                    $('#companyDetailsModal').modal('show');
                    $('pre code').each(function (i, block) {
                        hljs.highlightBlock(block);
                    });
                },
                error: function (data) {
                    //failureCallback(data);
                }
            });
        }

        $('#searchbyBtnGroup button').click(function (e) {
            var target = $(e.currentTarget);
            target.addClass('btn-primary');
            $(target.siblings()[0]).removeClass('btn-primary');
            searchBy = target[0].getAttribute("data-search-by");
        });
    </script>

</asp:Content>
