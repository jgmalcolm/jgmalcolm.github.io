/*
		jimi malcolm
		malcolmj1@juno.com
		http://guide.ticalc.org
							*/

	var HTML;
	var Menus = SubMenus = 0;
	var Article = MenuDropped = false;
	var NotCompatable = true;
	var ObjectBase;
	var MouseX;
	var MouseY;
	var i = 0;
	var x, xW, y;
	var OffLeft, OffRight, OffTop;
	var optionsTB = new Array();
	var TitleColor, TitleSubColor;
	var MenuIDset = new Array();

// Browser sniff for IE 4.0 or higher
NotCompatable = (	navigator.userAgent.indexOf("MSIE")	!= -1 && 
			navigator.userAgent.indexOf("Windows")	!= -1 && 
			navigator.appVersion.substring(0,1)	> 3
		)?
		false : true;

function top(a,b)	{ CreateToolBar(a,b) }	// just keep arguements alive
function bottom()	{ CreateBottom() }

function CreateToolBar(SectionText, TopicDesc)
	{
	Article = (SectionText && TopicDesc)? true : false;
	// text, hover text, dark menu background, light panels' background
	SetColors("white", "#000033", "#6699cc");
	HTML = "<A NAME=TOP>";
	if (NotCompatable)
		{
		HTML +=	"Netscape does not support the features utilized" +
			" by the Guide. Please use <A" +
			" HREF='http://msdn.microsoft.com/isapi/gomscom.asp?" +
			"TARGET=/ie/ie40/download/'>Internet Explorer 4.0</A>" +
			" or higher instead.<P>";
		}
	HTML +=	"<A HREF='" +
		formatURL("index.html") + "'><IMG " +
		(Article? "STYLE='margin-left: -20px' " : "") + "SRC='" +
		formatURL("images/logo.jpg") + "'></A>" +
		"<SPAN STYLE='font:bold xx-small;position:absolute;top:80px;left:0;" +
		"color:" + optionsTB[0] + ";background-color:" + optionsTB[2] +
		";border-left:none;padding:3px'>";

	addMenu("BeginnerMenu", "beginner/index.htm", "Beginner");
	addSubMenu("beginner/numb.htm", "Number Bases");
	addSubMenu("beginner/z80p.htm", "z80 Processor");
	addSubMenu("beginner/ti86.htm", "TI86 Specs");
	addSubMenu("beginner/form.htm", "Format and Compiling");
	addSubMenu("beginner/alia.htm", "Aliases");
	addSubMenu("beginner/regi.htm", "Registers");
	addSubMenu("beginner/inst.htm", "Instructions");
	addSubMenu("beginner/flag.htm", "Flags & Conditions");
	addSubMenu("beginner/twos.htm", "Two's Compliment");
	addSubMenu("beginner/math.htm", "Math Operations");
	addSubMenu("beginner/ohno.htm", "Oh, No! It Crashed!");
	addSubMenu("beginner/ti-b.htm", "TI-BASIC vs Asm Chart");

	addMenu("IntermediateMenu", "intermediate/index.htm", "Intermediate");
	addSubMenu("intermediate/logi.htm", "Logical Operators");
	addSubMenu("intermediate/misc.htm", "Miscellaneous Instructions");
	addSubMenu("intermediate/grap.htm", "Graphics");
	addSubSubMenu("intermediate/scre.htm", "Screen");
	addSubSubMenu("intermediate/find.htm", "FindPixel");
	addSubSubMenu("intermediate/pixe.htm", "Pixel Manipulation");
	addSubSubMenu("intermediate/spri.htm", "Sprites");
	addSubSubMenu("intermediate/tile.htm", "Tile Maps");
	addSubMenu("intermediate/allt.htm", "All The Flags");
	addSubMenu("intermediate/rstc.htm", "Restart Commands");
	addSubMenu("intermediate/memo.htm", "Memory");
	addSubMenu("intermediate/vari.htm", "Variables");
	addSubMenu("intermediate/stac.htm", "The Stack");
	addSubMenu("intermediate/tabl.htm", "Tables & Arrays");
	addSubMenu("intermediate/simu.htm", "Simulated 16bit Addition");
	addSubMenu("intermediate/pcsp.htm", "PC and SP");
	addSubMenu("intermediate/down.htm", "Down-Left Bug");
	addSubMenu("intermediate/rand.htm", "Random Numbers");
	addSubMenu("intermediate/romc.htm", "ROM Calls");
	addSubMenu("intermediate/_getkey.htm", "GetKey");
	addSubMenu("intermediate/text.htm", "Text Display");
	addSubMenu("intermediate/debu.htm", "Debugging");
	addSubMenu("intermediate/ti-b.htm", "TI-BASIC vs Asm Chart");

	addMenu("AdvancedMenu", "advanced/index.htm", "Advanced");
	addSubMenu("advanced/inde.htm", "New Registers");
	addSubMenu("advanced/read.htm", "Key Port");
	addSubMenu("advanced/gray.htm", "Grayscale");
	addSubMenu("advanced/asse.htm", "Assembler Directives");
	addSubMenu("advanced/onof.htm", "On-Off");
	addSubMenu("advanced/shif.htm", "Shift & Rotate");
	addSubMenu("advanced/morp.htm", "Morphic Code");
	addSubMenu("advanced/allp.htm", "All Ports");
	addSubMenu("advanced/im1i.htm", "Interrupt Mode 1");
	addSubMenu("advanced/im2i.htm", "Interrupt Mode 2");
	addSubMenu("advanced/user.htm", "User Routines");
	addSubSubMenu("advanced/font.htm", "Fonts");
	addSubSubMenu("advanced/inte.htm", "Interrupts");
	addSubMenu("advanced/squa.htm", "Square Root Programs");
	addSubSubMenu("advanced/key.htm", "Key");
	addSubMenu("advanced/syst.htm", "TI-OS Flags");
	addSubMenu("advanced/apd.htm", "APD");
	addSubMenu("advanced/soun.htm", "Sound");
	addSubMenu("advanced/simu.htm", "Simulated Key Presses");
	addSubMenu("advanced/entr.htm", "Entry Stack");

	addMenu("DesignMenu", "design/index.htm", "Design");
	addSubMenu("design/desi.htm", "Design Process");
	addSubMenu("design/clea.htm", "Clean Code");

	addMenu("DownloadMenu", "misc/index.htm", "Download");
	addSubMenu("download/download.htm", "Samples & Tools");
	addSubMenu("misc/down.htm", "Offline Viewing");
	addSubMenu("misc/inde.htm", "Index");
	addSubMenu("misc/link.htm", "Link to Us");
	addSubMenu("opcodes/opcodes.htm", "Opcodes");
	addSubSubMenu("opcodes/opcodesN.htm", "Numbered");
	addSubSubMenu("opcodes/opcodesB.htm", "Byte Value");
	addSubMenu("recode/recode.htm", "Recode Exercises");
	addSubMenu("sources/sources.htm", "Sources");

	addMenu("VariablesMenu", "variables/index.htm", "Variables");
	addSubMenu("variables/ti86.htm", "TI86 Variables");
	addSubMenu("variables/vari.htm", "Variable Name Format");
	addSubMenu("variables/crea.htm", "Creating Variables");
	addSubMenu("variables/_fin.htm", "FindSym");
	addSubMenu("variables/abso.htm", "Absolute Addressing");
	addSubMenu("variables/mess.htm", "Messing with Data");
	addSubMenu("variables/bcd.htm", "BCD");
	addSubMenu("variables/floa.htm", "Floating Point Stack");
	addSubMenu("variables/vats.htm", "VAT Searches");
	addSubMenu("variables/exte.htm", "External Levels");
	addSubMenu("variables/op_m.htm", "OP Math");

	addMenu("MenusMenu", "menus/index.htm", "Menus");
	addSubMenu("menus/exec.htm", "Executing");
	addSubMenu("menus/crea.htm", "Creating");
	addSubMenu("menus/romm.htm", "ROM Menus");

	HTML +=	"</SPAN></SPAN>";
	if (Article)
		HTML += "<H1>" + TopicDesc + "</H1>";
	document.write(HTML);
	}

