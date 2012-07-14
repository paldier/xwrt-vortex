﻿<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<html xmlns:v>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<link rel="shortcut icon" href="images/favicon.png">
<link rel="icon" href="images/favicon.png">
<title><#Web_Title#> - <#menu5_6_1_title#></title>
<link rel="stylesheet" type="text/css" href="index_style.css"> 
<link rel="stylesheet" type="text/css" href="form_style.css">
<link rel="stylesheet" type="text/css" href="usp_style.css">
<link rel="stylesheet" type="text/css" href="other.css">
<script language="JavaScript" type="text/javascript" src="/state.js"></script>
<script language="JavaScript" type="text/javascript" src="/jquery.js"></script>
<script language="JavaScript" type="text/javascript" src="/general.js"></script>
<script language="JavaScript" type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" language="JavaScript" src="/help.js"></script>
<script type="text/javascript" language="JavaScript" src="/detect.js"></script>
<script>
wan_route_x = '<% nvram_get("wan_route_x"); %>';
wan_nat_x = '<% nvram_get("wan_nat_x"); %>';
wan_proto = '<% nvram_get("wan_proto"); %>';

<% login_state_hook(); %>
var wireless = [<% wl_auth_list(); %>];	// [[MAC, associated, authorized], ...]
var sw_mode_orig = '<% nvram_get("sw_mode"); %>';
if(sw_mode_orig == 3 && '<% nvram_get("wlc_psta"); %>' == 1)
	sw_mode_orig = 2;

function initial(){
	show_menu();
	setScenerion(sw_mode_orig);
	Senario_shift();
	if(repeater_support < 0)
		$("repeaterMode").style.display = "none";
}

function Senario_shift(){
	var isIE = navigator.userAgent.search("MSIE") > -1; 
	if(isIE)
		$("Senario").style.width = "700px";
		$("Senario").style.marginLeft = "5px";
}

function saveMode(){
	if(sw_mode_orig == document.form.sw_mode.value){
		alert("<#Web_Title2#> <#op_already_configured#>");
		return false;
	}

	if(document.form.sw_mode.value == 3){
		parent.location.href = '/QIS_wizard.htm?flag=lanip';
		return false;
	}
	else if(document.form.sw_mode.value == 2){
		parent.location.href = '/QIS_wizard.htm?flag=sitesurvey';
		return false;
	}
	else{ // default router
		document.form.lan_proto.value = '<% nvram_default_get("lan_proto"); %>';
		document.form.lan_ipaddr.value = document.form.lan_ipaddr_rt.value;
		document.form.lan_netmask.value = document.form.lan_netmask_rt.value;
		document.form.lan_gateway.value = document.form.lan_ipaddr_rt.value;
		document.form.wlc_psta.value = 0;

		if(sw_mode_orig == '2'){
			close_guest_unit(0,1);
			if(band5g_support != -1)
				close_guest_unit(1,1);
		}
	}

	showLoading();	
	document.form.target="hidden_frame";
	document.form.submit();
}

function close_guest_unit(_unit, _subunit){
	var NewInput = document.createElement("input");
	NewInput.type = "hidden";
	NewInput.name = "wl"+ _unit + "." + _subunit +"_bss_enabled";
	NewInput.value = "0";
	document.form.appendChild(NewInput);
}

function done_validating(action){
	refreshpage();
}

var $j = jQuery.noConflict();
var id_WANunplungHint;

