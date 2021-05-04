using System;
using System.Web;
using System.Web.UI;
using System.Configuration;
using System.Reflection;
using System.Diagnostics;
using aspNetEmail;
using System.IO;

namespace Drg.Utilities
{
    [ToolboxData("<{0}:ErrorHandler runat=server></{0}:ErrorHandler>")]
    public class ErrorHandler : System.Web.UI.Control
    {
        private Page _errorControl;
        private bool findPage;
        private string _app = "A DRG Application";

        #region Constructor
        public ErrorHandler(string App, Page ErrorControl)
        {
            _errorControl = ErrorControl;
            _errorControl.Error += new System.EventHandler(this.Page_Error);
            _app = App;
        }

        public ErrorHandler(string App)
        {
            _app = App;
            findPage = true;
        }
        public ErrorHandler()
        {
            findPage = true;
        }
        #endregion
        #region Property
        public Page ErrorControl
        {
            set
            {
                _errorControl = value;
            }
            get
            {
                return _errorControl;
            }
        }
        public String App
        {
            set
            {
                _app = value;
            }
            get
            {
                return _app;
            }
        }
        #endregion     
        #region Command
        private void HandleError(string errorMessage, string errorUrl, string errorLine, string location)
        {
            string Message = errorMessage + "\r\n\r\nLocation:  " + location + "\r\nURL:  " + errorUrl;
            if (!string.IsNullOrEmpty(errorLine))
                Message += "\r\nLine:  " + errorLine;
            EmailMessage msg = new EmailMessage();
            msg.LogOverwrite = true;
            msg.Logging = false;
            msg.LogInMemory = false;
            msg.LogBody = false;
            msg.LogExceptionToEventLog = false;
            msg.FromName = _app + " Error Handler";
            msg.FromAddress = "noreply.errorhandling@datarg.com";
            msg.ReplyTo = "noreply.errorhandling@datarg.com";
            msg.Importance = MailPriority.None;
            msg.Subject = "An unhandled exception has occured in " + _app;
            msg.Body = Message;
            msg.BodyFormat = MailFormat.Text;
            msg.ValidateAddress = false;
            msg.Server = ConfigurationSettings.AppSettings["EmailSMTP"];
            msg.Username = ConfigurationSettings.AppSettings["EmailUserName"];
            msg.Password = ConfigurationSettings.AppSettings["EmailPassword"];

            try
            {
                msg.TimeOut = int.Parse(ConfigurationSettings.AppSettings["EmailTimeout"]);
            }
            catch
            {
                msg.TimeOut = 0;
            }

            string[] emails = ConfigurationSettings.AppSettings["OnErrorEmailTo"].Split(',');

            if (emails.Length > 0)
                for (int i = 0; i < emails.Length; i++)
                {
                    msg.AddTo(emails[i]);
                }

           // if (!IsDebugMode(_errorControl.GetType().Assembly))
            //{
                msg.Send();
           // }

        } 
        #endregion
        #region Event
        protected override void OnInit(EventArgs e)
        {
            this.Load += new System.EventHandler(CheckForClientError);

            if (findPage)
            {
                try
                {
                    _errorControl = this.Page;
                    _errorControl.Error += new System.EventHandler(this.Page_Error);
                }
                catch (Exception ex)
                {
                    //do nothing
                }
            }

            if (_errorControl != null)
            {
                string sScript = "window.onerror=window_onerror;function window_onerror(message,url,lineNumber){var queryString='?onerror_message='+escape(message)+'&onerror_url='+escape(url)+'&onerror_lineNumber='+lineNumber;var onerrorImage=new Image();onerrorImage.src=queryString;return true;}";
                if (!_errorControl.ClientScript.IsStartupScriptRegistered("ehClientScript"))
                    _errorControl.ClientScript.RegisterStartupScript(_errorControl.GetType(), "ehClientScript", sScript, true);
            }

        }

        protected void Page_Error(object sender, System.EventArgs e)
        {
            HandleError(this.Page.Server.GetLastError().ToString(), this.Page.Request.Url.AbsoluteUri.ToString(), "", "Server-Side");
        }
        protected void CheckForClientError(object sender, System.EventArgs e)
        {
            string errorMessage = this.Page.Request.QueryString["onerror_message"];
            if (errorMessage != null && errorMessage.Length > 0)
            {
                string errorLine = this.Page.Request.QueryString["onerror_linenumber"];
                string errorUrl = this.Page.Request.QueryString["onerror_url"];
                HandleError(errorMessage, errorUrl, errorLine, "Client-Side");
            }
        }
        #endregion
        #region Utility
        private static bool IsDebugMode(Assembly ass)
        {
            object[] atts = ass.GetCustomAttributes(typeof(DebuggableAttribute), true);
            if (atts.Length == 0)
            {
                Console.WriteLine("This is a Release Configuration");
                return false;
            }

            DebuggableAttribute da = atts[0] as DebuggableAttribute;
            if (da != null)
            {
                bool standardDebugBuild = da.IsJITOptimizerDisabled && da.IsJITTrackingEnabled;
                Console.WriteLine("Standard DebugBuild = {0}", standardDebugBuild);
                return true;
            }
            return false;
        }
        #endregion
    }
}
