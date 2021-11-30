<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="viewport" content="initial-scale=1.0; maximum-scale=1.0; minimum-scale=1.0; user-scalable=no;" />
    <title>경륜경정 스마트입장 관리자</title>
    <link rel="stylesheet" href="/resources/css/reset.css">
	<link rel="stylesheet" href="/resources/css/paragraph.css">
    <link rel="stylesheet" href="/resources/css/common.css">
    <link rel="stylesheet" href="/resources/css/toggle.css">
    <script src="/resources/js/jquery-3.5.1.min.js"></script>
    <script src="/resources/js/bpopup.js"></script>
    <script>
	jQuery.browser = {};
	(function () {
	    jQuery.browser.msie = false;
	    jQuery.browser.version = 0;
	    if (navigator.userAgent.match(/MSIE ([0-9]+)\./)) {
	        jQuery.browser.msie = true;
	        jQuery.browser.version = RegExp.$1;
	    }
	})();
	</script>
    <link rel="stylesheet" type="text/css" href="/resources/css/jquery-ui.css">
    <link rel="stylesheet" type="text/css" href="/resources/jqgrid/src/css/ui.jqgrid.css">
    <script type="text/javascript" src="/resources/jqgrid/src/i18n/grid.locale-kr.js"></script>
    <script type="text/javascript" src="/resources/jqgrid/js/jquery.jqGrid.min.js"></script>
    <style type="text/css">
     .ui-jqgrid .ui-jqgrid-htable th div{
		outline-style: none;
		height: 30px;
	 }
     .ui-jqgrid tr.jqgrow {
		outline-style: none;
		height: 30px;
	}
    </style>
    <script type="text/javascript">
	$(document).ready(function() { 
		   jqGridFunc.setGrid("mainGrid");
	 });
	
	
    var jqGridFunc  = {
    		
    		setGrid : function(gridOption){
    			var grid = $('#'+gridOption);
    		    var postData = {"pageIndex": "1"};
    		    grid.jqGrid({
    		    	url : '/backoffice/bas/menuListAjax.do' ,
    		        mtype :  'POST',
    		        datatype :'json',
    		        
    		        ajaxGridOptions: { contentType: "application/json; charset=UTF-8" },
    		        ajaxRowOptions: { contentType: "application/json; charset=UTF-8", async: true },
    		        ajaxSelectOptions: { contentType: "application/json; charset=UTF-8", dataType: "JSON" }, 
    		       
    		        postData :  JSON.stringify( postData ),
    		        jsonReader : {
	   		             root : 'resultlist',
	   		             "page":"paginationInfo.currentPageNo",
	   		             "total":"paginationInfo.totalPageCount",
	   		             "records":"paginationInfo.totalRecordCount",
	   		             repeatitems:false
   		            },
    		        colModel :  [
    		        	            { label: '메뉴ID',  key: true, name:'menu_no', index:'menu_no',  align:'left',   width:'10%'},
	    		 	                { label: '메뉴한글명',  name:'menu_nm', index:'menu_nm', align:'left',   width:'10%'},
	    		 	                { label: '프로그램파일명',  name:'progrm_file_nm',  index:'progrm_file_nm', align:'left',   width:'10%'},
	    		 	                { label: '메뉴설명', name:'menu_dc', index:'menu_dc', align:'center', width:'12%'},
	    		 	                { label: '상위메뉴ID', name:'upper_menu_no', index:'upper_menu_no', align:'center', width:'12%'}
    			                ],  //상단면 
    		        rowNum : 100,  //레코드 수
    		        rowList : [10,20,30,40,50,100],  // 페이징 수
    		        //페이징 사용 안함
    		        //pager: $('#pager'),  
    		        //pager : pager,
    		        viewrecord : false,    // 하단 레코드 수 표기 유무
    		        
    		        refresh : true,
    	            rownumbers : false, // 리스트 순번
    		        //loadonce : false,     // true 데이터 한번만 받아옴 
    		        loadui : "enable",
    		        loadtext:'데이터를 가져오는 중...',
    		        emptyrecords : "조회된 데이터가 없습니다", //빈값일때 표시 
    		        height : "100%",
    		        autowidth:true,
    		        shrinkToFit : true,
    		        refresh : true,
    		        multiselect:true, 
    		        loadComplete : function (data){
    		        	 $("#sp_totcnt").text(data.paginationInfo.totalRecordCount);
    		        	 var rowIds  = $("#listRepairLoaner").jqGrid('getDataIDs');
    		        	    for( var n = 0; n <= rowIds.length; n++ ) {
    		        	        var rowId = rowIds[n];
    		        	        //cbox라는 class를 적용받는데 해당 class에서 선택을 방지
    		        	        $("#jqg_listRepairLoaner_"+rowId).removeClass("cbox");
    		        	    }
    		        }, beforeSelectRow: function (rowid, e) {
    		            var $myGrid = $(this);
    		            var i = $.jgrid.getCellIndex($(e.target).closest('td')[0]);
    		            var cm = $myGrid.jqGrid('getGridParam', 'colModel');
    		            return (cm[i].name == 'cb'); // 선택된 컬럼이 cb가 아닌 경우 false를 리턴하여 체크선택을 방지
    		        }, loadError:function(xhr, status, error) {
    		            alert("loadError:" + error); 
    		        },onSelectRow: function(rowId){
    	                if(rowId != null) {  }// 체크 할떄
    	            },ondblClickRow : function(rowid, iRow, iCol, e){
    	            	grid.jqGrid('editRow', rowid, {keys: true});
    	            },onCellSelect : function (rowid, index, contents, action){
    	            	var cm = $(this).jqGrid('getGridParam', 'colModel');
    	                //console.log(cm);
    	                if (cm[index].name=='menu_no' || cm[index].name=='menu_nm' || cm[index].name=='progrm_file_nm'){
    	                	jqGridFunc.fn_MenuInfo("Edt", $(this).jqGrid('getCell', rowid, 'menu_no'));
            		    }
    	            }
    		    });
    		}, rowBtn: function (cellvalue, options, rowObject){
               if (rowObject.menu_no != "")
            	   return "<a href='javascript:jqGridFunc.delRow(\""+rowObject.menu_no+"\");'>삭제</a>";
            }, delRow : function () {
            	
            } , refreshGrid : function(){
	           $('#mainGrid').jqGrid().trigger("reloadGrid");
	        }, fn_search: function(){
	    	    $("#mainGrid").setGridParam({
	    	    	 datatype	: "json",
	    	    	 postData	: JSON.stringify(  {
	    	    		"pageIndex": $("#pager .ui-pg-input").val(),
	         			"searchKeyword" : $("#searchKeyword").val(),
	         			"pageUnit":$('.ui-pg-selbox option:selected').val()
	         		}),
	    	    	loadComplete	: function(data) {$("#sp_totcnt").text(data.paginationInfo.totalRecordCount);}
	    	     }).trigger("reloadGrid");
	        }, clearGrid : function() {
                $("#mainGrid").clearGridData();
            }, fn_MenuInfo : function (mode, menuNo){
            	
            	$("#mode").val(mode);
        	    if (mode == "Edt"){
		        	$("#menuNo").val(menuNo).prop('readonly', true);
		        	$("#btnUpdate").text("수정");
		        	var params = {"menuNo" : menuNo};
		        	var url = "/backoffice/bas/menuDetailInfo.do";
		        	fn_Ajax(url, "GET", params, false, 
			          	    function(result) {
	     				       if (result.status == "LOGIN FAIL"){
		 				    	   common_popup(result.meesage, "Y", "bas_menu_add");
		   						   location.href="/backoffice/login.do";
	       					   }else if (result.status == "SUCCESS"){
       						       var obj  = result.regist;
       						       
       						      
       						       $("#menuNm").val(obj[0].menu_nm);
       						       $("#progrmFileNm").val(obj[0].progrm_file_nm);
       						       $("#upperMenuNo").val(obj[0].upper_menu_no);
       						       $("#menuOrdr").val(obj[0].menu_ordr);
       						       $("#menuDc").val(obj[0].menuDc);
       						       $("#btnSave").text("수정");
	       					   }else{
	       						   common_modelCloseM(result.message, "bas_menu_add");
	       					   }
			     			},
			     			function(request){
			     			    common_modelCloseM("ERROR : " +request.status, "bas_menu_add");
			     			}
		               );
		        }else{
		        	$("#menuNo").val('').prop('readonly', false);
		        	$("#menuNm").val('');
				    $("#progrmFileNm").val('');
				    $("#upperMenuNo").val('0');
				    $("#menuOrdr").val('');
				    $("#menuDc").val('');
		        	$("#btnUpdate").text("입력");
		        }
        	    $("#bas_menu_add").attr("style","width:900px;");
        	    jqGridFunc.fn_programView('I');
		        $("#bas_menu_add").bPopup();
           },fn_CheckForm  : function (){
        	   if (any_empt_line_span("bas_menu_add", "menuNo", "프로그램를 입력해 주세요.","sp_message", "savePage") == false) return;
        	   if (any_empt_line_span("bas_menu_add", "menuNm", "프로그램를 입력해 주세요.","sp_message", "savePage") == false) return;
        	   if (any_empt_line_span("bas_menu_add", "progrmFileNm", "프로그램 명을 입력해 주세요.","sp_message", "savePage") == false) return;
			   if (any_empt_line_span("bas_menu_add", "upperMenuNo", "upperMenuNo을 입력해 주세요.","sp_message", "savePage") == false) return;
			   
		       var url = "/backoffice/bas/menuRegistUpdate.do";
		       
		       var params = {    'menuNo' : $("#menuNo").val(),
				    		     'menuNm' : $("#menuNm").val(),
				    		     'progrmFileNm' : $("#progrmFileNm").val(),
				    		     'upperMenuNo' : $("#upperMenuNo").val(),
				    		     'menuOrdr' : $("#menuOrdr").val(),
				    		     'menuDc' : $("#menuDc").val(),
				    		     'mode' : $("#mode").val()
		    	               }; 
		       fn_Ajax(url, "POST", params, false,
		      			function(result) {
		 				       if (result.status == "LOGIN FAIL"){
		 				    	   common_popup(result.meesage, "Y","bas_menu_add");
		   						   location.href="/backoffice/login.do";
		   					   }else if (result.status == "OVERLAP FAIL" ){
		   						    common_popup(result.meesage, "N", "bas_menu_add");
		   						   jqGridFunc.fn_search();
		   					   }else if (result.status == "SUCCESS"){
		   						   //총 게시물 정리 하기'
		   						   common_modelCloseM(result.message, "bas_menu_add");
		   						   jqGridFunc.fn_search();
		   					   }else if (result.status == "FAIL"){
		   						   common_popup("저장 도중 문제가 발생 하였습니다.", "Y", "bas_menu_add");
		   						   jqGridFunc.fn_search();
		   					   }
		 				    },
		 				    function(request){
		 					    common_popup("Error:" + request.status, "Y", "bas_menu_add");
		 				    }    		
		        );
		  }, fn_programView : function(gubun){
			  if (gubun == "P"){
				  $("#tb_menuInfo").hide();
				  $("#tb_programLst > tbody").empty();
				  $("#txt_programSearch").val("");
				  
				  $("#tb_programLstSearch").show();
				  $("#tb_programLst").show();
			  }else if (gubun == "S"){
				  $("#tb_menuInfo").hide();
				  $("#tb_programLstSearch").show();
				  $("#tb_programLst").show();
			  }else {
				  $("#tb_menuInfo").show();
				  $("#tb_programLstSearch").hide();
				  $("#tb_programLst").hide();
			  }
		  } , fn_programLstSearch : function (){
			  if (any_empt_line_span("bas_menu_add", "txt_programSearch", "프로그램를 입력해 주세요.","sp_message", "savePage") == false) return;
			  var params = {"searchKeyword" : $("#txt_programSearch").val()};
			  var returnval = uniAjaxReturn("/backoffice/bas/progrmListAjax.do", "POST", false, params,  "lst");
			  if (returnval != ""){
				  $("#tb_programLst > tbody").empty();
				  for (var i in returnval){		
					  var progrm_path = returnval[i].progrm_stre_path != undefined ? returnval[i].progrm_stre_path  : "";
					  
					  html  = "<tr onClick='jqGridFunc.fn_programeChoice(\""+returnval[i].progrm_file_nm+"\")'>"
							+ "   <td>" + returnval[i].progrm_file_nm + "</td>"
							+ "   <td>" + progrm_path + "</td>"
							+ "   <td>" + returnval[i].progrm_koreannm + "</td>"
							+ " </tr>";		   					
					  $("#tb_programLst > tbody").append(html);
					  html = "";
				  }
			  }
			  //외 닫히는지 모르겠음
			  $("#bas_menu_add").attr("style","width:900px;");
      	      jqGridFunc.fn_programView('S');
		      $("#bas_menu_add").bPopup();
		  }, fn_programeChoice : function (programFileNm){
			  $("#progrmFileNm").val(programFileNm);
			  jqGridFunc.fn_programView('I');
		  }, fn_menuDel : function(){
			  
			  var menuArray = new Array();
			  getEquipArray("mainGrid", menuArray);
			  if (menuArray.length > 0){
				  $("#hid_DelCode").val(menuArray.join(","))
				  $("#id_ConfirmInfo").attr("href", "javascript:jqGridFunc.fn_del()");
				  menuArray = null;
       		      fn_ConfirmPop("삭제 하시겠습니까?");
			  }else {
				  menuArray = null;
				  common_modelCloseM("체크된 값이 없습니다.", "savePage");
			  }
			  
		  }, fn_del : function (){
			  var params = {'checkedMenuNoForDel': $("#hid_DelCode").val() };
   		      fn_uniDelAction("/backoffice/bas/menuManageListDelete.do","GET", params, false, "jqGridFunc.fn_search");
		  }, fn_menuAllDel : function(){
			  //전체 삭제 
			  $("#id_ConfirmInfo").attr("href", "javascript:jqGridFunc.fn_Alldel()");
			  fn_ConfirmPop("전체 삭제 하시겠습니까?");
		  }, fn_Alldel : function (){
			 
   		      fn_uniDelAction("/backoffice/bas/menuBndeAllDelete.do","GET", null, false, "jqGridFunc.fn_search");
		  }, fn_menuNoChange : function (){
			  if ($("#menuNo").val() != ""){
				  $("#menuOrdr").val($("#menuNo").val());
				  var endString = $("#menuOrdr").val().slice($("#menuOrdr").val().length -1);
				  var upperMenu = (endString != "0") ? $("#menuOrdr").val().substring(0, $("#menuOrdr").val().length -1) + "0" : "0";
				  $("#upperMenuNo").val(upperMenu);
				  $("#menuNm").focus();
			  }
		  }
    }
  </script>
