using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;

using Drg.Util;

namespace Slf.Dms.Service.BankImport
{
	/// <summary>
	/// Summary description for Form1.
	/// </summary>
	public class ImportMainForm : System.Windows.Forms.Form
	{
		private System.Windows.Forms.Label label3;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.Button importButton;
		private System.Windows.Forms.TextBox logTextBox;
		private System.Windows.Forms.TextBox databaseTextBox;
		private System.Windows.Forms.Button browseButton;
		private System.Windows.Forms.TextBox dataFileTextBox;
		private System.Windows.Forms.CheckBox runStoredProcCheckBox;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;

		public ImportMainForm()
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();

			//
			// TODO: Add any constructor code after InitializeComponent call
			//
		}

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			if( disposing )
			{
				if (components != null) 
				{
					components.Dispose();
				}
			}
			base.Dispose( disposing );
		}

		#region Windows Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.label3 = new System.Windows.Forms.Label();
			this.label2 = new System.Windows.Forms.Label();
			this.label1 = new System.Windows.Forms.Label();
			this.importButton = new System.Windows.Forms.Button();
			this.logTextBox = new System.Windows.Forms.TextBox();
			this.databaseTextBox = new System.Windows.Forms.TextBox();
			this.browseButton = new System.Windows.Forms.Button();
			this.dataFileTextBox = new System.Windows.Forms.TextBox();
			this.runStoredProcCheckBox = new System.Windows.Forms.CheckBox();
			this.SuspendLayout();
			// 
			// label3
			// 
			this.label3.AutoSize = true;
			this.label3.Location = new System.Drawing.Point(16, 136);
			this.label3.Name = "label3";
			this.label3.Size = new System.Drawing.Size(26, 16);
			this.label3.TabIndex = 5;
			this.label3.Text = "&Log:";
			// 
			// label2
			// 
			this.label2.AutoSize = true;
			this.label2.Location = new System.Drawing.Point(16, 48);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(97, 16);
			this.label2.TabIndex = 2;
			this.label2.Text = "&Connection String:";
			// 
			// label1
			// 
			this.label1.AutoSize = true;
			this.label1.Location = new System.Drawing.Point(16, 16);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(55, 16);
			this.label1.TabIndex = 0;
			this.label1.Text = "Bank &File:";
			// 
			// importButton
			// 
			this.importButton.Location = new System.Drawing.Point(192, 112);
			this.importButton.Name = "importButton";
			this.importButton.Size = new System.Drawing.Size(79, 23);
			this.importButton.TabIndex = 4;
			this.importButton.Text = "&Import";
			this.importButton.Click += new System.EventHandler(this.importButton_Click);
			// 
			// logTextBox
			// 
			this.logTextBox.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
				| System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.logTextBox.BackColor = System.Drawing.SystemColors.Window;
			this.logTextBox.Location = new System.Drawing.Point(16, 152);
			this.logTextBox.Multiline = true;
			this.logTextBox.Name = "logTextBox";
			this.logTextBox.ReadOnly = true;
			this.logTextBox.ScrollBars = System.Windows.Forms.ScrollBars.Both;
			this.logTextBox.Size = new System.Drawing.Size(420, 209);
			this.logTextBox.TabIndex = 6;
			this.logTextBox.Text = "";
			// 
			// databaseTextBox
			// 
			this.databaseTextBox.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.databaseTextBox.Location = new System.Drawing.Point(120, 48);
			this.databaseTextBox.Name = "databaseTextBox";
			this.databaseTextBox.Size = new System.Drawing.Size(316, 20);
			this.databaseTextBox.TabIndex = 3;
			this.databaseTextBox.Text = "";
			// 
			// browseButton
			// 
			this.browseButton.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
			this.browseButton.Location = new System.Drawing.Point(408, 16);
			this.browseButton.Name = "browseButton";
			this.browseButton.Size = new System.Drawing.Size(28, 23);
			this.browseButton.TabIndex = 9;
			this.browseButton.Text = "...";
			this.browseButton.Click += new System.EventHandler(this.browseButton_Click);
			// 
			// dataFileTextBox
			// 
			this.dataFileTextBox.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.dataFileTextBox.Location = new System.Drawing.Point(120, 16);
			this.dataFileTextBox.Name = "dataFileTextBox";
			this.dataFileTextBox.Size = new System.Drawing.Size(284, 20);
			this.dataFileTextBox.TabIndex = 1;
			this.dataFileTextBox.Text = "";
			// 
			// runStoredProcCheckBox
			// 
			this.runStoredProcCheckBox.Checked = true;
			this.runStoredProcCheckBox.CheckState = System.Windows.Forms.CheckState.Checked;
			this.runStoredProcCheckBox.Location = new System.Drawing.Point(120, 72);
			this.runStoredProcCheckBox.Name = "runStoredProcCheckBox";
			this.runStoredProcCheckBox.Size = new System.Drawing.Size(312, 24);
			this.runStoredProcCheckBox.TabIndex = 10;
			this.runStoredProcCheckBox.Text = "&Update transactions";
			// 
			// ImportMainForm
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(452, 374);
			this.Controls.Add(this.runStoredProcCheckBox);
			this.Controls.Add(this.label3);
			this.Controls.Add(this.label2);
			this.Controls.Add(this.label1);
			this.Controls.Add(this.logTextBox);
			this.Controls.Add(this.databaseTextBox);
			this.Controls.Add(this.dataFileTextBox);
			this.Controls.Add(this.importButton);
			this.Controls.Add(this.browseButton);
			this.Name = "ImportMainForm";
			this.Text = "Manual Import";
			this.Load += new System.EventHandler(this.ImportMainForm_Load);
			this.ResumeLayout(false);

		}
		#endregion

		private void ImportMainForm_Load(object sender, System.EventArgs e)
		{
			databaseTextBox.Text = ImportMain.ConnectionString;

			System.Diagnostics.Trace.Listeners.Add(new TextBoxTraceListener(logTextBox));
		}

		private void browseButton_Click(object sender, System.EventArgs e)
		{
			using (OpenFileDialog dialog = new OpenFileDialog())
			{
				dialog.InitialDirectory = ImportMain.FileLocation;

				if (dialog.ShowDialog(this) == DialogResult.OK)
				{
					dataFileTextBox.Text = dialog.FileName;
				}
			}		
		}

		private void importButton_Click(object sender, System.EventArgs e)
		{
			ImportMain.ImportFile(dataFileTextBox.Text, databaseTextBox.Text);

			if (runStoredProcCheckBox.Checked)
				ImportMain.ExecuteAfterImportStoredProc(databaseTextBox.Text);
		}
	}
}