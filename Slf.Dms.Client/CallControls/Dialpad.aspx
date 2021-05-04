<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Dialpad.aspx.vb" Inherits="CallControls_Dialpad" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Dial Pad</title>
    <style type="text/css"  >
        .backg{background-color: #C4C6FF; }
        .phonekey{ border-color:Black; border-style:solid; border-width: 2px; font-family: Tahoma; font-size: 8px; width: 40px; height: 40px; text-align:center; background-color:  #CCCCCC; color: Black; cursor: hand;}
        .phonekey table { margin: 0px; }
        .phoneUpper{font-family: Tahoma; font-size: 14px; text-align: center; }
        .phonekey:hover {background-color: Blue; color: White;    }
        .digitclass: {font-family: Tahoma; font-size: 11px; text-align: center;}
    </style>
    <script type="text/javascript" >
        function dial(n) {
            document.getElementById('digits').value = document.getElementById('digits').value + n;
            var parentW = window.dialogArguments;
            parentW.dialpad(n); 
        }
    </script>   
</head>
<body class="backg" >
    <form id="form1" runat="server">
    <div style="width: 160px;">
        <table cellpadding="3">
            <tr>
                <td colspan="3" >
                    <input id="digits" type="text" readonly="readonly"  class="digitclass"/>  
                </td>
            </tr>
            <tr>
                <td>
                    <div class="phonekey" onclick="dial('1');">
                        <table >
                            <tr><td colspan="3" class="phoneUpper" >1</td></tr>
                            <tr><td>_</td><td>.</td><td>@</td></tr>
                        </table> 
                    </div>
                </td>
                <td>
                    <div class="phonekey" onclick="dial('2');">
                        <table >
                            <tr><td colspan="3"  class="phoneUpper">2</td></tr>
                            <tr><td>A</td><td>B</td><td>C</td></tr>
                        </table> 
                    </div>
                </td>
                <td>
                    <div class="phonekey" onclick="dial('3');">
                        <table >
                            <tr><td colspan="3"  class="phoneUpper">3</td></tr>
                            <tr><td>D</td><td>E</td><td>F</td></tr>
                        </table> 
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <div class="phonekey" onclick="dial('4');">
                        <table >
                            <tr><td colspan="3" class="phoneUpper">4</td></tr>
                            <tr><td>G</td><td>H</td><td>I</td></tr>
                        </table> 
                    </div>
                </td>
                <td>
                    <div class="phonekey" onclick="dial('5');">
                        <table >
                            <tr><td colspan="3"  class="phoneUpper">5</td></tr>
                            <tr><td>J</td><td>K</td><td>L</td></tr>
                        </table> 
                    </div>
                </td>
                <td>
                    <div class="phonekey" onclick="dial('6');">
                        <table >
                            <tr><td colspan="3"  class="phoneUpper">6</td></tr>
                            <tr><td>M</td><td>N</td><td>O</td></tr>
                        </table> 
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <div class="phonekey" onclick="dial('7');">
                        <table >
                            <tr><td colspan="4" class="phoneUpper">7</td></tr>
                            <tr><td>P</td><td>Q</td><td>R</td><td>S</td></tr>
                        </table> 
                    </div>
                </td>
                <td>
                    <div class="phonekey" onclick="dial('8');">
                        <table >
                            <tr><td colspan="3"  class="phoneUpper">8</td></tr>
                            <tr><td>T</td><td>U</td><td>V</td></tr>
                        </table> 
                    </div>
                </td>
                <td>
                    <div class="phonekey" onclick="dial('9');">
                        <table >
                            <tr><td colspan="4"  class="phoneUpper" >9</td></tr>
                            <tr><td>W</td><td>X</td><td>Y</td><td>Z</td></tr>
                        </table> 
                    </div>
                </td>
            </tr>
             <tr>
                <td>
                    <div class="phonekey" onclick="dial('*');">
                        <table >
                            <tr><td class="phoneUpper" >*</td></tr>
                        </table> 
                    </div>
                </td>
                <td>
                    <div class="phonekey" onclick="dial('0');">
                        <table >
                            <tr><td class="phoneUpper">0</td></tr>
                        </table> 
                    </div>
                </td>
                <td>
                    <div class="phonekey" onclick="dial('#');">
                        <table >
                            <tr><td class="phoneUpper" >#</td></tr>
                        </table> 
                    </div>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
