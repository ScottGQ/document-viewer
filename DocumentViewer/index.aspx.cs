using GroupDocs.Viewer;
using GroupDocs.Viewer.Caching;
using GroupDocs.Viewer.Options;
using GroupDocs.Viewer.Results;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DocumentViewer
{
    public partial class index : System.Web.UI.Page
    {
        static string OutputPath;
        static string DocumentName = "sample.pptx";
        static string StorageFolder;
        static string CachePath;
        static FileCache cache;
        static ViewerSettings settings;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Set output directories
                OutputPath = Server.MapPath("~/output/"); 
                // Set storage folder where the source document is located
                StorageFolder = Server.MapPath("~/storage");
                // Set the cache path to keep the rendered images
                CachePath = Path.Combine(OutputPath, "cache");
                // Set cache
                cache = new FileCache(CachePath);
                settings = new ViewerSettings(cache);
                // Get document info
                GetDocumentInfo();
            }
        }

        private void GetDocumentInfo()
        {
            try
            {
                using (Viewer viewer = new Viewer(Path.Combine(StorageFolder, DocumentName), settings))
                {
                    ViewInfo info = viewer.GetViewInfo(ViewInfoOptions.ForPngView(false));  
                    lblTotalPages.Text = info.Pages.Count.ToString();
                }

            }
            catch
            {
                // Do something
            }
        }

        [System.Web.Services.WebMethod]
        public static string GetPage(string value)
        {
            int PageNumber = Convert.ToInt32(value);
            string PageFilePathFormat = Path.Combine(OutputPath, "img{0}.png");
            using (Viewer viewer = new Viewer(Path.Combine(StorageFolder, DocumentName)))
            {
                PngViewOptions options = new PngViewOptions(PageFilePathFormat);
                options.Width = 750;
                options.Height = 450; 

                viewer.View(options, PageNumber);
            } 

            return Path.Combine(@"output", string.Format("img{0}.png", PageNumber));

        } 
    }
}