function CreateBottom()
	{
	if (Article == false) return false;
	HTML =	"<P ALIGN=CENTER><A HREF=#TOP><IMG SRC='../images/top.gif'></A>" +
		"<DIV STYLE='padding:5px;margin: 15 -20 0 -20;" +
		"background:" + optionsTB[2] + ";color:" +
		optionsTB[0] + "'><P STYLE='text-align:center;font:xx-small'>" +
		"Jimi Malcolm - Site Administrator - <A" +
		" HREF='mailto:malcolmj1@juno.com'>MalcolmJ1@Juno.com</A></DIV>";
	document.write(HTML);
	}

function addMenu(MenuID, URL, Text)
	{
	if (NotCompatable)
		{
		HTML += (Menus++ > 0? "|&nbsp" : "&nbsp")
			+ "<A HREF='" + formatURL(URL) + "'>" + Text + "</A>";
		return;
		}
	SubMenus = 0;	// zero sub menu counter
	MenuIDset[MenuIDset.length] = MenuID;
	HTML +=	Menus++ > 0? "</SPAN>|&nbsp" : "&nbsp";
	HTML +=	"<A" +
		" STYLE='cursor:hand;text-decoration:none;color:" + optionsTB[0] + "'" +
		" ONMOUSEOVER='this.style.color=\"" + optionsTB[1] + "\";" +
		"OverMouse(" + MenuID + ")'" +
		" ONMOUSEOUT='this.style.color=\"" + optionsTB[0] + "\";" +
		"OutMouse(" + MenuID + ")'" +
		" HREF CLASS=clsMenu>" + Text + "</A>&nbsp;" + "<SPAN" + " ID=" + MenuID +
		" ONMOUSEOUT='OffDropDown(" + MenuID + ")'" +
		" STYLE='border-left:1px solid #6699cc;" +
		"border-right:1px solid #003366;" +
		"border-bottom:1px solid #003366;" +
		"position:absolute;display:none;font:bold xx-small;width:160;" +
		"color:" + optionsTB[0] + ";background-color:" + optionsTB[2] +
		";padding: 0 5 5 5'>";
	}

