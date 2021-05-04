using System;
using System.Diagnostics;
using System.Text;
using System.Windows.Forms;

namespace Drg.Util
{
	/// <summary>
	/// Summary description for TextBoxTraceListener.
	/// </summary>
	public class TextBoxTraceListener : TraceListener
	{
		TextBox _output;

		public TextBoxTraceListener(TextBox output)
		{
			_output = output;
		}

		//StringBuilder sb = new StringBuilder();

		public override void Write(string message)
		{
            if (message != null)
            {
                _output.AppendText(message);
                _output.SelectionStart = _output.Text.Length;
                _output.ScrollToCaret();
            }
			//sb.Append(message);
		}

		public override void WriteLine(string message)
		{
			WriteIndent();
			Write(message);
            Write(Environment.NewLine);
		}

	}
}
