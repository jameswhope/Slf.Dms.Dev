
function IsValidTextPhoneNumber(Value)
{
    return RegexValidate(Value, "((\\(\\d{3}\\) ?)|(\\d{3}[- \\.]))?\\d{3}[- \\.]\\d{4}(\\s(x\\d+)?){0,1}$");
}
function IsValidTextLength(Value, MinLength, MaxLength)
{
    return (Value.length >= MinLength && Value.length <= MaxLength);
}
function IsValidTextSSN(Value)
{
    //return RegexValidate(Value, "^(?!000)([0-6]\\d{2}|7([0-6]\\d|7[012]))([ -]?)(?!00)\\d\\d\\3(?!0000)\\d{4}$");
    return RegexValidate(Value, "^(?!000)(?!666)\\d{3}[-]?(?!00)\\d{2}[-]?(?!0000)\\d{4}$");
}
function IsValidTextEmailAddress(Value)
{
    return RegexValidate(Value, "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$");
}
function IsValidDateTime(Value)
{
    var CorrectForm = RegexValidate(Value, "(?=\\d)^(?:(?!(?:10\\D(?:0?[5-9]|1[0-4])\\D(?:1582))|(?:0?9\\D(?:0?[3-9]|1[0-3])\\D(?:1752)))((?:0?[13578]|1[02])|(?:0?[469]|11)(?!\\/31)(?!-31)(?!\\.31)|(?:0?2(?=.?(?:(?:29.(?!000[04]|(?:(?:1[^0-6]|[2468][^048]|[3579][^26])00))(?:(?:(?:\\d\\d)(?:[02468][048]|[13579][26])(?!\\x20BC))|(?:00(?:42|3[0369]|2[147]|1[258]|09)\\x20BC))))))|(?:0?2(?=.(?:(?:\\d\\D)|(?:[01]\\d)|(?:2[0-8])))))([-.\\/])(0?[1-9]|[12]\\d|3[01])\\2(?!0000)((?=(?:00(?:4[0-5]|[0-3]?\\d)\\x20BC)|(?:\\d{4}(?!\\x20BC)))\\d{4}(?:\\x20BC)?)(?:$|(?=\\x20\\d)\\x20))?((?:(?:0?[1-9]|1[012])(?::[0-5]\\d){0,2}(?:\\x20[aApP][mM]))|(?:[01]\\d|2[0-3])(?::[0-5]\\d){1,2})?$");
    
    var WithinRange = true;
    var yearStr = Value.substring(Value.lastIndexOf("/") + 1);
    if (yearStr.length > 2)
    {
        var year = parseInt(yearStr);
        WithinRange = (year > 1753);
    }
    return CorrectForm && WithinRange;
}
function IsValidTextFloat(Value)
{
    return RegexValidate(Value, "[0-9]+\.[0-9]*");
}
function IsValidNumberInteger(Value, NotZero, Input)
{
    if (isNaN(parseInt(Value)))
    {
        return false;
    }
    else
    {
        if (NotZero && parseInt(Value) == 0)
        {
            return false;
        }
        else
        {
            Input.value = parseInt(Value);
            return true;
        }
    }
}
function IsValidNumberFloat(Value, NotZero, Input)
{
    if (isNaN(parseFloat(Value)))
    {
        return false;
    }
    else
    {
        if (NotZero && parseFloat(Value) == 0.0)
        {
            return false;
        }
        else
        {
            Input.value = parseFloat(Value);
            return true;
        }
    }
}

function RegexValidate(Value, Pattern)
{
    if (Pattern != null && Pattern.length > 0)
    {
        var re = new RegExp(Pattern);

        return Value.match(re);
    }
    else
    {
        return false;
    }
}