</head>
<body>
<div class="wrapper">
<form:form name="regist" commandName="regist" method="post" action="/backoffice/bas/msgList.do">
  <!--// header -->
  <input type="hidden" id="mode" name="mode" />
  <c:import url="/backoffice/inc/top_inc.do" />
  <!-- header //-->
  <!--// contents-->
  <div id="contents">
    <div class="breadcrumb">
      <ol class="breadcrumb-item">
        <li>기초 관리</li>
        <li class="active">　> 메뉴 관리</li>
      </ol>
    </div>

    <h2 class="title">메뉴 관리</h2><div class="clear"></div>
    <!--// dashboard -->
    <div class="dashboard">
        <!--contents-->
        <div class="boardlist">
            <div class="left_box mng_countInfo">
                <p>총 : <span id="sp_totcnt"></span>건</p>
                
            </div>
           
            <a href="#" class="right_box blueBtn">일괄등록</a> 
            <a href="#" onClick="jqGridFunc.fn_MenuInfo('Ins', '')" class="right_box blueBtn">등록</a>  
            <a href="#" onClick="jqGridFunc.fn_menuDel()" class="right_box blueBtn">삭제</a> 
            <a href="#" onClick="jqGridFunc.fn_menuAllDel()" class="right_box blueBtn">전체 삭제</a>  
            <div class="clear"></div>
            <div class="whiteBox">
                <table id="mainGrid"></table>
                <div id="pager" class="scroll" style="text-align:center;"></div>  
            </div>
            
        </div>

    </div>
    
  </div>
  <!-- contents//-->