function addSubMenu(URL, Text)
	{
	if (NotCompatable) return;
	HTML +=	(SubMenus > 0)? "<BR>" : "";
	HTML +=	"<A STYLE='text-decoration:none;color:" + optionsTB[0] + "'" +
		" ONMOUSEOVER='this.style.color=\"" + optionsTB[1] + "\"'" +
		" ONMOUSEOUT='OffDropDownA()'" +
		" HREF='" + formatURL(URL) + "'>" + Text + "</A>";
	SubMenus++;
	}

function addSubSubMenu(URL, Text)
	{
	if (NotCompatable) return;
	HTML +=	"<BR>&nbsp;&nbsp;<A" +
		" STYLE='text-decoration:none;color:" + optionsTB[0] + "'" +
		" ONMOUSEOVER='this.style.color=\"" + optionsTB[1] + "\"'" +
		" ONMOUSEOUT='OffDropDownA()'" +
		" HREF='" + formatURL(URL) + "'>" + Text + "</A>";
	}

function OffDropDown(MenuID)
	{
	MenuID.style.display = 'none';
	MenuDropped = false;
	}
function OffDropDownA(MenuID)
	{
	event.srcElement.style.color = optionsTB[0];
	if (event.offsetY >= 0)
		event.cancelBubble = true;
	}

function OutMouse(MenuID)
	{
	MouseX = event.clientX;

	x = event.srcElement.offsetLeft;
	xW = x + event.srcElement.offsetWidth;

	y = event.offsetY;

	OffLeft	=( MouseX-3 >= x )?	false : true;
	OffRight=( MouseX < xW )?	false : true;
	OffTop	=( y > 1 )?		false : true;

	if (OffLeft || OffRight || OffTop)
		for (i in MenuIDset)
			eval(MenuIDset[i] + ".style.display = 'none';");
	}

function OverMouse(MenuID)
	{
	for (i in MenuIDset)
		eval(MenuIDset[i] + ".style.display = 'none';");
	ObjectBase = event.srcElement;
	x = ObjectBase.offsetLeft + ObjectBase.offsetParent.offsetLeft - 7;
	y = ObjectBase.offsetHeight + 3;
	StyleBase = MenuID.style;
	StyleBase.top = y + 4;
	StyleBase.left = x;
	StyleBase.display = 'inline';
	MenuDropped = true;		// menu currently displayed
	}

function popup(URLstr, Titlestr)
	{
	Titlestr = Titlestr? Titlestr : "";
	window.open( URLstr, Titlestr, "dependant=yes,scrollbars=yes,height=500,width=750");
	}

function formatURL(URL)
	{
	return ((window.location.href.indexOf("index.html") == -1)? "../" : "" ) + URL;
	}

function SetColors(TxtColor, HoverColor, DrkBgColor)
	{
	optionsTB = Array(TxtColor, HoverColor, DrkBgColor);
	}

function FeaturedArticle(strTitle, strURL, strSection, strText, strDate)
	{
	document.write(	"<DIV STYLE='margin-bottom:15px'>" +
		"<H2 STYLE='font:bold 12px;margin-bottom:5px;margin-left:-5px'>" +
		"<A HREF='" + strURL + "'>" +
		strTitle + "</A> <SPAN STYLE='color:#5080b0'>" +
		strSection + "</SPAN></H2>" +
		strText + " <SPAN STYLE='color:#d0d0d0;font:bold xx-small'>" +
		strDate + "</SPAN></DIV>");
	}

function NewsItem(strTitle, strText, strDate, strURL, strSection)
	{
	strDate = strDate? " <SPAN STYLE='color:#d0d0d0;font:bold xx-small'>" +
		strDate + "</SPAN>" : "";
	strSection = strSection? " <SPAN STYLE='color:#5080b0'>" +
		strSection + "</SPAN>" : "";
	strTitle = strURL? "<A HREF='" + strURL + "'>" + strTitle + "</A>" : strTitle;

	document.write(	"<DIV STYLE='margin-bottom:15px'>" +
		"<H2 STYLE='font:bold 12px;margin-bottom:5px;margin-left:-5px'>"
		+ strTitle + "</A>" + strSection + "</H2>" + strText +
		strDate + "</DIV>");
	}

function ImageWindow(strURL, strTitle)
	{
	q = window.open();
	q.document.write("<TITLE>" + strTitle + "</TITLE><IMG SRC='" + strURL + "'>");
	}
