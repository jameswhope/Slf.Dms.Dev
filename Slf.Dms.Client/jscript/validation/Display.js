
function AddBorder(obj)
{
    obj.style.border = "solid 2px red";
    obj.focus();
}
function RemoveBorder(obj)
{
    obj.style.cssText = obj.style.cssText.replace(/BORDER-TOP: red 2px solid;/g, '');
    obj.style.cssText = obj.style.cssText.replace(/BORDER-LEFT: red 2px solid;/g, '');
    obj.style.cssText = obj.style.cssText.replace(/BORDER-RIGHT: red 2px solid;/g, '');
    obj.style.cssText = obj.style.cssText.replace(/BORDER-BOTTOM: red 2px solid;/g, '');
    obj.style.cssText = obj.style.cssText.replace(/BORDER-BOTTOM: red 2px solid/g, '');
}
function FormatNumber(Value, Comma, Decimals)
{
    if (!isNaN(Value))
    {
        // do decimals
        Value = Value.toFixed(Decimals);

        // turn value into string
        Value += "";

        var Final = "";

        // add commas
        if (Comma)
        {
            var Chunk = "";

            var NumberPortion = Value.split(".")[0];

            for (i = NumberPortion.length - 1; i >= 0; i--)
            {
                Chunk = NumberPortion.substring(i, i + 1) + Chunk;

                if (Chunk.length == 3)
                {
                    if (Final.length > 0)
                    {
                        Final = Chunk + "," + Final;
                    }
                    else
                    {
                        Final = Chunk;
                    }

                    Chunk = "";
                }
            }

            if (Chunk.length > 0)
            {
                if (Final.length > 0)
                {
                    Final = Chunk + "," + Final;
                }
                else
                {
                    Final = Chunk;
                }

                Chunk = "";
            }

            if (Value.split(".").length == 2)
            {
                Final += "." + Value.split(".")[1];
            }
        }
        else
        {
            Final = Value;
        }

        if (Decimals > 0)
        {
            if (Final.split(".").length == 1)
            {
                Final += ".0";
            }

            // make sure there are correct number of decimals
            while (Final.split(".")[1].length < Decimals)
            {
                Final += "0";
            }
        }

        return Final;
    }
    else
    {
        return "0.00";
    }
}