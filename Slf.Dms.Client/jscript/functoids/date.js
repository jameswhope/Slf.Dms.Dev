
function Functoid_Date_AddDays(Original, Days)
{
    return new Date(Original.getTime() + (Days * 24 * 60 * 60 * 1000));
}
function Functoid_Date_SubtractDays(From, To)
{
    return (From.getTime() - To.getTime()) / (1000 * 60 * 60 * 24);
}
function Functoid_Date_FormatDateTimeMedium(Original, Separator)
{
    var month = Original.getMonth() + 1;
    var day = Original.getDate();
    var year = Original.getFullYear();

    if (day <= 9)
        day = "0" + day;
    if (month <= 9)
        month = "0" + month;

    if (Separator == null || Separator == "")
    {
        Separator = "/";
    }

    var hours = Original.getHours();
    var minutes = Original.getMinutes();
    var seconds = Original.getSeconds();

    var td = "AM";

    if (hours >= 12)
        td = "PM";
    if (hours > 12)
        hours = hours - 12;
    if (hours == 0)
        hours = 12;
    if (minutes <= 9)
        minutes = "0" + minutes;
    if (hours <= 9)
        hours = "0" + hours;
    if (seconds <= 9)
        seconds = "0" + seconds;

    return (month + Separator + day + Separator + year + " " + hours + ":" + minutes + " " + td);
}
function Functoid_Date_FormatDateMedium(Original, Separator)
{
    var month = Original.getMonth() + 1;
    var day = Original.getDate();
    var year = Original.getFullYear();

    if (day <= 9)
        day = "0" + day;
    if (month <= 9)
        month = "0" + month;
    
    if (Separator == null || Separator == "")
    {
        Separator = "/";
    }

    return (month + Separator + day + Separator + year);
}
function Functoid_Date_GetNow(Separator, WithTime)
{
    var d = new Date();
    var month = d.getMonth() + 1
    var day = d.getDate()
    var year = d.getFullYear()

    if (day <= 9)
        day = "0" + day;
    if (month <= 9)
        month = "0" + month;
    
    if (Separator == null || Separator == "")
    {
        Separator = "/";
    }

    var curDate = month + Separator + day + Separator + year;

    var hours = d.getHours()
    var minutes = d.getMinutes()
    var seconds = d.getSeconds()
    var td="AM";
    if (hours >= 12)
        td = "PM";
    if (hours > 12)
        hours = hours - 12;
    if (hours == 0)
        hours = 12;
    if (minutes <= 9)
        minutes = "0" + minutes;
    if (hours <= 9)
        hours = "0" + hours;
    if (seconds <= 9)
        seconds = "0" + seconds;

    var curTime = hours + ":" + minutes + ":" + seconds + " " + td;

    if (WithTime)
    {
        return curDate + " " + curTime;
    }
    else
    {
        return curDate;
    }
}