using System;
using System.Data;
using System.IO;
using System.Net;
using System.Net.Mail;
using System.Text;


namespace DailyReportsForManagers
{
    public static class Driver
    {
        static void Main(string[] args)
        {

            Boolean WeAreDebugging = false;

            /* --- Gmail Settings --- */
            const string mailServer = "smtp.gmail.com";
            const string userName = "info@lexxiom.com";
            const string passWord = "G>rU8LMn";

            /* --- Location of Log File --- */
            StringBuilder logfiletxt = new StringBuilder();
            String filepath = String.Format("C:\\Users\\SpruceWestAsus\\Desktop\\Lexxiom\\Projects_20190403\\Slf.Dms.Dev\\DailyReportsForManagers\\logging\\{1}_{0:yyyyMMdd_HHmmss}_", DateTime.Now, "DailyReportsForManagers");

            /* --- Start --- */
            RunJobs(mailServer, userName, passWord, ref logfiletxt, ref WeAreDebugging);


            /* Jobs Finished Create Log File If Debugging --- */
            if (logfiletxt.Length > 0)
            {
                File.AppendAllText(filepath + "log.txt", logfiletxt.ToString());
                logfiletxt.Clear();
            }
            /* --- Finish --- */
        }

        static void RunJobs(string mailServer, string userName, string passWord, ref StringBuilder logfiletxt, ref Boolean WeAreDebugging)
        {
            RunDailyNonDepositReport(mailServer, userName, passWord, ref logfiletxt, ref WeAreDebugging);
            RunDailyClientIntakeCalls(mailServer, userName, passWord, ref logfiletxt, ref WeAreDebugging);
            RunDailyIntakeFinancials(mailServer, userName, passWord, ref logfiletxt, ref WeAreDebugging);
        }

        #region jobs
        static void RunDailyNonDepositReport(string mailServer, string userName, string passWord, ref StringBuilder logfiletxt, ref Boolean WeAreDebugging)
        {

            Int32 reportID = 1;

            string employeeEmail = "cholt@lexxiom.com";

            if (WeAreDebugging)
            {
                logfiletxt.AppendLine(String.Format("{0:yyyyMMdd_HHmmss}: Starting Email for Daily Non Deposit Report", DateTime.Now));
                logfiletxt.AppendLine(String.Format("{0:yyyyMMdd_HHmmss}: Pulling Data for Daily Non Deposit Report", DateTime.Now));
            }

            if (!WeAreDebugging)
            {
                /* --- Grab all new clients and corresponding information to send text messages and emails. --- */
                DataTable dt = new DataTable();
                dt = SQLHelper.GetDataTable("stp_jobs_nondeposit_phoneburner");

                string bodyEmail = "";

                bodyEmail += "<html>";
                bodyEmail += "<body>"; 
                bodyEmail += "<table>";
                bodyEmail += "<tr>";
                bodyEmail += "<th>First Name</th>";
                bodyEmail += "<th>Last Name</th>";

                bodyEmail += "<th>Street</th>";
                bodyEmail += "<th>City</th>";
                bodyEmail += "<th>State</th>";
                bodyEmail += "<th>Zip Code</th>";
                bodyEmail += "<th>Email</th>";
                bodyEmail += "<th>Phone</th>";
                bodyEmail += "</tr>";
                
                foreach (DataRow row in dt.Rows)
                {
                    bodyEmail += "<tr>";
                    bodyEmail += String.Format("<td>{0}</td>", row["firstname"].ToString());
                    bodyEmail += String.Format("<td>{0}</td>", row["lastname"].ToString());
                    bodyEmail += String.Format("<td>{0}</td>", row["street"].ToString());
                    bodyEmail += String.Format("<td>{0}</td>", row["city"].ToString());
                    bodyEmail += String.Format("<td>{0}</td>", row["abbr"].ToString());
                    bodyEmail += String.Format("<td>{0}</td>", row["zipcode"].ToString());
                    bodyEmail += String.Format("<td>{0}</td>", row["email"].ToString());
                    bodyEmail += String.Format("<td>{0}</td>", row["phone"].ToString());
                    bodyEmail += "</tr>";
                }
                bodyEmail += "</table>";
                bodyEmail += "</body>";
                bodyEmail += "</html>";

                string DailyReportSubject = CreateEmailSubject(reportID);
                string DailyReportEmailBody = CreateEmailBody(reportID);
                SendEmailMessage(mailServer, userName, passWord, userName, employeeEmail, DailyReportSubject, DailyReportEmailBody, WeAreDebugging, ref logfiletxt, bodyEmail);
            }
            else
            {
                logfiletxt.AppendLine(String.Format("{0:yyyyMMdd_HHmmss}: ", DateTime.Now));
                logfiletxt.AppendLine(String.Format("{0:yyyyMMdd_HHmmss}: ", DateTime.Now));
            }
        }

