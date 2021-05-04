using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net;
using RestSharp;
using RestSharp.Authenticators;

namespace MailgunTEST
{
    class Program
    {
        static void Main(string[] args)
        {
           RestResponse response = new RestResponse();
            response = SendSimpleMessage();
        }

        public static RestResponse SendSimpleMessage()
        {
            RestClient client = new RestClient();
            System.Uri uri = new System.Uri("https://api.mailgun.net/v3");
            client.BaseUrl = uri;
            client.Authenticator =
                   new HttpBasicAuthenticator("api",
                                              "key-2315e473ce7ee0257b4b01f79ecb6143");
            RestRequest request = new RestRequest();
            request.AddParameter("domain",
                                "sandboxf704b05be61a4f2ebf9c21fecf64a44f.mailgun.org", ParameterType.UrlSegment);
            request.Resource = "{domain}/messages";
            request.AddParameter("from", "Mailgun Sandbox <postmaster@sandboxf704b05be61a4f2ebf9c21fecf64a44f.mailgun.org>");
            request.AddParameter("to", "Charles Castelo <ccastelo@lawfirmcs.com>");
            request.AddParameter("subject", "Hello Charles Castelo");
            request.AddParameter("text", "Congratulations Charles Castelo, you just sent an email with Mailgun!  You are truly awesome!  You can see a record of this email in your logs: https://mailgun.com/cp/log .  You can send up to 300 emails/day from this sandbox server.  Next, you should add your own domain so you can send 10,000 emails/month for free.");
            request.Method = Method.POST;
            return client.Execute(request);
        }
    
    }
}
