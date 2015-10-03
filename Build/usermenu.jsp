<%@page import="javax.mail.Session"%>
<%@page language="java" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="epayslip.db.*"%>
<%@page import="epayslip.system.*"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="catalog.utility.CR"%>
<%@page import="java.util.Date,java.text.SimpleDateFormat" %> 
<%@page import="catalog.Catalog"%>
<%-- <%@page import="com.iadmin.epayslip.security.UserSession" %> --%>
<%@ taglib uri="/WEB-INF/fmt.tld" prefix="fmt" %>
 
 <!-- Task ID : 5186 gettig language from session. -->
<%
String langu;
String l = request.getParameter("lang");
String l2;
if(l==null){
l2  = (String)session.getAttribute(User.LOCAL);
System.out.println("local2 from Session--------"+l2);
}else{
	session.setAttribute(User.LOCAL, l);
     l2  = (String)session.getAttribute(User.LOCAL);
	System.out.println("local2 from Session--------"+l2);
}

%>
<fmt:setBundle basename="<%=l2%>" scope="request"/>

<!-- ended Task ID : 5186 -->
<%
//Note: The pre-condition must be follow, otherwise empty boxes, because nothing to display
    //pre-condition: startYear <= end Year
    
    int startYear = EPaySlipController.getMenuStartYear(); //fixed
    Calendar cal = Calendar.getInstance();
    int curYear = cal.get(Calendar.YEAR);
    int curMonth = cal.get(Calendar.MONTH) + 1;
    int curDay = cal.get(Calendar.DATE);
    
    int endYear = curYear;
    int endMonth;
    
    Integer payDay = (Integer)session.getAttribute(User.LOGIN_PDAY);
    if(curDay>=payDay.intValue()-1) /* suitable for any day other than day 1*/
    {
        endMonth = curMonth;
    }else
    {
        endMonth = curMonth-1;
    }
    
    if(endMonth==0) //for January, not until pay day, only display last year
    {
        endYear = curYear-1;
        endMonth = 12;
    }
    

        endMonth=curMonth+1;
        if(endMonth==13)
        {
            endYear=curYear+1;
            endMonth = 1;
        }
    
    
///////////////////////////////////write by tianli at 29/12/04//////////////////////////////////////////////////////////////////////

   String empId = (String)session.getAttribute("LOGIN_PID");

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    String groupid = (String)session.getAttribute(User.LOGIN_GROUPID);
    String GivenNameSurNameCompanies = null;
    try {
        ResourceBundle companyConfig = ResourceBundle.getBundle("Company");
        GivenNameSurNameCompanies = companyConfig.getString("GivenNameSurName");
    }
    catch (MissingResourceException e) {
       System.out.println("Missing Resource file company.properties");
    }

    String fullName;
    if ((GivenNameSurNameCompanies != null) && (GivenNameSurNameCompanies.indexOf(groupid) > -1)) {
        fullName = (String)session.getAttribute(User.LOGIN_GIVENNAME) + " " + 
                   (String)session.getAttribute(User.LOGIN_SURNAME);
    } else {
        fullName = (String)session.getAttribute(User.LOGIN_SURNAME) + " " +
                   (String)session.getAttribute(User.LOGIN_GIVENNAME);
    }
    
    String logoLink = (String)session.getAttribute("LOGO_LINK");
    if(logoLink==null)
    {
        logoLink = "";
    }

    String companyEmail = (String)session.getAttribute("COMPANY_EMAIL");
    if(companyEmail==null)
    {
        companyEmail = "";
    }
    