</div>

<!-- wrapper_end-->
<!-- popup -->
<!--권한분류 추가 팝업-->
<div id="bas_menu_add" class="popup m_pop">
    <div class="pop_con">
        <a class="button b-close">X</a>
        <h2 class="pop_tit">메뉴 관리</h2>
        <div class="pop_wrap">
            <table class="detail_table" id="tb_menuInfo">
                <tbody>
                    <tr>
                        <th>메뉴NO</th>
                        <td><input type="text" id="menuNo" name="menuNo" onChange="jqGridFunc.fn_menuNoChange()"></td>
                        <th>메뉴 순서</th>
                        <td><input type="text" id="menuOrdr" name="menuOrdr"></td>
                    </tr>
                    <tr>
                        <th>메뉴명</th>
                        <td><input type="text" id="menuNm" name="menuNm"></td>
                        <th>상위메뉴</th>
                        <td><input type="text" id="upperMenuNo" name="upperMenuNo"></td>
                    </tr>
                    <tr>
                        <th>파일명</th>
                        <td colspan="">
                            <input type="text" id="progrmFileNm" name="progrmFileNm">
                        </td>
                        <td><a href="#" onClick="jqGridFunc.fn_programView('P')">검색</a></td>
                    </tr>
                    <tr>
                        <th>메뉴 설명</th>
                        <td colspan="3">
                             <textarea style="width:550px;height:120px" id="menuDc" name="menuDc"></textarea>
                        </td>
                    </tr>
                </tbody>
            </table>
             <table class="detail_table" id="tb_programLstSearch">
                <tbody>
                   <tr>
                     <td>검색</td><td><input type="text" id="txt_programSearch" name="txt_programSearch"></td>
                     <td><button type="button" id="btn_Search" onClick="jqGridFunc.fn_programLstSearch()">검색</button></td>
                     <td><a href="#" onClick="jqGridFunc.fn_programView('I')">닫기</a></td>
                   </tr>
                </tbody>
             </table>
             <table class="detail_table" id="tb_programLst">
                <thead>
                   <tr>
                     <th>프로그램</th><th>path</th><th>한글명</th>
                   </tr>
                </thead>
                <tbody></tbody>
             </table>
        </div>
        <div class="right_box">
            <a href="" onClick="common_modelClose('bas_menu_add')"  class="grayBtn">취소</a>
            <a href="#" onClick="jqGridFunc.fn_CheckForm()" id="btnUpdate" class="blueBtn">저장</a>
        </div>
        <div class="clear"></div>
    </div>
