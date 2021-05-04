var MouseIsDown = false;

var ASI_DR_Months = new Array("January","Feburary","March","April","May","June","July","August","September","October","November","December");

function ASI_DR_ControlOut(ctl)
{
	if (MouseIsDown)
	{
		if (ASI_DR_ControlIsReallyOut(ctl))
		{
			MouseIsDown = false;

			ctl.removeAttribute("drStartDaySel");
			ctl.removeAttribute("drStartMonthSel");
			ctl.removeAttribute("drStartYearSel");

			ctl.removeAttribute("drEndDaySel");
			ctl.removeAttribute("drEndMonthSel");
			ctl.removeAttribute("drEndYearSel");

			ASI_DR_DressSelected(ctl);
		}
	}
}
function ASI_DR_ControlIsReallyOut(ctl, e)
{
	var MouseX = 0;
	var MouseY = 0;

	var ControlX = ASI_DR_FindX(ctl);
	var ControlY = ASI_DR_FindY(ctl);

	var ControlR = ControlX + ctl.offsetWidth;
	var ControlB = ControlY + ctl.offsetHeight;

	if (!e)
	{
		MouseX = event.clientX + document.body.scrollLeft;
		MouseY = event.clientY + document.body.scrollTop;
	}
	else
	{
		MouseX = e.pageX;
		MouseY = e.pageY;
	}

	if (MouseX < 0) {MouseX = 0;}
	if (MouseY < 0) {MouseY = 0;}

	if ((ControlX <= MouseX && ControlY <= MouseY) && (MouseX <= ControlR && MouseY <= ControlB))
	{
		return false;
	}
	else
	{
		return true;
	}
}
function ASI_DR_MouseDown(day)
{
	if (day.getAttribute("drvalid").toLowerCase() == "true")
	{
		MouseIsDown = true;

		var cal = ASI_DR_GetCalendarFromDay(day);
		var ctl = ASI_DR_GetControlFromCalendar(cal);

		ctl.setAttribute("drStartDaySel", day.getAttribute("drday"));
		ctl.setAttribute("drStartMonthSel", cal.getAttribute("drmonth"));
		ctl.setAttribute("drStartYearSel", cal.getAttribute("dryear"));

		ctl.setAttribute("drEndDaySel", day.getAttribute("drday"));
		ctl.setAttribute("drEndMonthSel", cal.getAttribute("drmonth"));
		ctl.setAttribute("drEndYearSel", cal.getAttribute("dryear"));

		ASI_DR_StopEventPropagation();
	}
}
function ASI_DR_MouseOver(day)
{
	var ctl = ASI_DR_GetControlFromDay(day);

	if (MouseIsDown)
	{
		if (day.getAttribute("drvalid").toLowerCase() == "true")
		{
			var cal = ASI_DR_GetCalendarFromDay(day);

			// assign day (hovering over) as select end
			ctl.setAttribute("drEndDaySel", day.getAttribute("drday"));
			ctl.setAttribute("drEndMonthSel", cal.getAttribute("drmonth"));
			ctl.setAttribute("drEndYearSel", cal.getAttribute("dryear"));

			ASI_DR_DressHover(ctl);
			ASI_DR_StopEventPropagation();
		}
	}
}
function ASI_DR_MouseUp(day)
{
	if (MouseIsDown)
	{
		MouseIsDown = false;

		if (day.getAttribute("drvalid").toLowerCase() == "true")
		{
			var cal = ASI_DR_GetCalendarFromDay(day);
			var ctl = ASI_DR_GetControlFromCalendar(cal);
			var dts = ASI_DR_GetSelectedDatesHolder(ctl);

			//set the actual day/month/year attributes from selected
			dts.value = ctl.getAttribute("drStartYearSel") + "," + ctl.getAttribute("drStartMonthSel") 
					+ "," + ctl.getAttribute("drStartDaySel") + ";" + ctl.getAttribute("drEndYearSel")
					+ "," + ctl.getAttribute("drEndMonthSel") + "," + ctl.getAttribute("drEndDaySel");

			//make sure start dates are before end dates
			ASI_DR_ValidateDateOrder(ctl);

			//remove the selected attributes
			ctl.removeAttribute("drStartDaySel");
			ctl.removeAttribute("drStartMonthSel");
			ctl.removeAttribute("drStartYearSel");

			ctl.removeAttribute("drEndDaySel");
			ctl.removeAttribute("drEndMonthSel");
			ctl.removeAttribute("drEndYearSel");

			ASI_DR_DressSelected(ctl);
			ASI_DR_StopEventPropagation();
			ASI_DR_PerformPostBack(ctl);
		}
	}
}
function ASI_DR_PerformPostBack(ctl)
{
	var Props = ASI_DR_GetProperties(ctl);

	// get properties
	var AutoPostBack = Boolean(Props.rows[21].cells[1].innerHTML);
	var PostBackExecution = Props.rows[22].cells[1].innerHTML;

	if (AutoPostBack)
	{
		eval(PostBackExecution);
	}
}
function ASI_DR_DressHover(ctl)
{
	var StartDay = parseInt(ctl.getAttribute("drStartDaySel"));
	var StartMonth = parseInt(ctl.getAttribute("drStartMonthSel"));
	var StartYear = parseInt(ctl.getAttribute("drStartYearSel"));

	var EndDay = parseInt(ctl.getAttribute("drEndDaySel"));
	var EndMonth = parseInt(ctl.getAttribute("drEndMonthSel"));
	var EndYear = parseInt(ctl.getAttribute("drEndYearSel"));

	ASI_DR_Dress(ctl, StartDay, StartMonth, StartYear, EndDay, EndMonth, EndYear, "drhoverstyle");
}
function ASI_DR_DressSelected(ctl)
{
	var Dates = ASI_DR_GetSelectedDatesHolder(ctl).value.split(";");

	if (Dates.length == 2)
	{
		var StartDate = Dates[0].split(",");
		var EndDate = Dates[1].split(",");

		var StartDay = parseInt(StartDate[2]);
		var StartMonth = parseInt(StartDate[1]);
		var StartYear = parseInt(StartDate[0]);

		var EndDay = parseInt(EndDate[2]);
		var EndMonth = parseInt(EndDate[1]);
		var EndYear = parseInt(EndDate[0]);

		ASI_DR_Dress(ctl, StartDay, StartMonth, StartYear, EndDay, EndMonth, EndYear, "drselectedstyle");
	}
	else
	{
		ASI_DR_Clear(ctl)
	}
}
function ASI_DR_Clear(ctl)
{
	ASI_DR_GetSelectedDatesHolder(ctl).value = "";

	// cycle through all calendars
	var drCols = parseInt(ctl.getAttribute("drcolumns"));
	var drRows = parseInt(ctl.getAttribute("drrows"));

	for (r = 0; r < drRows; r++)
	{
		for (c = 0; c < drCols; c++)
		{
			var cal = ASI_DR_GetCalendar(ctl, r, c);

			if (cal != null)
			{
				var calBody = cal.rows[1].cells[0].childNodes[0];

				// loop through days
				for (k = 0; k < 6; k++)
				{
					for (l = 0; l < 7; l++)
					{
						var day = calBody.rows[k].cells[l];

						if (day != null)
						{
							if (day.getAttributeNode("drvalid") != null)
							{
								if (day.getAttribute("drvalid").toLowerCase() == "true")
								{
									day.style.cssText = day.getAttribute("drstyle");
								}
							}
						}
					}
				}
			}
		}
	}
}
function ASI_DR_Dress(ctl, StartDay, StartMonth, StartYear, EndDay, EndMonth, EndYear, StyleName)
{
	// cycle through all calendars
	var drCols = parseInt(ctl.getAttribute("drcolumns"));
	var drRows = parseInt(ctl.getAttribute("drrows"));

	//check and validate selection without updating the control values
	if (ASI_DR_DatesAreOutOfOrder(StartDay, StartMonth, StartYear, EndDay, EndMonth, EndYear))
	{
		var ShiftDay = EndDay;
		var ShiftMonth = EndMonth;
		var ShiftYear = EndYear;

		EndDay = StartDay;
		EndMonth = StartMonth;
		EndYear = StartYear;

		StartDay = ShiftDay;
		StartMonth = ShiftMonth;
		StartYear = ShiftYear;
	}

	for (r = 0; r < drRows; r++)
	{
		for (c = 0; c < drCols; c++)
		{
			var cal = ASI_DR_GetCalendar(ctl, r, c);

			if (cal != null)
			{
				var calBody = cal.rows[1].cells[0].childNodes[0];

				var Month = parseInt(cal.getAttribute("drmonth"));
				var Year = parseInt(cal.getAttribute("dryear"));

				var InRange = ASI_DR_MonthIsInRange(Month, Year, StartMonth, StartYear, EndMonth, EndYear);

				// loop through days
				for (k = 1; k < 7; k++)
				{
					for (l = 0; l < 7; l++)
					{
						var day = calBody.rows[k].cells[l];

						if (day != null)
						{
							if (InRange)
							{
								if (day.getAttributeNode("drvalid") != null)
								{
									if (day.getAttribute("drvalid").toLowerCase() == "true")
									{
										var drDay = parseInt(day.getAttribute("drday"));

										if ((drDay == StartDay && Month == StartMonth && Year == StartYear) || 
											(drDay == EndDay && Month == EndMonth && Year == EndYear) ||
											(ASI_DR_DateIsAfter(drDay, Month, Year, StartDay, StartMonth, StartYear)
											&& ASI_DR_DateIsBefore(drDay, Month, Year, EndDay, EndMonth, EndYear)))
										{
											day.style.cssText = day.getAttribute(StyleName);
										}
										else
										{
											day.style.cssText = day.getAttribute("drstyle");
										}
									}
								}
							}
							else
							{
								day.style.cssText = day.getAttribute("drstyle");
							}
						}
					}
				}
			}
		}
	}
}
function ASI_DR_PreviousMonth(btn)
{
	var cal = ASI_DR_GetCalendarFromButton(btn);
	var ctl = ASI_DR_GetControlFromCalendar(cal);

	ASI_DR_ShiftCalendarsToNext(ctl);
	ASI_DR_DecrementStartingMonth(ctl);
	ASI_DR_InsertCalendarAtBeginning(ctl);
}
function ASI_DR_NextMonth(btn)
{
	var cal = ASI_DR_GetCalendarFromButton(btn);
	var ctl = ASI_DR_GetControlFromCalendar(cal);

	ASI_DR_ShiftCalendarsToPrevious(ctl);
	ASI_DR_IncrementStartingMonth(ctl);
	ASI_DR_InsertCalendarAtEnd(ctl);
}
function ASI_DR_InsertCalendarAtBeginning(ctl)
{
	var Holder = ASI_DR_GetStartingMonthHolder(ctl);
	var Parts = Holder.value.split(";");

	if (Parts.length == 2)
	{
		var Month = parseInt(Parts[1]);
		var Year = parseInt(Parts[0]);

		var Cols = parseInt(ctl.getAttribute("drcolumns"));

		var Calendar = ASI_DR_GetNewCalendar(ctl, Month, Year, 0, 0, Cols);
		var ThisHolder = ASI_DR_GetCalendarHolder(ctl, 0, 0);

		ThisHolder.innerHTML = Calendar;
	}
}
function ASI_DR_InsertCalendarAtEnd(ctl)
{
	var Holder = ASI_DR_GetStartingMonthHolder(ctl);
	var Parts = Holder.value.split(";");

	if (Parts.length == 2)
	{
		var Month = parseInt(Parts[1]);
		var Year = parseInt(Parts[0]);

		var Cols = parseInt(ctl.getAttribute("drcolumns"));
		var Rows = parseInt(ctl.getAttribute("drrows"));

		for (R = (Rows - 1); R >= 0; R--)
		{
			for (C = (Cols - 1); C >= 0; C--)
			{
				//skip the first month
				if (!(R == 0 && C == 0))
				{
					if (Month < 12)
					{
						Month++;
					}
					else
					{
						Month = 1;
						Year++;
					}
				}
			}	
		}

		var Calendar = ASI_DR_GetNewCalendar(ctl, Month, Year, (Rows - 1), (Cols - 1), Cols);
		var ThisHolder = ASI_DR_GetCalendarHolder(ctl, (Rows - 1), (Cols - 1));

		ThisHolder.innerHTML = Calendar;
	}
}
function ASI_DR_GetNewCalendar(ctl, Month, Year, R, C, Cols)
{
	var Props = ASI_DR_GetProperties(ctl);

	// get properties
	var Calendar = "";
	var CalendarID = ctl.id + "_cal_" + R + "_" + C;
	var HolderPadding = parseInt(Props.rows[0].cells[1].innerHTML);
	var HolderSpacing = parseInt(Props.rows[1].cells[1].innerHTML);
	var HolderBorderWidth = parseInt(Props.rows[2].cells[1].innerHTML);
	var CalendarTitlePadding = parseInt(Props.rows[3].cells[1].innerHTML);
	var CalendarTitleSpacing = parseInt(Props.rows[4].cells[1].innerHTML);
	var CalendarHeaderStyle = Props.rows[5].cells[1].innerHTML;
	var NavigatorPlacement = parseInt(Props.rows[6].cells[1].innerHTML);
	var NavigatorStyle = parseInt(Props.rows[7].cells[1].innerHTML);
	var NavigatorImageLeft = Props.rows[8].cells[1].innerHTML;
	var NavigatorImageRight = Props.rows[9].cells[1].innerHTML;
	var CalendarTitleAlignment = Props.rows[10].cells[1].innerHTML;
	var CalendarTitleFormat = Props.rows[11].cells[1].innerHTML;
	var CalendarHolderStyle = Props.rows[12].cells[1].innerHTML;
	var CalendarStyle = Props.rows[13].cells[1].innerHTML;
	var DayPadding = parseInt(Props.rows[14].cells[1].innerHTML);
	var DaySpacing = parseInt(Props.rows[15].cells[1].innerHTML);
	var DayBorderWidth = parseInt(Props.rows[16].cells[1].innerHTML);

	// start calendar
	Calendar = "<table onmouseover=\"ASI_DR_StopEventPropagation()\" drmonth=\"" + Month + "\" dryear=\"" + Year + "\" id=\"" + CalendarID + "\" cellpadding=\"" + HolderPadding + "\" cellspacing=\"" + HolderSpacing + "\" border=\"" + HolderBorderWidth + "\">";
	Calendar += "	<tr>";
	Calendar += "		<td>";
	Calendar += "			<table onmouseover=\"ASI_DR_StopEventPropagation()\" cellpadding=\"" + CalendarTitlePadding + "\" cellspacing=\"" + CalendarTitleSpacing + "\" style=\"width:100%;" + CalendarHeaderStyle + "\" id=\"" + CalendarID + "_title\">";
	Calendar += "				<tr>";
	Calendar += "					<td>";

    // left navigator
    if ((NavigatorPlacement == 1) || (NavigatorPlacement == 2 && R == 0 && C == 0)
		|| (NavigatorPlacement == 3 && R == 0 && C == 0))
	{
		switch (NavigatorStyle)
		{
			case 0: // button
                Calendar += "<button onclick=\"ASI_DR_PreviousMonth(this);\" hideFocus=\"true\" style=\"font-size:9px;font-weight:bold;font-family:arial;width:16px;height:16px\">&lt;</button>";
				break;
			case 1: // image
                Calendar += "<img style=\"cursor:pointer;\" onclick=\"ASI_DR_PreviousMonth(this);\" src=\"" + NavigatorImageLeft + "\" border=\"0\">";
				break;
		}
	}
	else
	{
		Calendar += "&nbsp;";
	}

	// calendar title area
	Calendar += "					</td>";
	Calendar += "					<td style=\"width:100%;\" align=\"" + CalendarTitleAlignment.toLowerCase() + "\">";
	Calendar +=							ASI_DR_Months[Month - 1] + " " + Year;
	Calendar += "					</td>";
	Calendar += "					<td align=\"right\">";

	// right navigator
    if ((NavigatorPlacement == 1) || (NavigatorPlacement == 2 && R == 0 && C == 0)
		|| (NavigatorPlacement == 3 && R == 0 && C == (Cols - 1)))
	{
		switch (NavigatorStyle)
		{
			case 0: // button
				Calendar += "<button onclick=\"ASI_DR_NextMonth(this);\" hideFocus=\"true\" style=\"text-align:center;font-size:9px;font-weight:bold;font-family:arial;width:16px;height:16px\">&nbsp;&gt;</button>";
				break;
			case 1: // image
				Calendar += "<img style=\"cursor:pointer;\" onclick=\"ASI_DR_NextMonth(this);\" src=\"" + NavigatorImageRight + "\" border=\"0\">";
				break;
		}
	}
	else
	{
		Calendar += "&nbsp;";
	}

	// finish up title area
	Calendar += "					</td>";
	Calendar += "				</tr>";
	Calendar += "			</table>";
	Calendar += "		</td>";
	Calendar += "	</tr>";
	Calendar += "	<tr>";
	Calendar += "		<td style=\"" + CalendarHolderStyle + "\" id=\"" + CalendarID + "_body\">";
	Calendar += "			<table style=\"" + CalendarStyle + "\" id=\"" + CalendarID + "_body_cal\" cellpadding=\"" + DayPadding + "\" cellspacing=\"" + DaySpacing + "\" border=\"" + DayBorderWidth + "\">";

	// do the calendar
	Calendar += ASI_DR_GetNewCalendarBody(ctl, Month, Year, R, C);

	Calendar += "			</table>";
	Calendar += "		</td>";
	Calendar += "	</tr>";
	Calendar += "</table>";

	return Calendar;
}
function ASI_DR_GetNewCalendarBody(ctl, Month, Year, R, C)
{
	var Props = ASI_DR_GetProperties(ctl);

	// get properties
	var Calendar = "";
	var CalendarID = ctl.id + "_cal_" + R + "_" + C;
	var DayHeaderStyle = Props.rows[17].cells[1].innerHTML;

	Calendar += "<tr>";
	Calendar += "	<td drstyle=\"cursor:default;" + DayHeaderStyle + "\" style=\"cursor:default;" + DayHeaderStyle + "\" align=\"center\">S</td>";
	Calendar += "	<td drstyle=\"cursor:default;" + DayHeaderStyle + "\" style=\"cursor:default;" + DayHeaderStyle + "\" align=\"center\">M</td>";
	Calendar += "	<td drstyle=\"cursor:default;" + DayHeaderStyle + "\" style=\"cursor:default;" + DayHeaderStyle + "\" align=\"center\">T</td>";
	Calendar += "	<td drstyle=\"cursor:default;" + DayHeaderStyle + "\" style=\"cursor:default;" + DayHeaderStyle + "\" align=\"center\">W</td>";
	Calendar += "	<td drstyle=\"cursor:default;" + DayHeaderStyle + "\" style=\"cursor:default;" + DayHeaderStyle + "\" align=\"center\">T</td>";
	Calendar += "	<td drstyle=\"cursor:default;" + DayHeaderStyle + "\" style=\"cursor:default;" + DayHeaderStyle + "\" align=\"center\">F</td>";
	Calendar += "	<td drstyle=\"cursor:default;" + DayHeaderStyle + "\" style=\"cursor:default;" + DayHeaderStyle + "\" align=\"center\">S</td>";
	Calendar += "</tr>";

	var CurrentDay = 1;
	var Started = false;

	// do the month
	for (i = 0; i < 6; i++)
	{
		// start each week row
		Calendar += "<tr>";

		for (j = 0; j < 7; j++)
		{
			if (i == 0)
			{
				if (j >= (ASI_DR_GetDayOfWeek(CurrentDay, Month, Year) - 1)) // past starting day
				{
					Started = true;
					Calendar += ASI_DR_GetNewCalendarBodyDay(ctl, CurrentDay, Month, Year, true);
				}
				else
				{
					Calendar += ASI_DR_GetNewCalendarBodyDay(ctl, CurrentDay, Month, Year, false);
				}
			}
			else
			{
				if (CurrentDay > ASI_DR_GetDaysInMonth(Month, Year)) // past last day of current month
				{
                    Calendar += ASI_DR_GetNewCalendarBodyDay(ctl, CurrentDay, Month, Year, false);
                }
                else
                {
                    Calendar += ASI_DR_GetNewCalendarBodyDay(ctl, CurrentDay, Month, Year, true);
                }
			}

			// iterate day
            if (Started)
            {
                CurrentDay += 1;
            }
		}

		// end each week row
		Calendar += "</tr>";
	}

	return Calendar;
}
function ASI_DR_GetNewCalendarBodyDay(ctl, CurrentDay, Month, Year, Render)
{
	var Props = ASI_DR_GetProperties(ctl);

	// get properties
	var Calendar = "";
	var CalendarID = ctl.id + "_cal_" + R + "_" + C;
	var DayStyle = Props.rows[18].cells[1].innerHTML;
	var DayHoverStyle = Props.rows[19].cells[1].innerHTML;
	var DaySelectedStyle = Props.rows[20].cells[1].innerHTML;

	if (Render)
	{
		var CurrentDate = new Date(Year, Month - 1, CurrentDay);

		Calendar += ASI_DR_GetNewCalendarBodyDayStylized(ctl, CurrentDay, Month, Year);

		if (Calendar.length == 0) // NOT a StandOutDate
		{
			var SelectedDates = ASI_DR_GetSelectedDatesHolder(ctl);

			if (SelectedDates.value != null && SelectedDates.value.length > 0) // there ARE dates selected
			{
				var Dates = SelectedDates.value.split(";");

				if (Dates.length == 2)
				{
					var StartDate = Dates[0].split(",");
					var EndDate = Dates[1].split(",");

					var StartDay = parseInt(StartDate[2]);
					var StartMonth = parseInt(StartDate[1]);
					var StartYear = parseInt(StartDate[0]);

					var EndDay = parseInt(EndDate[2]);
					var EndMonth = parseInt(EndDate[1]);
					var EndYear = parseInt(EndDate[0]);

					StartDate = new Date(StartYear, StartMonth - 1, StartDay);
					EndDate = new Date(EndYear, EndMonth - 1, EndDay);

					if (StartDate <= CurrentDate && CurrentDate <= EndDate)
					{
						Calendar += "<td drstyle=\"cursor:pointer;" + DayStyle + "\" drhoverstyle=\"cursor:pointer;" + DayHoverStyle + "\" drselectedstyle=\"cursor:pointer;" + DaySelectedStyle + "\" style=\"cursor:pointer;" + DaySelectedStyle + "\" onmouseover=\"ASI_DR_MouseOver(this);\" onmouseup=\"ASI_DR_MouseUp(this);\" onmousedown=\"ASI_DR_MouseDown(this);\" drvalid=\"true\" drday=\"" + CurrentDay + "\" align=\"center\">" + CurrentDay + "</td>";
					}
					else
					{
						Calendar += "<td drstyle=\"cursor:pointer;" + DayStyle + "\" drhoverstyle=\"cursor:pointer;" + DayHoverStyle + "\" drselectedstyle=\"cursor:pointer;" + DaySelectedStyle + "\" style=\"cursor:pointer;" + DayStyle + "\" onmouseover=\"ASI_DR_MouseOver(this);\" onmouseup=\"ASI_DR_MouseUp(this);\" onmousedown=\"ASI_DR_MouseDown(this);\" drvalid=\"true\" drday=\"" + CurrentDay + "\" align=\"center\">" + CurrentDay + "</td>";
					}
				}
				else
				{
					Calendar += "<td drstyle=\"cursor:pointer;" + DayStyle + "\" drhoverstyle=\"cursor:pointer;" + DayHoverStyle + "\" drselectedstyle=\"cursor:pointer;" + DaySelectedStyle + "\" style=\"cursor:pointer;" + DayStyle + "\" onmouseover=\"ASI_DR_MouseOver(this);\" onmouseup=\"ASI_DR_MouseUp(this);\" onmousedown=\"ASI_DR_MouseDown(this);\" drvalid=\"true\" drday=\"" + CurrentDay + "\" align=\"center\">" + CurrentDay + "</td>";
				}
			}
			else
			{
				Calendar += "<td drstyle=\"cursor:pointer;" + DayStyle + "\" drhoverstyle=\"cursor:pointer;" + DayHoverStyle + "\" drselectedstyle=\"cursor:pointer;" + DaySelectedStyle + "\" style=\"cursor:pointer;" + DayStyle + "\" onmouseover=\"ASI_DR_MouseOver(this);\" onmouseup=\"ASI_DR_MouseUp(this);\" onmousedown=\"ASI_DR_MouseDown(this);\" drvalid=\"true\" drday=\"" + CurrentDay + "\" align=\"center\">" + CurrentDay + "</td>";
			}
		}
	}
	else
	{
		Calendar += "<td drstyle=\"cursor:default;" + DayStyle + "\" style=\"cursor:default;" + DayStyle + "\">&nbsp;</td>";
	}

	return Calendar;
}
function ASI_DR_GetNewCalendarBodyDayStylized(ctl, CurrentDay, Month, Year)
{
	var Calendar = "";
	var CurrentDate = new Date(Year, Month - 1, CurrentDay);
	var CurrentDateString = Year + "" + ASI_DR_String_PadLeft(Month, "0", 2) + "" + ASI_DR_String_PadLeft(CurrentDay, "0", 2);
	var StandOutDateSets = ASI_DR_GetStandOutDates(ctl);

	var SelectedDates = ASI_DR_GetSelectedDatesHolder(ctl).value.split(";");

	if (SelectedDates.length == 2)
	{
		var SelectedStartDate = SelectedDates[0].split(",");
		var SelectedEndDate = SelectedDates[1].split(",");

		var StartDay = parseInt(SelectedStartDate[2]);
		var StartMonth = parseInt(SelectedStartDate[1]);
		var StartYear = parseInt(SelectedStartDate[0]);

		var EndDay = parseInt(SelectedEndDate[2]);
		var EndMonth = parseInt(SelectedEndDate[1]);
		var EndYear = parseInt(SelectedEndDate[0]);

		SelectedStartDate = new Date(StartYear, StartMonth - 1, StartDay);
		SelectedEndDate = new Date(EndYear, EndMonth - 1, EndDay);
	}

	//loop the sods
	for (r = 0; r < StandOutDateSets.rows.length; r++)
	{
		var StandOutDateSet = StandOutDateSets.rows[r];
		var Style = StandOutDateSet.cells[0].innerHTML;
		var HoverStyle = StandOutDateSet.cells[1].innerHTML;
		var SelectedStyle = StandOutDateSet.cells[2].innerHTML;
		var StandOutDates = StandOutDateSet.cells[3].innerHTML.split(";");

		for (d = 0; d < StandOutDates.length; d++)
		{
			var StandOutDate = StandOutDates[d];
			var StandOutDateParts = StandOutDate.split(",");

			var StandOutDateDay = parseInt(StandOutDateParts[2]);
			var StandOutDateMonth = parseInt(StandOutDateParts[1]);
			var StandOutDateYear = parseInt(StandOutDateParts[0]);

			var StandOutDateString = StandOutDateYear + "" + ASI_DR_String_PadLeft(StandOutDateMonth, "0", 2) + "" + ASI_DR_String_PadLeft(StandOutDateDay, "0", 2);

			if (CurrentDateString == StandOutDateString)
			{
				if (SelectedDates.length == 2 && SelectedStartDate <= CurrentDate && CurrentDate <= SelectedEndDate)
				{
					// found and selected
					return "<td drstyle=\"cursor:pointer;" + Style + "\" drhoverstyle=\"cursor:pointer;" + HoverStyle + "\" drselectedstyle=\"cursor:pointer;" + SelectedStyle + "\" style=\"cursor:pointer;" + SelectedStyle + "\" onmouseover=\"ASI_DR_MouseOver(this);\" onmouseup=\"ASI_DR_MouseUp(this);\" onmousedown=\"ASI_DR_MouseDown(this);\" drvalid=\"true\" drday=\"" + CurrentDay + "\" align=\"center\">" + CurrentDay + "</td>";
				}
				else
				{
					// found but NOT selected
					return "<td drstyle=\"cursor:pointer;" + Style + "\" drhoverstyle=\"cursor:pointer;" + HoverStyle + "\" drselectedstyle=\"cursor:pointer;" + SelectedStyle + "\" style=\"cursor:pointer;" + Style + "\" onmouseover=\"ASI_DR_MouseOver(this);\" onmouseup=\"ASI_DR_MouseUp(this);\" onmousedown=\"ASI_DR_MouseDown(this);\" drvalid=\"true\" drday=\"" + CurrentDay + "\" align=\"center\">" + CurrentDay + "</td>";
				}
			}
		}
	}

	return "";
}
function ASI_DR_ShiftCalendarsToNext(ctl)
{
	var Cols = parseInt(ctl.getAttribute("drcolumns"));
	var Rows = parseInt(ctl.getAttribute("drrows"));

	//cycle from last to first
	for (R = (Rows - 1); R >= 0; R--)
	{
		for (C = (Cols - 1); C >= 0; C--)
		{
			var ThisHolder = ASI_DR_GetCalendarHolder(ctl, R, C);

			var PreviousR = R;
			var PreviousC = 0;

			if ((C - 1) < 0)
			{
				PreviousC = (Cols - 1);
			}
			else
			{
				PreviousC = (C - 1);
			}

			if (PreviousC >= C)
			{
				PreviousR = (R - 1);
			}

			if (PreviousC >= 0 && PreviousR >= 0)
			{
				var PreviousHolder = ASI_DR_GetCalendarHolder(ctl, PreviousR, PreviousC);

				//assign everything over
				ThisHolder.innerHTML = PreviousHolder.innerHTML;
			}
			else
			{
				ThisHolder.innerHTML = "";
			}

			ASI_DR_ValidateNavigators(ctl, ASI_DR_GetCalendar(ctl, R, C), R, C, Cols);
		}
	}
}
function ASI_DR_ValidateNavigators(ctl, cal, R, C, Cols)
{
	if (cal != null)
	{
		var Props = ASI_DR_GetProperties(ctl);
		var LeftHolder = ASI_DR_GetCalendarLeftNavigatorHolder(cal);
		var RightHolder = ASI_DR_GetCalendarRightNavigatorHolder(cal);

		// get properties
		var NavigatorPlacement = parseInt(Props.rows[6].cells[1].innerHTML);
		var NavigatorStyle = parseInt(Props.rows[7].cells[1].innerHTML);
		var NavigatorImageLeft = Props.rows[8].cells[1].innerHTML;
		var NavigatorImageRight = Props.rows[9].cells[1].innerHTML;

		// check left navigator
		if ((NavigatorPlacement == 1) || (NavigatorPlacement == 2 && R == 0 && C == 0)
			|| (NavigatorPlacement == 3 && R == 0 && C == 0))
		{
			switch (NavigatorStyle)
			{
				case 0: // button
					LeftHolder.innerHTML = "<button onclick=\"ASI_DR_PreviousMonth(this);\" hideFocus=\"true\" style=\"font-size:9px;font-weight:bold;font-family:arial;width:16px;height:16px\">&lt;</button>";
					break;
				case 1: // image
					LeftHolder.innerHTML = "<img style=\"cursor:pointer;\" onclick=\"ASI_DR_PreviousMonth(this);\" src=\"" + NavigatorImageLeft + "\" border=\"0\"></img>";
					break;
			}
		}
		else
		{
			LeftHolder.innerHTML = "&nbsp;";
		}

		// right navigator
		if ((NavigatorPlacement == 1) || (NavigatorPlacement == 2 && R == 0 && C == 0)
			|| (NavigatorPlacement == 3 && R == 0 && C == (Cols - 1)))
		{
			switch (NavigatorStyle)
			{
				case 0: // button
					RightHolder.innerHTML = "<button onclick=\"ASI_DR_NextMonth(this);\" hideFocus=\"true\" style=\"text-align:center;font-size:9px;font-weight:bold;font-family:arial;width:16px;height:16px\">&nbsp;&gt;</button>";
					break;
				case 1: // image
					RightHolder.innerHTML = "<img style=\"cursor:pointer;\" onclick=\"ASI_DR_NextMonth(this);\" src=\"" + NavigatorImageRight + "\" border=\"0\"></img>";
					break;
			}
		}
		else
		{
			RightHolder.innerHTML = "&nbsp;";
		}
	}
}
function ASI_DR_ShiftCalendarsToPrevious(ctl)
{
	var Cols = parseInt(ctl.getAttribute("drcolumns"));
	var Rows = parseInt(ctl.getAttribute("drrows"));

	//cycle from first to last
	for (R = 0; R < Rows; R++)
	{
		for (C = 0; C < Cols; C++)
		{
			var ThisHolder = ASI_DR_GetCalendarHolder(ctl, R, C);

			var NextR = R;
			var NextC = 0;

			if ((C + 1) < Cols)
			{
				NextC = (C + 1);
			}
			else
			{
				NextC = 0;
			}

			if (NextC <= C)
			{
				NextR = (R + 1);
			}

			if (NextC < Cols && NextR < Rows)
			{
				var NextHolder = ASI_DR_GetCalendarHolder(ctl, NextR, NextC);

				//assign everything over
				ThisHolder.innerHTML = NextHolder.innerHTML;
			}
			else
			{
				ThisHolder.innerHTML = "";
			}

			ASI_DR_ValidateNavigators(ctl, ASI_DR_GetCalendar(ctl, R, C), R, C, Cols);
		}
	}
}
function ASI_DR_IncrementStartingMonth(ctl)
{
	var Holder = ASI_DR_GetStartingMonthHolder(ctl);
	var Parts = Holder.value.split(";");

	if (Parts.length == 2)
	{
		var Month = parseInt(Parts[1]);
		var Year = parseInt(Parts[0]);

		if (Month < 12)
		{
			Month++;
		}
		else
		{
			Month = 1;
			Year++;
		}

		Holder.value = Year + ";" + Month;
	}
}
function ASI_DR_DecrementStartingMonth(ctl)
{
	var Holder = ASI_DR_GetStartingMonthHolder(ctl);
	var Parts = Holder.value.split(";");

	if (Parts.length == 2)
	{
		var Month = parseInt(Parts[1]);
		var Year = parseInt(Parts[0]);

		if (Month > 1)
		{
			Month--;
		}
		else
		{
			Month = 12;
			Year--;
		}

		Holder.value = Year + ";" + Month;
	}
}
function ASI_DR_DateIsAfter(day1, month1, year1, day2, month2, year2)
{
	if (year1 > year2)
	{
		return true;		
	}
	else
	{
		if (year1 == year2)
		{
			if (month1 > month2)
			{
				return true;
			}
			else
			{
				if (month1 == month2)
				{
					if (day1 > day2)
					{
						return true;
					}
					else
					{
						return false;
					}
				}
				else
				{
					return false;
				}
			}
		}
		else
		{
			return false;
		}
	}
}
function ASI_DR_DateIsBefore(day1, month1, year1, day2, month2, year2)
{
	return ASI_DR_DateIsAfter(day2, month2, year2, day1, month1, year1);
}
function ASI_DR_ValidateDateOrder(ctl)
{
	var Dates = ASI_DR_GetSelectedDatesHolder(ctl).value.split(";");

	if (Dates.length == 2)
	{
		var StartDate = Dates[0].split(",");
		var EndDate = Dates[1].split(",");

		var StartDay = parseInt(StartDate[2]);
		var StartMonth = parseInt(StartDate[1]);
		var StartYear = parseInt(StartDate[0]);

		var EndDay = parseInt(EndDate[2]);
		var EndMonth = parseInt(EndDate[1]);
		var EndYear = parseInt(EndDate[0]);

		if (ASI_DR_DatesAreOutOfOrder(StartDay, StartMonth, StartYear, EndDay, EndMonth, EndYear))
		{
			ASI_DR_SwapDateOrder(ctl);
		}
	}
}
function ASI_DR_SwapDateOrder(ctl)
{
	var Holder = ASI_DR_GetSelectedDatesHolder(ctl);
	var Dates = Holder.value.split(";");

	if (Dates.length == 2)
	{
		Holder.value = Dates[1] + ";" + Dates[0];
	}
}
function ASI_DR_DatesAreOutOfOrder(StartDay, StartMonth, StartYear, EndDay, EndMonth, EndYear)
{
	if (StartYear > EndYear)
	{
		return true;
	}
	else
	{
		if (StartYear == EndYear)
		{
			if (StartMonth > EndMonth)
			{
				return true;
			}
			else
			{
				if (StartMonth == EndMonth)
				{
					if (StartDay > EndDay)
					{
						return true;
					}
				}
			}
		}
	}

	return false;
}
function ASI_DR_MonthIsInRange(Month, Year, StartMonth, StartYear, EndMonth, EndYear)
{
	var CurrentDate = Year + "-" + ASI_DR_String_PadLeft(Month, "0", 2);
	var StartDate = StartYear + "-" + ASI_DR_String_PadLeft(StartMonth, "0", 2);
	var EndDate = EndYear + "-" + ASI_DR_String_PadLeft(EndMonth, "0", 2);

	return (StartDate <= CurrentDate && CurrentDate <= EndDate);
}
function ASI_DR_GetDaysInMonth(Month, Year)
{
	var MonthDays = new Array(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
	var MonthDaysInLeapYear = new Array(31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);

	if (ASI_DR_IsLeapYear(Year))
	{
		return MonthDaysInLeapYear[Month - 1];
	}
	else
	{
		return MonthDays[Month - 1];
	}
}
function ASI_DR_GetDayOfWeek(Day, Month, Year)
{
	var a = Math.floor((14 - Month) / 12);
	var y = Year - a;
	var m = Month + 12 * a - 2;
	var d = (Day + y + Math.floor(y / 4) - Math.floor(y / 100) + Math.floor(y / 400) + Math.floor((31 * m) / 12)) % 7;

	return d + 1;
}
function ASI_DR_IsLeapYear(Year)
{
	if ((Year / 4) != Math.floor(Year / 4))
	{
		return false;
	}
	if ((Year / 100) != Math.floor(Year / 100))
	{
		return true;
	}
	if ((Year / 400) != Math.floor(Year / 400))
	{
		return false;
	}

	return true;
}
function ASI_DR_GetProperties(ctl)
{
	return ctl.nextSibling;
}
function ASI_DR_GetStandOutDates(ctl)
{
	return ctl.nextSibling.nextSibling;
}
function ASI_DR_GetSelectedDatesHolder(ctl)
{
	return ctl.nextSibling.nextSibling.nextSibling;
}
function ASI_DR_GetStartingMonthHolder(ctl)
{
	return ctl.nextSibling.nextSibling.nextSibling.nextSibling;
}
function ASI_DR_GetCalendarLeftNavigatorHolder(cal)
{
	return cal.rows[0].cells[0].childNodes[0].rows[0].cells[0];
}
function ASI_DR_GetCalendarRightNavigatorHolder(cal)
{
	return cal.rows[0].cells[0].childNodes[0].rows[0].cells[2];
}
function ASI_DR_GetCalendar(ctl, r, c)
{
	return ctl.rows[r].cells[c].childNodes[0];
}
function ASI_DR_GetCalendarHolder(ctl, r, c)
{
	return ctl.rows[r].cells[c];
}
function ASI_DR_GetCalendarFromDay(day)
{
	return day.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode;
}
function ASI_DR_GetCalendarFromButton(btn)
{
	return btn.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode;
}
function ASI_DR_GetControlFromDay(day)
{
	return day.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode;
}
function ASI_DR_GetControlFromCalendar(cal)
{
	return cal.parentNode.parentNode.parentNode.parentNode;
}
function ASI_DR_StopEventPropagation()
{
	if (!e)
	{
		var e = window.event;
	}

	e.cancelBubble = true;
	
	if (e.stopPropagation)
	{
		e.stopPropagation();
	}
}
function ASI_DR_String_PadLeft(value, pad, digits)
{
	value += "";

	while (value.length < digits)
	{
		value = pad + value;
	}

	return value;
}
function ASI_DR_String_PadRight(value, pad, digits)
{
	while (value.length < digits)
	{
		value += pad;
	}

	return value;
}
function ASI_DR_FindX(obj)
{
	var Left = 0;

	if (obj.offsetParent)
	{
		while (obj.offsetParent)
		{
			Left += obj.offsetLeft;
			obj = obj.offsetParent;
		}
	}
	else if (obj.x)
	{
		Left += obj.x;
	}

	return Left;
}
function ASI_DR_FindY(obj)
{
	var Top = 0;

	if (obj.offsetParent)
	{
		while (obj.offsetParent)
		{
			Top += obj.offsetTop;
			obj = obj.offsetParent;
		}
	}
	else if (obj.y)
	{
		Top += obj.y;
	}

	return Top;
}