        static void RunDailyClientIntakeCalls(string mailServer, string userName, string passWord, ref StringBuilder logfiletxt, ref Boolean WeAreDebugging)
        {

            Int32 reportID = 2;

            string employeeEmail = "cholt@lexxiom.com";

            if (WeAreDebugging)
            {
                logfiletxt.AppendLine(String.Format("{0:yyyyMMdd_HHmmss}: Starting Email for Daily Client Intake Calls Report", DateTime.Now));
                logfiletxt.AppendLine(String.Format("{0:yyyyMMdd_HHmmss}: Pulling Data for Daily Client Intake Calls Report", DateTime.Now));
            }

            if (!WeAreDebugging)
            {
                /* --- Grab all new clients and corresponding information to send text messages and emails. --- */
                DataTable dt = new DataTable();
                dt = SQLHelper.GetDataTable("stp_jobs_daily_intake_calls");

                string bodyEmail = "";

                bodyEmail += "< html >";
                bodyEmail += "< body >";
                bodyEmail += "< table >";
                foreach (DataRow row in dt.Rows)
                {
                    bodyEmail += "< tr >";
                    bodyEmail += String.Format("< td >{0}</ td >", row["fullname"].ToString());
                    bodyEmail += String.Format("< td >{0}</ td >", row["estCreated"].ToString());
                    bodyEmail += String.Format("< td >{0}</ td >", row["product"].ToString());
                    bodyEmail += String.Format("< td >{0}</ td >", row["leadphone"].ToString());
                    bodyEmail += String.Format("< td >{0}</ td >", row["homephone"].ToString());
                    bodyEmail += String.Format("< td >{0}</ td >", row["bizphone"].ToString());
                    bodyEmail += String.Format("< td >{0}</ td >", row["cellphone"].ToString());
                    bodyEmail += String.Format("< td >{0}</ td >", row["rep"].ToString());
                    bodyEmail += String.Format("< td >{0}</ td >", row["status"].ToString());
                    bodyEmail += "</ tr >";
                }
                bodyEmail += "</ table >";
                bodyEmail += "</ body >";
                bodyEmail += "</ html >";

                string DailyReportSubject = CreateEmailSubject(reportID);
                string DailyReportEmailBody = CreateEmailBody(reportID);
                SendEmailMessage(mailServer, userName, passWord, userName, employeeEmail, DailyReportSubject, DailyReportEmailBody, WeAreDebugging, ref logfiletxt, bodyEmail);
            }
            else
            {
                logfiletxt.AppendLine(String.Format("{0:yyyyMMdd_HHmmss}: ", DateTime.Now));
                logfiletxt.AppendLine(String.Format("{0:yyyyMMdd_HHmmss}: ", DateTime.Now));
            }
        }

        static void RunDailyIntakeFinancials(string mailServer, string userName, string passWord, ref StringBuilder logfiletxt, ref Boolean WeAreDebugging)
        {

            Int32 reportID = 3;

            string employeeEmail = "cholt@lexxiom.com";

            if (WeAreDebugging)
            {
                logfiletxt.AppendLine(String.Format("{0:yyyyMMdd_HHmmss}: Starting Email for Daily Intake Financials Report", DateTime.Now));
                logfiletxt.AppendLine(String.Format("{0:yyyyMMdd_HHmmss}: Pulling Data for Daily Intake Financials Report", DateTime.Now));
            }

            if (!WeAreDebugging)
            {
                /* --- Grab all new clients and corresponding information to send text messages and emails. --- */
                DataTable dt = new DataTable();
                dt = SQLHelper.GetDataTable("stp_jobs_intake_statistics_ron");

                string bodyEmail = "";

                bodyEmail += "< html >";
                bodyEmail += "< body >";
                bodyEmail += "< table >";
                foreach (DataRow row in dt.Rows)
                {
                    bodyEmail += "< tr >";
                    bodyEmail += String.Format("< td >{0}</ td >", row["userId"].ToString());
                    bodyEmail += String.Format("< td >{0}</ td >", row["full name"].ToString());
                    bodyEmail += String.Format("< td >{0}</ td >", row["year"].ToString());
                    bodyEmail += String.Format("< td >{0}</ td >", row["month"].ToString());
                    bodyEmail += String.Format("< td >{0}</ td >", row["leads"].ToString());
                    bodyEmail += String.Format("< td >{0}</ td >", row["working"].ToString());
                    bodyEmail += String.Format("< td >{0}</ td >", row["bad transfer"].ToString());
                    bodyEmail += String.Format("< td >{0}</ td >", row["transferred"].ToString());
                    bodyEmail += String.Format("< td >{0}</ td >", row["sent to attorney"].ToString());
                    bodyEmail += String.Format("< td >{0}</ td >", row["declined services"].ToString());
                    bodyEmail += "</ tr >";
                }
                bodyEmail += "</ table >";
                bodyEmail += "</ body >";
                bodyEmail += "</ html >";

                string DailyReportSubject = CreateEmailSubject(reportID);
                string DailyReportEmailBody = CreateEmailBody(reportID);
                SendEmailMessage(mailServer, userName, passWord, userName, employeeEmail, DailyReportSubject, DailyReportEmailBody, WeAreDebugging, ref logfiletxt, bodyEmail);
            }
            else
            {
                logfiletxt.AppendLine(String.Format("{0:yyyyMMdd_HHmmss}: Recording Data to Email Body", DateTime.Now));
                logfiletxt.AppendLine(String.Format("{0:yyyyMMdd_HHmmss}: Done Recording", DateTime.Now));
            }
        }
        #endregion

