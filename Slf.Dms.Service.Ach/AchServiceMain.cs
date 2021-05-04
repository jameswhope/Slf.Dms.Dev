using System;
using System.IO;
using Slf.Dms.Ach;

namespace Slf.Dms.Services.Ach
{
	/// <summary>
	/// Summary description for AchServiceMain.
	/// </summary>
	public class AchServiceMain
	{
		[STAThread]
		static void Main() 
		{
			TextWriter tw = File.CreateText(Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.DesktopDirectory), "ach1.dat"));

			NachaFile file = new NachaFile("062001319", "COLONIAL BANK", "1555555555", "INTRALINQ");

            NachaBatch batch = file.StartBatch(EntryClass.CashConcentrationDebit, "WITHDRAWL", "06200131", DateTime.Now.AddDays(1), DateTime.Now.AddDays(1));

			batch.AddEntry(TransactionCode.AutomatedDebitFromSavings, "123456789", "111111", 50, "A123", "Marge Simpson");

			file.End();

			file.Write(tw);

			tw.Close();

			tw = File.CreateText(Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.DesktopDirectory), "ach0.dat"));

            file = new NachaFile("062001319", "COLONIAL BANK", "1752892096", "INTRALINQ");

            batch = file.StartBatch(EntryClass.PreAuthorizedPaymentOrDeposit, "BLA BLA", "062001319", DateTime.Now.AddDays(1), DateTime.Now.AddDays(1));

            batch.AddEntry(TransactionCode.AutomatedDebitFromChecking, "067006432", "1010132147668", 50, "ID1", "Lessie May Flakes");
            batch.AddEntry(TransactionCode.AutomatedDebitFromChecking, "122000661", "1172403057", 100, "ID2", "Sally Pierson");
            batch.AddEntry(TransactionCode.AutomatedDebitFromChecking, "067006432", "1010087104578", 25, "ID3", "Robert Wadsworth");
            batch.AddEntry(TransactionCode.AutomatedDebitFromChecking, "067011142", "12003533208", 73, "ID4", "Roger H. Hegewald");
            batch.AddEntry(TransactionCode.AutomatedDebitFromChecking, "063100277", "003679736155", 25.33f, "ID5", "Freddie Garrett");
            batch.AddEntry(TransactionCode.AutomatedDebitFromChecking, "267084131", "1801988453", 50, "ID6", "Claire Iorio (Westbay)");
			
            file.End();

			file.Write(tw);

			tw.Close();
		}
	}
}