function setScenerion(mode){
	if(mode == '1'){
		document.form.sw_mode.value = 1;
		$j("#Senario").css("height", "");
		$j("#Senario").css("background","url(/images/New_ui/rt.jpg) center no-repeat");
		$j("#Senario").css("margin-bottom", "60px");
		$j("#radio2").hide();
		$j("#Internet_span").hide();
		$j("#ap-line").css("display", "none");	
		$j("#AP").html("<#Internet#>");
		$j("#mode_desc").html("<#OP_GW_desc#>");
		$j("#nextButton").attr("value","<#CTL_next#>");
		document.form.sw_mode_radio[0].checked = true;
	}	
	else if(mode == '2'){
		var pstaDesc =  "The RT-AC66U can be configured in Media bridge mode.";
				pstaDesc += "This mode provide multiple entertainment devices fastest 802.11ac wifi connection simultaneously.";
				pstaDesc += "To setup the Media bridge mode, you need two RT-AC66U routers, one configured as the Media station and the other as a router.";
				pstaDesc += "Setup the first RT-AC66U as router then configure the second RT-AC66U as 802.11ac Media bridge  and you can simply connect  PCs, Smart TV, game console, DVR, media player to Media bridge via Ethernet cable.";
				pstaDesc += "Upgrade your home entertainment device with low interference Gigabit Wi-Fi and avoid the separate Wi-Fi adapters for multiple devices at the same time.";
				pstaDesc += "<br/><span style=\"color:#FC0\">Install and use the <a href=\"http://dlcdnet.asus.com/pub/ASUS/wireless/ASUSWRT/Discovery.zip\" style=\"font-family:Lucida Console;text-decoration:underline;color:#FC0;\">Device Discovery Utility</a> in order to detect the <% nvram_get("productid"); %>'s IP address.</span>";

		document.form.sw_mode.value = 2;
		$j("#Senario").css("height", "300px");
		$j("#Senario").css("background", "url(/images/New_ui/re.jpg) center no-repeat");
		$j("#Senario").css("margin-bottom", "-20px");
		$j("#radio2").css("display", "none");
		$j("#Internet_span").css("display", "block");
		$j("#ap-line").css("display", "none");
		$j("#AP").html("<#Device_type_02_RT#>");
		$j("#mode_desc").html(pstaDesc);
		$j("#nextButton").attr("value","<#CTL_next#>");
		clearTimeout(id_WANunplungHint);
		$j("#Unplug-hint").css("display", "none");
		document.form.sw_mode_radio[1].checked = true;
	}
	else if(mode == '3'){
		document.form.sw_mode.value = 3;
		$j("#Senario").css("height", "");
		$j("#Senario").css("background", "url(/images/New_ui/ap.jpg) center no-repeat");
		$j("#Senario").css("margin-bottom", "60px");
		$j("#radio2").css("display", "none");
		$j("#Internet_span").css("display", "block");
		$j("#ap-line").css("display", "none");
		$j("#AP").html("<#Device_type_02_RT#>");
		$j("#mode_desc").html("<#OP_AP_desc#><br/><span style=\"color:#FC0\"><#deviceDiscorvy#></span>");
		$j("#nextButton").attr("value","<#CTL_next#>");
		clearTimeout(id_WANunplungHint);
		$j("#Unplug-hint").css("display", "none");
		document.form.sw_mode_radio[2].checked = true;
	}
	else{
		document.form.sw_mode.value = 1;
		$j("#Senario").css("height", "");
		$j("#Senario").css("background","url(/images/New_ui/gw.png) center no-repeat");
		$j("#Senario").css("margin-bottom", "60px");
		$j("#radio2").hide();
		$j("#Internet_span").hide();
		$j("#ap-line").css("display", "none");	
		$j("#AP").html("<#Internet#>");
		$j("#mode_desc").html("<#OP_GW_desc#>");
		$j("#nextButton").attr("value","<#CTL_next#>");
		document.form.sw_mode_radio[0].checked = true;
	}
}
</script>
</head>

<body onload="initial();" onunLoad="return unload_body();">
<div id="TopBanner"></div>
<div id="hiddenMask" class="popup_bg">
	<table cellpadding="5" cellspacing="0" id="dr_sweet_advise" class="dr_sweet_advise" align="center">
		<tr>
		<td>
			<div class="drword" id="drword" style="height:110px;"><#Main_alert_proceeding_desc4#> <#Main_alert_proceeding_desc1#>...
				<br/>
				<br/>
	    </div>
		  <div class="drImg"><img src="images/alertImg.png"></div>
			<div style="height:70px;"></div>
		</td>
		</tr>
	</table>
<!--[if lte IE 6.5]><iframe class="hackiframe"></iframe><![endif]-->
</div>

<div id="Loading" class="popup_bg"></div>