        static void SendEmailMessage(String mailserver, String userName, String passWord, String fromAddress, String toAddress, String subject, String body, Boolean WeAreDebugging, ref StringBuilder logfiletxt, string bodyEmail)
        {

            if (!WeAreDebugging)
            {
                SmtpClient client = new SmtpClient(mailserver, 587);

                MailMessage message = new MailMessage { };
                message.From = new MailAddress(fromAddress);
                message.To.Add(new MailAddress(toAddress));
                message.Subject = subject;
                message.Body = bodyEmail;
                message.IsBodyHtml = true;

                //Locates saved file
                try
                {
                    if (message.To.Count > 0)
                    {
                        NetworkCredential nc = new NetworkCredential(userName, passWord);
                        client.UseDefaultCredentials = false;
                        client.Credentials = nc;
                        client.DeliveryMethod = SmtpDeliveryMethod.Network;
                        client.EnableSsl = true;
                        client.Send(message);
                    }
                }
                catch (SystemException ex)
                {
                    logfiletxt.AppendLine(String.Format("{0:yyyyMMdd_HHmmss}: Error!: Sending Email Message: {1} ", DateTime.Now, ex.Message));
                    logfiletxt.AppendLine(String.Format("{0:yyyyMMdd_HHmmss}: Mail Server: {1}", DateTime.Now, mailserver));
                    logfiletxt.AppendLine(String.Format("{0:yyyyMMdd_HHmmss}: User Name: {1}", DateTime.Now, userName));
                    logfiletxt.AppendLine(String.Format("{0:yyyyMMdd_HHmmss}: Password: {1}", DateTime.Now, passWord));
                    logfiletxt.AppendLine(String.Format("{0:yyyyMMdd_HHmmss}: From Email: {1} ", DateTime.Now, fromAddress));
                    logfiletxt.AppendLine(String.Format("{0:yyyyMMdd_HHmmss}: Client Email: {1} ", DateTime.Now, toAddress));
                    logfiletxt.AppendLine(String.Format("{0:yyyyMMdd_HHmmss}: Message Subject: {1} ", DateTime.Now, subject));
                    logfiletxt.AppendLine(String.Format("{0:yyyyMMdd_HHmmss}: Message Body: {1} ", DateTime.Now, body));
                }
            }
            else
            {
                logfiletxt.AppendLine(String.Format("{0:yyyyMMdd_HHmmss}: Sending Email Message ", DateTime.Now));
                logfiletxt.AppendLine(String.Format("{0:yyyyMMdd_HHmmss}: Mail Server: {1}", DateTime.Now, mailserver));
                logfiletxt.AppendLine(String.Format("{0:yyyyMMdd_HHmmss}: User Name: {1}", DateTime.Now, userName));
                logfiletxt.AppendLine(String.Format("{0:yyyyMMdd_HHmmss}: Password: {1}", DateTime.Now, passWord));
                logfiletxt.AppendLine(String.Format("{0:yyyyMMdd_HHmmss}: From Email: {1} ", DateTime.Now, fromAddress));
                logfiletxt.AppendLine(String.Format("{0:yyyyMMdd_HHmmss}: Client Email: {1} ", DateTime.Now, toAddress));
                logfiletxt.AppendLine(String.Format("{0:yyyyMMdd_HHmmss}: Message Subject: {1} ", DateTime.Now, subject));
                logfiletxt.AppendLine(String.Format("{0:yyyyMMdd_HHmmss}: Message Body: {1} ", DateTime.Now, body));
            }
        }

        #region content
        static string CreateEmailSubject(Int32 reportID)
        {
            string subject = "";
            if (reportID == 1)
            {
                return subject = "Daily report for Non-Deposit";
            }
            else if (reportID == 2)
            {
                return subject = "Daily report for Client Intake Calls.";
            }
            else if (reportID == 3)
            {
                return subject = "Daily report for Daily Intake Financials.";
            }
            else
            {
                return subject;
            }
        }

        static string CreateEmailBody(Int32 reportID)
        {

            string body = "";
            if (reportID == 1)
            {
                return body = "Attached is the daily report for non-deposit. Enjoy!";
            }
            else if (reportID == 2)
            {
                return body = "Attached is the daily report for client intake calls. Enjoy!";
            }
            else if (reportID == 2)
            {
                return body = "Attached is the daily report for Daily Intake Financials. Enjoy!";
            }
            else
            {
                return body;
            }
        }
        #endregion
    }

}
