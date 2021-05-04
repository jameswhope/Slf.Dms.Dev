using System;
using System.IO;

namespace Slf.Dms.Ach
{
	/// <summary>
	/// Summary description for StringHelper.
	/// </summary>
	public sealed class StringHelper
	{
		private StringHelper()
		{}


		public static void Pad(TextWriter writer, string str, int length)
		{
			Pad(writer, str, length, ' ');
		}

		public static void Pad(TextWriter writer, string str, int length, char padChar)
		{
			if (str != null)
				length -= str.Length;

			for (int i = 0; i < length; i++)
				writer.Write(padChar);
		}

        public static void ForceTo(TextWriter writer, string str, int length)
        {
            if (str != null && str.Length > length)
            {
                writer.Write(str.Substring(0, length));
            }
            else
            {
                writer.Write(str);

                Pad(writer, str, length);
            }
        }
	}
}