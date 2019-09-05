<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="DocumentViewer.index" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
     <title>Viewer</title> 
    <link href="Content/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js" type="text/javascript"></script>
<style>
a {
  text-decoration: none;
  display: inline-block;
  padding: 8px 16px;
}

a:hover {
  background-color: #ddd;
  color: black;
}

.previous {
  background-color: #f1f1f1;
  color: black;
}

.next {
  background-color: #f1f1f1;
  color: black;
}

.round {
  border-radius: 50%;
}

</style>
</head>
<body>
    <form id="form1" runat="server"> 
    </form>
    <div class="navbar navbar-inverse navbar-fixed-top">
        <div class="container">
            <div class="navbar-header">
                <a class="navbar-brand" runat="server" href="~/index.aspx">Viewer</a>
            </div>
        </div>
    </div>
    <div class="container body-content">
        <div align="center" style="margin-top: 5%"> 
            <a href="#" id="btnPrevious" class="previous round">&#8249;</a>
          <strong>  Page:
            <asp:Label runat="server" ID="lblCurrentPage" Text="1"></asp:Label>
            of
            <asp:Label runat="server" ID="lblTotalPages"></asp:Label></strong> 
            <a href="#" id="btnNext" class="next round">&#8250;</a>
        </div>
        <div align="center">
            <iframe src="" name="container" id="container" scrolling="no" align="center" frameborder="1"
                width="750px" height="450px" style="margin-top: 2%;  overflow: hidden;" frameborder="0"
                allowfullscreen sandbox></iframe>
        </div>
        <hr />
        <footer>
            <p>&copy; <%: DateTime.Now.Year %> - GroupDocs</p>
        </footer>
    </div>
    <script>

        $(document).ready(function () {
            // call for the first time
            Navigate(1); 
            $('#btnNext').click(function () { 
                var currentPage = getCurrentPageNumber();
                var totalPages = getTotalPages();

                if ((currentPage + 1) <= totalPages) {
                    Navigate(currentPage + 1);
                    $('#<%=lblCurrentPage.ClientID%>').html(currentPage + 1)
                }
            });
            $('#btnPrevious').click(function () { 
                var currentPage = getCurrentPageNumber();
                var totalPages = getTotalPages();

                if ((currentPage - 1) >= 1) {
                    Navigate(currentPage - 1);
                    $('#<%=lblCurrentPage.ClientID%>').html(currentPage - 1)
                }
            });
        });
        function getCurrentPageNumber()
        {
            return parseInt($('#<%=lblCurrentPage.ClientID%>').html());            
        }
        function getTotalPages()
        {
            return parseInt($('#<%= lblTotalPages.ClientID %>').html());
        }
        function Navigate(value) {  
            $.ajax({
                type: "POST",
                url: "index.aspx/GetPage",
                data: '{value: "' + value + '" }',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) { 
                    var $iframe = $('#container');
                    $iframe.attr('src', response.d); 
                },
                failure: function (response) {
                    alert("Failed: " + response.d);
                }
            }); 
        }
    </script>
</body>
</html>
