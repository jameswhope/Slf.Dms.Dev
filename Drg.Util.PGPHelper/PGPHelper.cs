using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Text;
using System.Threading;

using SBPGP;
using SBPGPConstants;
using SBPGPKeys;
using SBUtils;
using SBPGPStreams;

using SBMIMEUtils;
using SBMIME;
using SBMIMEStream;
using SBPGPMIME;

namespace Drg.Util.PGPHelper
{
    public class PGPHelper
    {
        static string _passphrase;

        private PGPHelper()
        {
        }

        public static void Initialize()
        {
            string blackBoxKey = ConfigurationManager.AppSettings["blackBoxKey"];

            if (string.IsNullOrEmpty(blackBoxKey))
                blackBoxKey = "0375F798E0FE4841F7BE6108C9380091070D223C95716FD7E54DC5AFAD2E1D9967B9D98111447F1EE1D63240089ECB469970710E9F35931A84012A4B0D6AA9A357353EF5B0B4B8C98A994347D93E3076EC5BEA10EB95A531D8FCFAC2295ECD59A495BE4E450C52AC431A274BE4B0B3122C7FF0E02FB9FD0CEB4094B98D290BC55BFD63A36D0EB355098F4B5A84FC333F1A8B932DBB86EFBAC8AD563ECA18851934F129370919B8683B88075A6980D1B0F850761DBFBBE44DAA788355CBF4C6B682EF8FF3894BD6D469A40E6DC8433C30FC6D8CBEB59DBA0E8DAEBA6DDFC04C8F78BD81385973AEE50C652F66A91888A37FCA08DF1CD730C4E55B6700DD1BB14D";

            SBUtils.Unit.SetLicenseKey(SBUtils.Unit.BytesOfString(blackBoxKey));
        }

        public static byte[] Encrypt(byte[] data, string fileName, string publicKeyring, string privateKeyring, string passphrase)
        {
            _passphrase = passphrase;

            using (TElPGPWriter pgpWriter = new TElPGPWriter())
            using (TElPGPKeyring keyring = new TElPGPKeyring())
            using (TElPGPKeyring pubKeyring = new TElPGPKeyring())
            using (TElPGPKeyring secKeyring = new TElPGPKeyring())
            {
                keyring.Load(publicKeyring, privateKeyring, true);

                // Assume we're using the first key in each
                pubKeyring.AddPublicKey(keyring.get_PublicKeys(0));
                secKeyring.AddSecretKey(keyring.get_SecretKeys(0));

                //pgpWriter.Armor = true;
                //pgpWriter.ArmorHeaders.Clear();
                //pgpWriter.ArmorHeaders.Add("Version: EldoS PGPBlackbox (.NET edition)");
                //pgpWriter.ArmorBoundary = "PGP MESSAGE";
                
                //pgpWriter.InputIsText = true;
                //pgpWriter.TextCompatibilityMode = true;

                //pgpWriter.Compress = cbCompress.Checked;
                pgpWriter.EncryptingKeys = pubKeyring;
                pgpWriter.SigningKeys = secKeyring;

                pgpWriter.OnKeyPassphrase += new SBPGPStreams.TSBPGPKeyPassphraseEvent(pgpWriter_OnKeyPassphrase);

                /*                if ((cbUseConvEnc.Checked) && (pubKeyring.PublicCount > 0))
                                {
                                    pgpWriter.EncryptionType = SBPGP.TSBPGPEncryptionType.etBoth;
                                }
                                else if ((cbUseConvEnc.Checked) && (pubKeyring.PublicCount == 0))
                                {
                                    pgpWriter.EncryptionType = SBPGP.TSBPGPEncryptionType.etPassphrase;
                                }
                                else
                                {*/
                pgpWriter.EncryptionType = TSBPGPEncryptionType.etPublicKey;
                //}
                //info = new System.IO.FileInfo(SourceFile);
                pgpWriter.Filename = fileName;
                pgpWriter.InputIsText = true;

                //pgpWriter.Passphrases.Clear();
                //pgpWriter.Passphrases.Add(tbPassphrase.Text);

                /*switch (cbProtLevel.SelectedIndex)
                {
                    case 0:
                        pgpWriter.Protection = SBPGPConstants.TSBPGPProtectionType.ptLow;
                        break;
                    case 1:
                        pgpWriter.Protection = SBPGPConstants.TSBPGPProtectionType.ptNormal;
                        break;
                    default:*/
                pgpWriter.Protection = TSBPGPProtectionType.ptHigh;
                //break;
                //}
                pgpWriter.SignBufferingMethod = TSBPGPSignBufferingMethod.sbmRewind;
                /*switch (this.cbEncryptionAlg.SelectedIndex)
                {
                    case 0:*/
                //pgpWriter.SymmetricKeyAlgorithm = SBPGPConstants.Unit.SB_PGP_ALGORITHM_SK_CAST5;
                //                        break;
                //                    case 1:
                //                        pgpWriter.SymmetricKeyAlgorithm = SBPGPConstants.Unit.SB_PGP_ALGORITHM_SK_3DES;
                //                        break;
                //                    case 2:
                                        pgpWriter.SymmetricKeyAlgorithm = SBPGPConstants.Unit.SB_PGP_ALGORITHM_SK_AES128;
                /*                        break;
                                    default:
                                        pgpWriter.SymmetricKeyAlgorithm = SBPGPConstants.Unit.SB_PGP_ALGORITHM_SK_AES256;
                                        break;
                                }*/
                pgpWriter.Timestamp = DateTime.Now;
                pgpWriter.UseNewFeatures = true;
                pgpWriter.UseOldPackets = false;
                
                using (MemoryStream inS = new MemoryStream(data))
                using (MemoryStream outS = new MemoryStream())
                {
                    pgpWriter.Encrypt(inS, outS, 0);

                    string base64 = Convert.ToBase64String(outS.ToArray(), Base64FormattingOptions.InsertLineBreaks);

                    string pgp = "-----BEGIN PGP MESSAGE-----\r\nVersion: DRG PGP v1.1\r\n\r\n" + base64 + "\r\n-----END PGP MESSAGE-----";

                    return Encoding.ASCII.GetBytes(pgp);
                }
            }
        }