</div>

<!-- 메뉴 추가 팝업-->

<!-- 프로그램 추가 팝업-->
<div data-popup="bas_menu_create" id="bas_menu_create" class="popup m_pop">
    <div class="pop_con">
        <a class="button b-close">X</a>
        <h2 class="pop_tit">메뉴 생성</h2>
        <div class="pop_wrap">
            <div id="jstree">
                <!-- in this example the tree is populated from inline HTML -->
                <ul>
                  <li>메뉴 목록
                    <ul>
                      <li>기초 관리
                        <ul>
                            <li>코드 관리</li>
                            <li>권한 관리</li>
                            <li>프로그램 관리</li>
                            <li>메뉴 관리</li>
                        </ul>
                      </li>
                      <li>인사 관리
                        <ul>
                            <li>관리자 관리</li>
                            <li>사용자 관리</li>
                        </ul>
                      </li>
                      <li>시설 관리
                        <ul>
                            <li>지점 관리
                                <ul>
                                    <li>사전 예약 시간 관리</li>
                                    <li>자동 취소 시간 관리</li>
                                </ul>
                            </li>
                            <li>좌석 관리</li>
                          </ul>
                      </li>
                    </ul>
                  </li>
                </ul>
            </div>
        </div>
        <div class="right_box">
            <a href="" class="grayBtn">취소</a>
            <a href="" class="blueBtn">저장</a>
        </div>
        <div class="clear"></div>
    </div>
</div>
	<script src="/resources/js/jstree.min.js"></script>
	<script>
	$(function () {
	    $("#jstree").jstree({
	    "checkbox" : {
	      "keep_selected_style" : false
	    },
	    "plugins" : [ "checkbox" ]
	  });
	});
	</script>
    <c:import url="/backoffice/inc/popup_common.do" />
    <script type="text/javascript" src="/resources/js/back_common.js"></script>
</form:form>
</body>
</html>