<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
<form method="post" name="form" id="ruleForm" action="/start_apply.htm">
<input type="hidden" name="productid" value="<% nvram_get("productid"); %>">
<input type="hidden" name="group_id" value="">
<input type="hidden" name="modified" value="0">
<input type="hidden" name="action_mode" value="apply">
<input type="hidden" name="action_script" value="restart_all">
<input type="hidden" name="action_wait" value="60">
<input type="hidden" name="prev_page" value="Advanced_OperationMode_Content.asp">
<input type="hidden" name="current_page" value="Advanced_OperationMode_Content.asp">
<input type="hidden" name="next_page" value="">
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>">
<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>">
<input type="hidden" name="flag" value="">
<input type="hidden" name="sw_mode" value="<% nvram_get("sw_mode"); %>">
<input type="hidden" name="lan_proto" value="<% nvram_get("lan_proto"); %>">
<input type="hidden" name="lan_ipaddr" value="<% nvram_get("lan_ipaddr"); %>">
<input type="hidden" name="lan_netmask" value="<% nvram_get("lan_netmask"); %>">
<input type="hidden" name="lan_gateway" value="<% nvram_get("lan_gateway"); %>">
<input type="hidden" name="lan_ipaddr_rt" value="<% nvram_get("lan_ipaddr_rt"); %>">
<input type="hidden" name="lan_netmask_rt" value="<% nvram_get("lan_netmask_rt"); %>">
<!-- AC66U's repeater mode -->
<input type="hidden" name="wlc_psta" value="<% nvram_get("wlc_psta"); %>">

<table class="content" align="center" cellpadding="0" cellspacing="0">
  <tr>
	<td width="17">&nbsp;</td>
	<td valign="top" width="202">
	  <div id="mainMenu"></div>
	  <div id="subMenu"></div>
	</td>
	
    <td valign="top">
	<div id="tabMenu" class="submenuBlock"></div>
		<!--===================================Beginning of Main Content===========================================-->
<table width="98%" border="0" align="left" cellpadding="0" cellspacing="0">
	<tr>
		<td valign="top" >
		
<table width="760px" border="0" cellpadding="5" cellspacing="0" class="FormTitle" id="FormTitle">
	<tr bgcolor="#4D595D" valign="top" height="100px">
	  	<td>
	  		<div>&nbsp;</div>
	  		<div class="formfonttitle"><#menu5_6_adv#> - <#menu5_6_1#></div>
	  		<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
		  	<div class="formfontdesc"><#OP_desc1#></div>

		</td>
	</tr>

	<tr>
	  <td bgcolor="#4D595D" valign="top" height="500px">
	<div style="width:95%; margin:0 auto; padding-bottom:3px;">
		<span style="font-size:16px; font-weight:bold;color:white;text-shadow:1px 1px 0px black">
			<input type="radio" name="sw_mode_radio" class="input" value="1" onclick="setScenerion(1);" <% nvram_match("sw_mode", "1", "checked"); %>><#OP_GW_item#>
			&nbsp;&nbsp;
			<span id="repeaterMode"><input type="radio" name="sw_mode_radio" class="input" value="2" onclick="setScenerion(2);" <% nvram_match("sw_mode", "2", "checked"); %>>Media bridge</span>
			&nbsp;&nbsp;
			<input type="radio" name="sw_mode_radio" class="input" value="3" onclick="setScenerion(3);" <% nvram_match("sw_mode", "3", "checked"); %>><#OP_AP_item#>
		</span>
		<div id="mode_desc" style="position:relative;display:block;margin-top:10px;margin-left:5px;height:60px;z-index:75;">
			<#OP_GW_desc#>
		</div>
		<br/>
		<br/>
		<div id="Senario" style="margin-top:40px; margin-bottom:60px;">
			<!--div id="ap-line" style="border:0px solid #333; width:133px; height:41px; position:absolute; background:url(/images/wanlink.gif) no-repeat;"></div-->
			<div id="Unplug-hint" style="border:2px solid red; background-color:#FFF; padding:3px;margin:0px 0px 0px 150px;width:250px; position:absolute; display:block; display:none;"><#web_redirect_suggestion1#></div>
		</div>	
	</div>
	<div class="apply_gen">
		<input name="button" type="button" class="button_gen" onClick="saveMode();" value="<#CTL_onlysave#>">
	</div>
	</td>
	</tr>
</table>
</td>


		</tr>
      </table>
		<!--===================================Ending of Main Content===========================================-->
	</td>
    <td width="10" align="center" valign="top">&nbsp;</td>
	</tr>
</table>
</form>
<form name="hint_form"></form>
<div id="footer"></div>
</body>
</html>
