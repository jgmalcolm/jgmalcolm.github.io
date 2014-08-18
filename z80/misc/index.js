/*
		jimi malcolm
		malcolmj1@juno.com
		http://guide.ticalc.org
							*/
	var Term, TermTitle, TermURL;
	var TermArray;
	var i2;
	var CatchA, CatchB, CatchC, CatchD;

function RenderTerms()
	{
	document.write("<UL>");
	for (i = 0; i < allTerms.length; i++)
		{
		TermArray = eval(allTerms[i]);

		document.write("<LI><DIV STYLE='font: bold 12px'>" +
			"<A HREF='JavaScript:ToggleDrop(ID_" +
			allTerms[i] + ")'>" +
			StringParse(allTerms[i]) + "</A></DIV>" +
			"<DIV ID=ID_" + allTerms[i] +
			" STYLE='display:none;font: x-small;'>");

		for (Term = 0; Term < TermArray.length; Term++)
			{
			temp = TermArray[Term];

			TermTitle = temp.substr(temp.indexOf("?") + 1);
			TermURL = temp.substr(0, temp.indexOf("?"));

			document.write("&nbsp;&nbsp;<A HREF='../" + TermURL + "'>" +
				TermTitle + "</A><BR>");
			}
		document.write("&nbsp;&nbsp;&nbsp;&nbsp;<A" +
			" STYLE='font:xx-small' HREF='JavaScript:ToggleDrop(ID_" +
			allTerms[i] + ")'>[close term]</A></DIV>");
		}
	document.write("</UL>");
	divProcess.style.display = 'none';	// clear processing wait
	}

function StringParse(Str)
	{
	Str = Str.substr(1);
	CatchA = /_1/gi;
	CatchB = /_2/gi;
	CatchC = /_3/gi;
	CatchD = /_4/gi;

	Str = Str.replace(CatchA, "-");
	Str = Str.replace(CatchB, " ");
	Str = Str.replace(CatchC, "");
	Str = Str.replace(CatchD, "'");

	return Str;
	}

function ToggleDrop(TermID)
	{
	if (TermID.style.display == 'none')
		TermID.style.display = 'inline';
		else
		TermID.style.display = 'none';
	}