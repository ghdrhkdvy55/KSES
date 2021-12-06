<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import ="egovframework.com.cmm.LoginVO" %>
<%@ page import ="java.util.List" %>
<%@ page import ="java.util.Map" %>
<%
LoginVO loginVO = (LoginVO)session.getAttribute("LoginVO");
if(loginVO == null ){
	
	%>
	<script type="text/javascript">
	location.href="/backoffice/login.do";
	</script>
	<%        
}else{ 
	
	
	
	%> 
    
<div class="header_wrap">
	
	
	<header>
		<ul id="header" class="contents">
        	<li class="logo"><h1>경륜경정 스마트 입장시스템</h1></li>
        	<li class="toggle"><a href="#" onclick="toggleNav()" class="menu"></a></li>
        	<li class="logo1"><img src="/resources/img/logo1.png" alt=""></li>
        	<li class="logout"><img src="/resources/img/logout.png" alt="로그아웃"><a href="/backoffie/actionLogout.do">로그아웃</a></li>
        	<li class="member"><img src="/resources/img/login.png" alt=""><span><%=loginVO.getAdminId() %></span> 님</li>
      	</ul>
    </header>
    <!--top //-->
    <!--// menu list -->
    <script type="text/javascript">
    $(document).ready(function() { 
    	   fn_menuCreate();
	});
	function fn_menuCreate (){
		var url = window.location.pathname+window.location.search;
		var menu = uniAjaxReturn("/backoffice/inc/user_menu.do", "POST", false, null,  "lst");
		for (var i in menu){	
			 if  (menu[i].level == "2"){
				 var ul_list = $("#ul_leftMenu"); //ul_list선언
				 ul_list.append("<li id='menu_li_"+menu[i].menu_no+"'></li>");
				 $("#menu_li_"+menu[i].menu_no+"").append("<button type='button' onClick='fn_menuClick("+menu[i].menu_no+")' class='sub_menu' id='menu_bn_"+menu[i].menu_no+"'>"+menu[i].menu_nm+"</button>");
				 $("#menu_bn_"+menu[i].menu_no +"").after("<div id='menu_dv_"+menu[i].menu_no+"' class='panel'></div>");
			 }else {
				 var dv_list = $("#menu_dv_"+menu[i].upper_menu_no+""); //ul_list선언
				 var active = "";
				 //console.log("menu[i].url:" +menu[i].url + ":" + url);
				 if (menu[i].url == url){
					 active = "active";
					 fn_menuClick(menu[i].upper_menu_no);
				 }
				 dv_list.append("<a href='"+menu[i].url+"' id='"+menu[i].menu_no+"' class="+active+">"+menu[i].menu_nm+"</a>");
			 }
		 }
		toggleNav();
	}
    function fn_menuClick(id){
    	var acc = document.getElementsByClassName("sub_menu");
    	var i;
    	for (i = 0; i < acc.length; i++) {
    		acc[i].classList.toggle("toggle_off");
    		var panel = acc[i].nextElementSibling;
    		panel.style.display = "none";
    		
    	}
    	var block_pn = ($("#menu_dv_"+id).prop('style') == "block") ? "display:none" : "display:block";
    	$("#menu_bn_"+id).prop('class','sub_menu toggle_on');
    	$("#menu_dv_"+id).prop('style', block_pn); 
    	
    }
	
    </script>
    
    
    <div id="mySidenav" class="sidenav">
		<ul id="ul_leftMenu">
			                                
		</ul>
	</div>
    <!-- menu list //-->
</div>
 <%
     }
 %>
 