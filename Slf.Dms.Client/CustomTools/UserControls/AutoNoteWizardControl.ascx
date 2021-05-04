<%@ Control Language="VB" AutoEventWireup="false" CodeFile="AutoNoteWizardControl.ascx.vb"
    Inherits="CustomTools_UserControls_AutoNoteWizardControl" %>
<style type="text/css">
    .wzStyle
    {
    BackColor:#EFF3FB;
    BorderColor:#B5C7DE;
    BorderWidth:1px;
    Font-Names:Tahoma;
    Height:400px;
    Width:95%;
    }
   
    </style>    
    
<div style="width: 100%; height: 100%">
    <asp:Wizard ID="wzNotes" CssClass="wzStyle" runat="server" ActiveStepIndex="0" DisplayCancelButton="True"
        FinishCompleteButtonText="Process Notes">
        <WizardSteps>
            <asp:WizardStep ID="wsGetVariables" runat="server" Title="Getting Started" StepType="Start">
                <h3>
                    <span style="font-size: 11pt; font-family: Tahoma">This wizard will guide you thru building
                        the notes that accompany the documents you selected for printing.<br />
                        <br />
                        Each step will show the variable text for each note template.&nbsp; Enter all required
                        information.<br />
                        Please press the [Next] button to start.</span></h3>
            </asp:WizardStep>
            <asp:WizardStep ID="wsDisplayNote" runat="server" Title="Finish Note" StepType="Finish">
            </asp:WizardStep>
        </WizardSteps>
        <StepStyle Font-Size="0.8em" ForeColor="#333333" VerticalAlign="Top" />
        <SideBarStyle BackColor="SteelBlue" Font-Size="X-Small" VerticalAlign="Top" Width="35%"
            HorizontalAlign="Left" />
        <NavigationButtonStyle Font-Names="tahoma" Font-Size="Medium" />
        <SideBarButtonStyle BackColor="SteelBlue" Font-Names="tahoma" ForeColor="White" />
        <HeaderStyle BackColor="#284E98" BorderColor="#EFF3FB" BorderStyle="Solid" BorderWidth="2px"
            Font-Bold="True" Font-Size="0.9em" ForeColor="White" HorizontalAlign="Center" />
        <StepNavigationTemplate>
            <table width="50%">
                <tr>
                    <td>
                        <asp:LinkButton CssClass="lnk" ID="StepPreviousButton" runat="server" CausesValidation="False"
                            CommandName="MovePrevious" Text="Previous" />
                    </td>
                    <td>
                        <asp:LinkButton CssClass="lnk" ID="StepNextButton" runat="server" CommandName="MoveNext"
                            Text="Next" />
                    </td>
                    <td>
                        <asp:LinkButton CssClass="lnk" ID="CancelButton" runat="server" CausesValidation="False"
                            CommandName="Cancel" Text="Cancel" />
                    </td>
                </tr>
            </table>
        </StepNavigationTemplate>
        <StartNavigationTemplate>
            <table width="50%">
                <tr>
                    <td style="width: 23px; height: 26px">
                        <asp:LinkButton CssClass="lnk" ID="StartNextButton" runat="server" CommandName="MoveNext"
                            Text="Next" />
                    </td>
                    <td style="height: 26px">
                        <asp:LinkButton CssClass="lnk" ID="CancelButton" runat="server" CausesValidation="False"
                            CommandName="Cancel" Text="Cancel" />
                    </td>
                </tr>
            </table>
        </StartNavigationTemplate>
    </asp:Wizard>
</div>
