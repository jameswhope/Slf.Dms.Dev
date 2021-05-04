using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Drawing;
using System.IO;
using System.Text;
using System.Windows.Forms;

using Drg.Util.PGPHelper;

namespace Slf.Dms.ManualEncrypt
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void browseButton_Click(object sender, EventArgs e)
        {
            using (OpenFileDialog dialog = new OpenFileDialog())
            {
                if (dialog.ShowDialog() == DialogResult.OK)
                {
                    fileNameTextBox.Text = dialog.FileName;
                }
            }
        }

        private void encryptButton_Click(object sender, EventArgs e)
        {
            string publicKeyring = ConfigurationManager.AppSettings["publicKeyring"];
            string privateKeyring = ConfigurationManager.AppSettings["privateKeyring"];
            string passphrase = ConfigurationManager.AppSettings["passphrase"];

            PGPHelper.Initialize();

            string fileName = fileNameTextBox.Text;
            string pgpFileName = Path.Combine(Path.GetDirectoryName(fileName), Path.GetFileNameWithoutExtension(fileName)) + ".pgp";

            byte[] byteData = File.ReadAllBytes(fileName);

            byteData = PGPHelper.Encrypt(byteData, fileName, publicKeyring, privateKeyring, passphrase);

            File.WriteAllBytes(pgpFileName, byteData);
        }
    }
}