String sesInv = (String)session.getAttribute("SESINV");
String dummystr = (String) request.getAttribute("DUMMYSTR")==null?"":(String) request.getAttribute("DUMMYSTR");
String dummyAdvice = (String) request.getAttribute("DUMMYADVICE")==null?"":(String) request.getAttribute("DUMMYADVICE");
SimpleDateFormat df=new SimpleDateFormat("yyyy");
String curyear=df.format(new Date());        
%>
<html>
<head>
<title><fmt:message key="eayslip.tan.title.name"/></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="/epayslip/bg.css" type="text/css">
<link rel="stylesheet" href="/epayslip/text.css" type="text/css">
<style>
A:link {text-decoration:none; color:#FF9900; }
A:visited {text-decoration:none; color:#FF9900; }
A:hover	{text-decoration:none; color:#bbbbbb}
.style3 {
        color: #1941A5;
        font-weight: bold;
}
</style>
<script src="/epayslip/pyscript.js"></script>
<script src="/epayslip/imageutil.js"></script>
<script type="text/javascript" src="/epayslip/jquery-1.2.3.js"></script>
<script language="javascript">

function closeMe()
{
    var conf = confirm('<fmt:message key='epayslip.confirm.logout'/>');//
    if (conf)
        document.ssologout.submit();
}

function onYearChange()
{
    var oObject = document.menu.year;
<%  if(endYear>startYear) { 
%>
	    if(oObject.options[oObject.selectedIndex].value!=<%=endYear%>)
	    {
	        var allOption = document.menu.month.options;
	        removeAllOption(allOption);
	        addOption(allOption,12,0);
	    }else
	    {
	        var allOption = document.menu.month.options;
	        removeAllOption(allOption);        
	        addOption(allOption,<%=endMonth%>,<%=curMonth%>);
	    }
    
<% } else if(endYear==startYear) { 
%>
        var allOption = document.menu.month.options;
        removeAllOption(allOption);
        addOption(allOption,<%=endMonth%>,<%=curMonth%>);
<% } 
%>   
 
    onMonthChange();
}

function changeDefaultYear()
{
    var yrOptions = document.menu.year.options;
<%	if ( CR.isNN(session.getAttribute( "currentyear" )) ) {
%>
		document.menu.year.value='<%=(String)session.getAttribute( "currentyear" )%>';
<%	} else { 
%>
    	document.menu.year.value= <%=curYear%>;
    	//document.menu.year.selectedIndex = yrOptions.length - 1;
<%  } 
%>
}
function changeDefaultMonth()
{
    var mthOptions = document.menu.month.options;
<%  
	String cm = (String)session.getAttribute( "currentmonth" );
	
if ( cm!=null) {
%>
		document.menu.month.value = <%=cm%>;
		
<%	} else { %>

		document.menu.month.value = <%=curMonth%>;
		//document.menu.month.selectedIndex = mthOptions.length - 1;
   
<%  } %>
}

function removeAllOption(allOption)
{
    //Remove all element
    var len = allOption.length;
    for(i=0;i<len;i++)
    {
        allOption[0] = null;
    }
}

function addOption(allOption,no,cur)
{
	var January1= "<fmt:message key='epayslip.January'/>";
    var February2= "<fmt:message key='epayslip.February'/>";
    var March3= "<fmt:message key='epayslip.March'/>";
    var April4= "<fmt:message key='epayslip.April'/>";
    var May5= "<fmt:message key='epayslip.May'/>";
    var June6= "<fmt:message key='epayslip.June'/>";
    var July7= "<fmt:message key='epayslip.July'/>";
    var August8= "<fmt:message key='epayslip.August'/>";
    var September9= "<fmt:message key='epayslip.September'/>";
    var October10= "<fmt:message key='epayslip.October'/>";
    var November11= "<fmt:message key='epayslip.November'/>";
    var December12= "<fmt:message key='epayslip.December'/>";
    
    var arr = new Array(January1,February2,March3,April4,May5,June6,July7,August8,September9,October10,November11,December12);
     
    for(i=0;i<no;i++)
    {   if(i==no-1){
            oOption = new Option(arr[i], i+1);
            allOption[i] = oOption;
            if(cur==0)
             allOption[i].selected = true;
            else
                if(i==0)
                	allOption[i].selected = true;
                else
                    allOption[i-1].selected = true;
        }else{
            oOption = new Option(arr[i], i+1, false, false);
            allOption[i] = oOption;
        }
        
    }
}

function onMonthChange(){
	var jyear = menu.year.value;
	var jmonth = menu.month.value;
	$("#chym").replaceWith('<div id=\"chym\"><fmt:message key='epayslip.loading'/></div>'); 
	$.ajax({
	   type: "POST",
	   url: "CheckForYM?year="+jyear+"&month="+jmonth,
	   success: function(msg){
	     $("#chym").replaceWith(msg);  
	   }
	});
}

function openReadWindow(link) {
	var wind = window.open(link,'epayslip','width=screen.availWidth,height=screen.availHeight,toolbar=0,location=0,menubar=0,scrollbars=1,resizable=1');
	//wind.document.title="epayslip";
}

function doAdviceSubmit(){
	document.menu.event.value = 'MPF_ORSO_ADVICE_FORM_INTERFACE';
	document.menu.submit();
}
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" class="BG" 
onLoad="MM_preloadImages('../images/button2ov.gif','../images/button2ov.gif','../images/on_epayslip.gif','../images/on_ememo.gif','../images/on_etax.gif','../images/on_etimesheet.gif')">
<div align="center">
  <table width="610" border="0" cellspacing="0" cellpadding="0" height="92">
    <tr>
<% if(logoLink.equals("")){ %>
      <td width="155"><img src="../images/epaysmal.gif" width="146" height="92"></td>
<% } else if(groupid.equals("PAYPINA")){%>
<td width="255" align=middle><img src="<%=logoLink%>" width="176" height="50"></td>
<% } else if(groupid.equals("PAYLINDYWILLIAMS")){%>
      <td width="155" align=middle><img src="<%=logoLink%>" width="320" height="92"></td>
<td width="455"><img src="../images/topbar.jpg" width="350" height="92"></td>
<% } else if(groupid.equals("PAYSMU")){%>
      <td width="155" align=middle><img src="<%=logoLink%>" width="280" height="122"></td>
<% } else if(empId.equals("idemo")){%>
<td width="155" align=middle><img src="../images/iadmin.gif" width="170" height="92"></td>
<td width="455"><img src="../images/topbar.jpg" width="455" height="92"></td>
<% } else  if(groupid.equals("PAYMERCEDES")){%>
<% } else{%>
<td width="155" align=middle><img src="<%=logoLink%>" width="170" height="92"></td>
<td width="455"><img src="../images/topbar.jpg" width="455" height="92"></td>
<%}%>
    </tr>
  </table>
  
  <%--  <% if(!groupid.equals("PAYMERCEDES")){%>
   <jsp:include page="menu.jsp" flush="true" />
<%}else{%>
<br><br><br>
<%}%> --%>
<br><br><br>
  <table width="600" border="0" cellspacing="0" cellpadding="5" height="40">
    <tr>
      <td background="/epayslip/images/blank_bar.gif" valign="bottom">
         <font class="USR"></font>
      </td>
    </tr>
  </table>
  <table width="600" border="0" cellspacing="0" cellpadding="5">
    <tr>
      <td bgcolor="#CCCCCC">
      
      <fmt:message key="epayslip.welcome"/> <%=fullName%>.</td>
	<td bgcolor="#CCCCCC" align="right"></td>

    </tr>
    <tr>
      <td colspan="2" bgcolor="#dddddd">
        <% if (groupid.equals("HR_ADMIN")) {%>
        <!-- Task ID : 5186 welcome message -->
            <p><fmt:message key="epayslip.welcome.select.year.month"/></p>
        <% } else {%>
            <p><fmt:message key="epayslip.select.year.month.for.you"/></p>
        <%} %>
        
        <br>
<form name="menu" method="post" action="/epayslip/servlet/EPSController">
<%//===============================================================================
    if (groupid.equals("HR_ADMIN")) {
%>
                <input type="hidden" name="event" value="VIEW_PAYSLIP_LIST">
<%  } else {%>
		<input type="hidden" name="event" value="VIEW_PAYSLIP">
			<%-- 
			<%  if(groupid.equals("PAYCITIHK")&&!empId.equals("idemo")){
			%>
			                <input type="hidden" name="event" value="VIEW_PAYSLIP_CITIHK">
			<%	}
			%>
			
			<%  if(groupid.equals("PAYMERCEDES")){
			%>
			                <input type="hidden" name="event" value="VIEW_PAYSLIP_MERCEDES">
			<%	}
			%>
			
			<%  if(groupid.equals("PAYCITISG")){
			%>
			                <input type="hidden" name="event" value="VIEW_PAYSLIP_CITISG">
			<%	}
			%>
			
			<%  if(groupid.equals("PAYGETHAI_INT")){
			%>            
							 <input type="hidden" name="event" value="VIEW_PAYSLIP_GETHAI">      
			<%	}
			%>
			
			<%  if(groupid.equals("PAYSUN")){
			%>            
							 <input type="hidden" name="event" value="VIEW_PAYSLIP_PAYSUN">      
			<%}//===============================================================================
			%>
			
			<%  if(!groupid.equals("PAYCITIHK")||empId.equals("idemo")){
			%>            
							 <input type="hidden" name="event" value="VIEW_PAYSLIP">      
			<%}//===============================================================================
			 --%>
 <%}%>

<table width="240" border="0" cellspacing="0" cellpadding="0" align="center">
          <tr> 
            <td width="70"> 
				<select name="year" onChange="onYearChange()" tabindex = "1">
                          <% for(int i=startYear;i<=endYear;i++) {%>
                          <option value="<%=i%>"><%=i%></option>
                          <% } %>
                        </select>
            </td>
            <td width="120">
            <% if (groupid.equals("HR_ADMIN")) {%>
	            <select name="month" >
	                                
	        <% } else {%>
	            <select name="month" id="mth1" tabindex = "2" onchange="onMonthChange();">
	        <%} %>
              <!-- Task ID : 5186 for Months -->
                        <option value="01"><fmt:message key="epayslip.January"/></option>
                        <option value="02"><fmt:message key="epayslip.February"/></option>
                        <option value="03"><fmt:message key="epayslip.March"/></option>
                        <option value="04"><fmt:message key="epayslip.April"/></option>
                        <option value="05"><fmt:message key="epayslip.May"/></option>
                        <option value="06"><fmt:message key="epayslip.June"/></option>
                        <option value="07"><fmt:message key="epayslip.July"/></option>
                        <option value="08"><fmt:message key="epayslip.August"/></option>
                        <option value="09"><fmt:message key="epayslip.September"/></option>
                        <option value="10"><fmt:message key="epayslip.October"/></option>
                        <option value="11"><fmt:message key="epayslip.November"/></option>
                        <option value="12"><fmt:message key="epayslip.December"/></option>                       
                        </select>

            </td>
            <% if (groupid.equals("HR_ADMIN")) {%>
	            <td width="50"><input type="image" border="0" name="submit" src="/epayslip/images/button2.gif" width="41" height="41" tabindex = "3"></td>
	        <% } else { if("".equals(dummyAdvice)){%>
	        	<%if(!dummystr.equals("")) {%>
	        		<td width="50"><div id="chym"><a href="#" onclick="openReadWindow('<%=dummystr %>');return false;"><img border="0" src="/epayslip/images/button2.gif" width="41" height="41" /></a></div></td>
	        	<%}else{ %>
	        		<td width="50"><div id="chym"><input type="image" border="0" name="submit" src="/epayslip/images/button2.gif" width="41" height="41" tabindex = "3"></div></td>
	        	<%}}else{ %>
	        		<td width="50"><div id="chym"><input onclick="doAdviceSubmit();" type="image" border="0" name="submit" src="/epayslip/images/button2.gif" width="41" height="41" tabindex = "3"></div></td>
	         <%}} %>
            
          </tr>
        </table>
        </form>
        <br><br>
        </td>
    </tr>
    <tr>
      <% String browser = request.getHeader("User-Agent");
    %>
    </tr>
  </table>
  <table width="600" border="0" cellspacing="0" cellpadding="0" height="23" background="/epayslip/images/bottbar.gif">
    <tr>
      <td>
        <table width="585" border="0" cellspacing="0" cellpadding="0" align="center">
          <tr>
            <td width="436">
               <%-- <% //if (sesInv == null) {%>
               <a href="javascript:document.userdetails.submit()">UPDATE <b>USER</b> DETAILS</a>
               <% //} %>--%>
            </td>
            <td width="400">
             <!-- Task ID : 5186 for back to main menu ehr system -->
              <div align="right"><a href="javascript:document.ssomenu.submit()"><fmt:message key="epayslip.back.button1"/><b> <fmt:message key="epayslip.back.button2"/> </b></a>&nbsp;|&nbsp;<a href="javascript:closeMe()"><b><fmt:message key="epayslip.logout.button"/></b></a></div>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
  <br>
  <table width="320" border="0" cellspacing="0" cellpadding="0" height="60">
    <tr> 
      <td width="90" align="center" height="64">
      <!-- Task ID : 5186 for img -->
      <% if(l2.equalsIgnoreCase("i18n_en")) 
      {
      %>
      <img src="/epayslip/images/epaysmall2.gif" width="82" height="31">
      <%}else{ %>
       <img src="/epayslip/images/epaysmall2.gif" width="82" height="31">
      <%} %>
      </td>
    <td width="230" align="center" valign="middle" height="64">
     <!-- Task ID : 5186 for all right reserved for i-admin -->
        <font size="1" face="Verdana">&#149; &nbsp;
        &copy; <%=curyear%> <fmt:message key="epayslip.iadmin.all.rights.reserved"/></font><br><br>
    </td>
    </tr>
  </table>
  <p>&nbsp;</p>
</div>
<%-- <form name="userdetails" method="post" action="/epayslip/servlet/EPSController">
  <input type="hidden" name="event" value="UPDATEDETAILS_FORM">
</form>--%>
<form name="ssomenu" method="post" action="/epayslip/servlet/EPSController" enctype="UTF-8">
  <input type="hidden" name="event" value="SSOMENU">
</form>
<form name="ssologout" method="post" action="/epayslip/servlet/EPSController">
  <input type="hidden" name="event" value="SSOLOGOUT">
</form>
<p>
  <script language="javascript">
changeDefaultYear();
onYearChange();
changeDefaultMonth();
onMonthChange();
</script>
</p>

</body>
</html>