        public static byte[] EncryptMIME(byte[] data, string fileName, string publicKeyring, string privateKeyring, string passphrase)
        {
            TElMessage msg = null;
            TElPlainTextPart mpt = null;
            TElMessagePart mpc = null;
            TElMultiPartList mmp = null;

            TElPGPWriter writer;

            using (TElPGPKeyring keyring = new TElPGPKeyring())
            //using (TElPGPKeyring pubKeyring = new TElPGPKeyring())
            //using (TElPGPKeyring secKeyring = new TElPGPKeyring())
            {
                keyring.Load("", publicKeyring, true);

                // Assume we're using the first key in each
                //pubKeyring.AddPublicKey(keyring.get_PublicKeys(0));
                //secKeyring.AddSecretKey(keyring.get_SecretKeys(0));

                msg = new TElMessage(false, SBMIME.Unit.cXMailerDefaultFieldValue);
               
                mpt = new TElPlainTextPart(msg, mmp);
                msg.SetMainPart(mpt, false);
                mpt.SetText(Encoding.ASCII.GetString(data));
                
                /*msg.From.AddAddress("From e-mail: "+textBox_from.Text, textBox_from.Text);
                msg.To_.AddAddress("To e-mail: " + textBox_to.Text, textBox_to.Text);
                msg.SetSubject(textBox_subject.Text);*/
                msg.SetSubject("test");
                msg.SetDate( System.DateTime.Now );
                msg.To_.AddAddress("To e-mail: " + keyring.get_PublicKeys(0).get_UserIDs(0).Name, keyring.get_PublicKeys(0).get_UserIDs(0).Name);
                msg.MessageID = TElMessage.GenerateMessageID();


                TElMessagePartHandlerPGPMime pgpmime = new TElMessagePartHandlerPGPMime(null);

                msg.MainPart.MessagePartHandler = pgpmime;

                pgpmime.EncryptingKeys = keyring;
                pgpmime.Encrypt = true;
                //pgpmime.
                pgpmime.OnKeyPassphrase += new SBPGPStreams.TSBPGPKeyPassphraseEvent(pgpWriter_OnKeyPassphrase);
                

                TAnsiStringStream sm = new TAnsiStringStream();

                msg.MainPart.SetContentType(null, true);
                msg.MainPart.SetContentTransferEncoding(null, true);

                int res = msg.AssembleMessage(sm,
                    // Charset of message:
                  "utf-8",
                    // HeaderEncoding
                  SBMIME.TElHeaderEncoding.heBase64, //  variants:  he8bit  | heQuotedPrintable  | heBase64
                    // BodyEncoding
                  "8bit", //  variants:   '8bit' | 'quoted-printable' |  'base64'
                    // AttachEncoding
                  "base64", //  variants:   '8bit' | 'quoted-printable' |  'base64'
                  false
                );

                //using (MemoryStream ms = new MemoryStream())
                //{
                    //sm.SaveToStream(ms, 0);

                    //byte[] outputData = ms.ToArray();

                    string text = sm.AnsiData.ToString();// Encoding.UTF8.GetString(outputData);

                    int start = text.IndexOf("-----BEGIN PGP MESSAGE-----");
                    int end = text.IndexOf("-----END PGP MESSAGE-----");

                    return Encoding.UTF8.GetBytes(text.Substring(start, end - start + "-----END PGP MESSAGE-----".Length));
                //}
            }
        }

        static void pgpWriter_OnKeyPassphrase(object Sender, TElPGPCustomSecretKey Key, ref string Passphrase, ref bool Cancel)
        {
            Passphrase = _passphrase;
            Cancel = false;
        }
    }
}