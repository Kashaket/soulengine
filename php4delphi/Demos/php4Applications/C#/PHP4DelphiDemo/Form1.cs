using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Text;
using System.Data;
using System.Runtime.InteropServices;



namespace PHP4DelphiDemo
{
	/// <summary>
	/// Summary description for Form1.
	/// </summary>
	public class Form1 : System.Windows.Forms.Form
	{
        private System.Windows.Forms.TextBox textBox1;
		private System.Windows.Forms.OpenFileDialog openFileDialog1;
        private Panel panel1;
        private Button btnExecuteScript;
        private Button btnExecuteCode;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;

		public Form1()
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
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
            this.panel1 = new System.Windows.Forms.Panel();
            this.btnExecuteScript = new System.Windows.Forms.Button();
            this.btnExecuteCode = new System.Windows.Forms.Button();
            this.panel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // textBox1
            // 
            this.textBox1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.textBox1.Location = new System.Drawing.Point(0, 0);
            this.textBox1.Multiline = true;
            this.textBox1.Name = "textBox1";
            this.textBox1.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.textBox1.Size = new System.Drawing.Size(326, 197);
            this.textBox1.TabIndex = 0;
            // 
            // openFileDialog1
            // 
            this.openFileDialog1.Filter = "PHP files|*.php";
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.btnExecuteCode);
            this.panel1.Controls.Add(this.btnExecuteScript);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.panel1.Location = new System.Drawing.Point(0, 197);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(326, 49);
            this.panel1.TabIndex = 2;
            // 
            // btnExecuteScript
            // 
            this.btnExecuteScript.Location = new System.Drawing.Point(12, 12);
            this.btnExecuteScript.Name = "btnExecuteScript";
            this.btnExecuteScript.Size = new System.Drawing.Size(94, 23);
            this.btnExecuteScript.TabIndex = 2;
            this.btnExecuteScript.Text = "Execute Script";
            // 
            // btnExecuteCode
            // 
            this.btnExecuteCode.Location = new System.Drawing.Point(112, 12);
            this.btnExecuteCode.Name = "btnExecuteCode";
            this.btnExecuteCode.Size = new System.Drawing.Size(96, 23);
            this.btnExecuteCode.TabIndex = 3;
            this.btnExecuteCode.Text = "Execute Code";
            this.btnExecuteCode.UseVisualStyleBackColor = true;
            this.btnExecuteCode.Click += new System.EventHandler(this.btnExecuteCode_Click);
            // 
            // Form1
            // 
            this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
            this.ClientSize = new System.Drawing.Size(326, 246);
            this.Controls.Add(this.textBox1);
            this.Controls.Add(this.panel1);
            this.Name = "Form1";
            this.Text = "PHP";
            this.panel1.ResumeLayout(false);
            this.ResumeLayout(false);
            this.PerformLayout();

		}
		#endregion

		/// <summary>
		/// The main entry point for the application.
		/// </summary>
		[STAThread]
		static void Main() 
		{
			Application.Run(new Form1());
		}

		private void button1_Click(object sender, System.EventArgs e)
		{
			int l = 0;
			int RequestID = 0;
			StringBuilder builder = new  StringBuilder();

			if(openFileDialog1.ShowDialog() == DialogResult.OK)
			{
				RequestID = InitRequest();
				string fn = openFileDialog1.FileName;
				ExecutePHP(RequestID, fn);
				l = GetResultBufferSize(RequestID);
				builder.Capacity = l;
				l = GetResultText(RequestID, builder, builder.Capacity + 1);
				textBox1.Text = builder.ToString();
				DoneRequest(RequestID);
			}

			
		}

		
		[DllImport("PHP4App.dll")]
		public static extern int InitRequest();
		
		/// <summary>
		/// Execute PHP script
		/// </summary>
		[DllImport("PHP4App.dll")]
		public static extern int ExecutePHP(int RequestID, string FileName);
		
		[DllImport("PHP4App.dll", SetLastError=true)]
		public static extern void DoneRequest(int RequestID);

		[DllImport("PHP4App.dll", SetLastError=true)]
		public static extern int GetResultText(int RequestID, StringBuilder Buf, int BufLen);

		[DllImport("PHP4App.dll")]
        public static extern void RegisterVariable(int RequestID, string AName, string AValue);

		[DllImport("PHP4App.dll")]
        public static extern int ExecuteCode(int RequestID, string ACode);

		[DllImport("PHP4App.dll")]
        public static extern int GetVariable(int RequestID, string AName, StringBuilder Buffer, int BufLen);

		[DllImport("PHP4App.dll")]
        public static extern int SaveToFile(int RequestID, string AFileName);
        
		[DllImport("PHP4App.dll")]
        public static extern int GetVariableSize(int RequestID, string AName);

        [DllImport("PHP4App.dll")]
        public static extern int GetResultBufferSize(int RequestID);

        private void btnExecuteCode_Click(object sender, EventArgs e)
        {
            int l = 0;
            int RequestID = 0;
            StringBuilder builder = new StringBuilder();
            StringBuilder varbuilder = new StringBuilder();

            RequestID = InitRequest();
            RegisterVariable(RequestID, "x","2");
            RegisterVariable(RequestID, "y","3");
            RegisterVariable(RequestID, "z","0");
            ExecuteCode(RequestID, "$z =  $x + $y; echo \"Result \"; echo $z;");
            l = GetResultBufferSize(RequestID);
            if (l > 0)
            {
                builder.Capacity = l;
                GetResultText(RequestID, builder, builder.Capacity + 1);
                textBox1.Text =  builder.ToString();
            }

            l = GetVariableSize(RequestID, "z");
            if (l > 0)
            {
                varbuilder.Capacity = l;
                GetVariable(RequestID, "z", varbuilder, varbuilder.Capacity + 1);
                MessageBox.Show(String.Concat("After execution z=", varbuilder.ToString()));
            }
            DoneRequest(RequestID);
        }
		
	}
}
