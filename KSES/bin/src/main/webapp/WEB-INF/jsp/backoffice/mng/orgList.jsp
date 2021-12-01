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
    		    var postData = {"pageIndex": "1", "orgGubun" : $("#orgGubun").val()};
    		    grid.jqGrid({
    		    	url : '/backoffice/mng/orgListAjax.do' ,
    		        mtype :  'POST',
    		        datatype :'json',
    		        pager: $('#pager'),  
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
	    		 	                { label: '부서 코드',  name:'code_cd',         index:'code_cd',        align:'left',   width:'10%'},
	    		 	                { label: '부서 명',  name:'code_nm',         index:'code_nm',        align:'left',   width:'10%'},
	    		 	                { label: '상세 설명',  name:'code_dc',         index:'code_dc',        align:'left',   width:'10%'},
	    		 	                { label: '사용유무',  name:'use_yn',         index:'use_yn',        align:'left',   width:'10%'},
	    		 	                { label: '최종 수정일', name:'last_updt_dtm', index:'last_updt_dtm', align:'center', width:'12%', 
	      			                  sortable: 'date' ,formatter: "date", formatoptions: { newformat: "Y-m-d"}},
	      			                { label: '삭제', name: 'btn',  index:'btn',      align:'center',  width: 50, fixed:true, sortable : 
	    			                  false, formatter:jqGridFunc.rowBtn}
    			                ],  //상단면 
    		        rowNum : 10,  //레코드 수
    		        rowList : [10,20,30,40,50,100],  // 페이징 수
    		        pager : pager,
    		        refresh : true,
    	            rownumbers : false, // 리스트 순번
    		        viewrecord : true,    // 하단 레코드 수 표기 유무
    		        //loadonce : false,     // true 데이터 한번만 받아옴 
    		        loadui : "enable",
    		        loadtext:'데이터를 가져오는 중...',
    		        emptyrecords : "조회된 데이터가 없습니다", //빈값일때 표시 
    		        height : "100%",
    		        autowidth:true,
    		        shrinkToFit : true,
    		        refresh : true,
    		        loadComplete : function (data){
    		        	 $("#sp_totcnt").text(data.paginationInfo.totalRecordCount);
    		        },loadError:function(xhr, status, error) {
    		            alert("loadError:" + error); 
    		        }, onPaging: function(pgButton){
    		        	  var gridPage = grid.getGridParam('page'); //get current  page
    		        	  var lastPage = grid.getGridParam("lastpage"); //get last page 
    		        	  var totalPage = grid.getGridParam("total");
    		              if (pgButton == "next"){
    		            	  if (gridPage < lastPage ){
    		            		  gridPage += 1;
    		            	  }else{
    		            		  gridPage = gridPage;
    		            	  }
    		              }else if (pgButton == "prev"){
    		            	  if (gridPage > 1 ){
    		            		  gridPage -= 1;
    		            	  }else{
    		            		  gridPage = gridPage;
    		            	  }
    		              }else if (pgButton == "first"){
    		            	  gridPage = 1;
    		              }else if  ( pgButton == "last"){
    		            	  gridPage = lastPage;
    		              } else if (pgButton == "user"){
    		            	  var nowPage = Number($("#pager .ui-pg-input").val());
    		            	  
    		            	  if (totalPage >= nowPage && nowPage > 0 ){
    		            		  gridPage = nowPage;
    		            	  }else {
    		            		  $("#pager .ui-pg-input").val(nowPage);
    		            		  gridPage = nowPage;
    		            	  }
    		              }else if (pgButton == "records"){
    		            	  gridPage = 1;
    		              }
    		              grid.setGridParam({
		    		          	  page : gridPage,
		    		          	  rowNum : $('.ui-pg-selbox option:selected').val(),
		    		          	  postData : JSON.stringify(  {
							    		          			"pageIndex": gridPage,
							    		          			"searchKeyword" : $("#searchKeyword").val(),
							    		          			"pageUnit":$('.ui-pg-selbox option:selected').val()
							    		          		})
    		          		}).trigger("reloadGrid");
    		        },onSelectRow: function(rowId){
    	                if(rowId != null) {  }// 체크 할떄
    	            },ondblClickRow : function(rowid, iRow, iCol, e){
    	            	grid.jqGrid('editRow', rowid, {keys: true});
    	            },onCellSelect : function (rowid, index, contents, action){
    	            	var cm = $(this).jqGrid('getGridParam', 'colModel');
    	                //console.log(cm);
    	                if (cm[index].name !='btn'){
    	                	jqGridFunc.fn_orgInfo("Edt", $(this).jqGrid('getCell', rowid, 'code_cd'));
            		    }
    	            }
    		    });
    		}, rowBtn: function (cellvalue, options, rowObject){
               if (rowObject.code_cd != "")
            	   return "<a href='javascript:jqGridFunc.delRow(\""+rowObject.code_cd+"\");'>삭제</a>";
            },refreshGrid : function(){
	           $('#mainGrid').jqGrid().trigger("reloadGrid");
	        },fn_search: function(){
	    	   $("#mainGrid").setGridParam({
	    	    	 datatype	: "json",
	    	    	 postData	: JSON.stringify(  {
	    	    		"orgGubun" : $("#orgGubun").val(),
	    	    		"pageIndex": $("#pager .ui-pg-input").val(),
	         			"searchKeyword" : $("#searchKeyword").val(),
	         			"pageUnit":$('.ui-pg-selbox option:selected').val()
	         		}),
	    	    	loadComplete	: function(data) {$("#sp_totcnt").text(data.paginationInfo.totalRecordCount);}
	    	     }).trigger("reloadGrid");
 
	        }, delRow : function (codeCd){
	        	if(codeCd != "") {
	        		$("#hid_DelCode").val(codeCd);
	        		$("#id_ConfirmInfo").attr("href", "javascript:jqGridFunc.fn_orgDel()");
	        		fn_ConfirmPop("삭제 하시겠습니까?");
			    }
            },clearGrid : function() {
                $("#mainGrid").clearGridData();
            },fn_orgInfo : function (mode, code){
            	$("#mode").val(mode);
        	    if (mode == "Edt"){
		        	$("#code").val(code);
		        	$("#btnUpdate").text("수정");
		        	var params = {"code" : code, 'orgGubun' : $("#orgGubun").val()};
		        	var url = "/backoffice/mng/orgDetail.do";
		     	    fn_Ajax(url, "GET", params, false,
			          	    function(result) {
	     				       if (result.status == "LOGIN FAIL"){
		 				    	   common_popup(result.meesage, "Y", "bas_code_add");
		   						   location.href="/backoffice/login.do";
	       					   }else if (result.status == "SUCCESS"){
       						       var obj  = result.regist;
       						       $("#codeNm").val(obj.code_nm);
       						       $("#codeDc").val(obj.code_dc);
       						       $("input:radio[name='useYn']:radio[value='"+obj.use_yn+"']").prop('checked', true); 
       						       $("#sp_Unqi").hide();
       						       $("#btnSave").text("수정");
	       					   }else{
	       						   alert(result.meesage);
	       					   }
			     			},
			     			function(request){
			     			     alert("Error:" +request.status );	       						
			     			}
		               );
		        }else{
		        	$("#code").val('');
		        	$("#codeNm").val('');
		        	$("#codeDc").val('');
		        	$("#sp_Unqi").show();
		        	$("#btnSave").text("입력");
		        	$("#useAt_Y").prop("checked", true);
		        }
		        $("#bas_code_add").bPopup();
           },fn_CheckForm  : function (){
        	   if (any_empt_line_span("bas_code_add", "code", "코드를 입력해 주세요.","sp_message", "savePage") == false) return;
        	   if ($("#mode").val() == "Ins" && $("#idCheck").val() != "Y"){
				   if (any_empt_line_span("bas_code_add", "codeId", "중복체크가 안되었습니다.","sp_message", "savePage") == false) return;
			   }
			   if (any_empt_line_span("bas_code_add", "codeNm", "코드명을 입력해 주세요.","sp_message", "savePage") == false) return;
		       
		       var url = "/backoffice/mng/orgUpdate.do";
		       var params = {   'code' : $("#code").val(),
				    		    'codeNm' : $("#codeNm").val(),
				    		    'codeDc' : $("#codeDc").val(), 
				    		    'orgGubun' : $("#orgGubun").val(), 
				    		    'useYn' : $("input:radio[name='useYn']:checked").val(),
				    		    'mode' : $("#mode").val()
		    	               }; 
		    	fn_Ajax(url, "POST", params, true,
		      			function(result) {
		 				       if (result.status == "LOGIN FAIL"){
		 				    	   common_popup(result.meesage, "Y","bas_code_add");
		   						   location.href="/backoffice/login.do";
		   					   }else if (result.status == "SUCCESS"){
		   						   //총 게시물 정리 하기'
		   						   common_modelClose("bas_code_add");
		   						   jqGridFunc.fn_search();
		   					   }else if (result.status == "FAIL"){
		   						   common_popup("저장 도중 문제가 발생 하였습니다.", "Y", "bas_code_add");
		   						   jqGridFunc.fn_search();
		   					   }
		 				    },
		 				    function(request){
		 					    common_popup("Error:" + request.status, "Y", "bas_code_add");
		 				    }    		
		        );
		  }, fn_idCheck : function (){
	        	//공용으로 활용 할지 정리 필요 
	        	if (any_empt_line_span("bas_org_add", "code", "코드를을 입력해 주세요.","sp_message", "savePage") == false) return;
	        	url = "/backoffice/mng/orgIdCheck.do"
	        	var param =  {"code" : $("#code").val(), 'orgGubun' : $("#orgGubun").val() };
	        	if ($("#code").val() != ""){
	        		fn_Ajax(url, "GET", param, false,
	        			    function(result) {	
        			           if (result != null) {	       	
        			        	   if (result.status == "SUCCESS"){
        			        		    var message = result.result == "OK" ? '<spring:message code="common.codeOk.msg" />' : '<spring:message code="common.codeFail.msg" />';
        			        		    var alertIcon =  result.result == "OK" ? "Y" : "N";
        			        		    common_popup(message, alertIcon, "bas_code_add");
       			        		    	$("#idCheck").val(alertIcon);
									}else {
										common_popup('<spring:message code="common.codeFail.msg" />', "N", "bas_code_add");
										$("#idCheck").val("N");
									}
								}else{
									alert("장애");
								}
							},
						    function(request){
								common_popup('<spring:message code="common.codeFail.msg" />', "N", "bas_code_add");
								$("#idCheck").val("N");	       						
						    }    		
			        ); 
	        	}else {
	        		 common_popup('<spring:message code="common.alertcode.msg" />', "N", "");
	   		    	 $("#"+input_id).focus();
	   		    	 return;	
		        }
		 }, fn_close : function(){
			 common_modelClose("bas_org_add");
		 }, fn_SearchList : function(orgGubun){
			 
			 $("#orgGubun").val(orgGubun);
			 jqGridFunc.fn_orgGubunChange();
			 jqGridFunc.fn_search();
		 }, fn_orgDel : function(){
			  var params = {"code" : $("#hid_DelCode").val(), 'orgGubun' : $("#orgGubun").val() };
			  fn_uniDelAction("/backoffice/mng/orgDelete.do","POST", params, false, "jqGridFunc.fn_search");
		 }, fn_orgGubunChange : function(){
			 switch($("#orgGubun").val()){
			     case "Dept" : 
			    	 $("#h_title").html("부서관리");
					 $("#h2_title").html("부서관리");
					 $("#th_orgCode").text("부서코드");
					 $("#th_orgCodeNm").text("부서명");
					 $("#mainGrid").jqGrid('setLabel', "code_cd","부서코드"); 
					 $("#mainGrid").jqGrid('setLabel', "code_nm","부서명"); 
			    	 break;
			     case "Grad" : 
			    	 $("#h_title").html("직급관리");
					 $("#h2_title").html("직급관리");
					 $("#th_orgCode").text("직급코드");
					 $("#th_orgCodeNm").text("직급명");
					 $("#mainGrid").jqGrid('setLabel', "code_cd","직급코드"); 
					 $("#mainGrid").jqGrid('setLabel', "code_nm","직급명"); 
			    	 break;
			     case "Post" : 
			    	 $("#h_title").html("직책관리");
					 $("#h2_title").html("직책관리");
					 $("#th_orgCode").text("직책코드");
					 $("#th_orgCodeNm").text("직책명");
					 $("#mainGrid").jqGrid('setLabel', "code_cd","직책코드"); 
					 $("#mainGrid").jqGrid('setLabel', "code_nm","직책명"); 
			    	 break;
			     default : 
			    	 $("#h_title").html("부서관리");
					 $("#h2_title").html("부서관리");
					 $("#th_orgCode").text("부서코드");
					 $("#th_orgCodeNm").text("부서명");
					 $("#mainGrid").jqGrid('setLabel', "code_cd","부서코드"); 
					 $("#mainGrid").jqGrid('setLabel', "code_nm","부서명"); 
			    	 break;
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
  <input type="hidden" id="orgGubun" name="orgGubun" value="${regist.orgGubun }" />
  <!--// header -->
  <c:import url="/backoffice/inc/top_inc.do" />
  
  <!-- header //-->
  <!--// contents-->
  <div id="contents">
    <div class="breadcrumb">
      <ol class="breadcrumb-item">
        <li>인사 관리</li>
        <li class="active">　>  인사정보 관리</li>
      </ol>
    </div>

    <h2 class="title" id="h_title">${regist.orgTitle }</h2><div class="clear"></div>
    <!--// dashboard -->
    <div class="dashboard">
        <!--contents-->
        <div class="boardlist">
            <div class="left_box mng_countInfo">
                <p>총 : <span id="sp_totcnt"></span>건</p>
                
            </div>
            <a href="#" onClick="jqGridFunc.fn_SearchList('Dept')" class="right_box blueBtn">부서 관리</a>
            <a href="#" onClick="jqGridFunc.fn_SearchList('Grad')" class="right_box blueBtn">직급 관리</a>
            <a href="#" onClick="jqGridFunc.fn_SearchList('Post')" class="right_box blueBtn">직책 관리</a>
            <a href="#" onClick="jqGridFunc.fn_orgInfo('Ins', '')" class="right_box blueBtn">추가</a>  
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
</form:form>
<!-- wrapper_end-->
<!-- popup -->
<!--권한분류 추가 팝업-->
<div data-popup="bas_code_add" id="bas_code_add" class="popup m_pop">
    <div class="pop_con">
        <a class="button b-close">X</a>
        <h2 class="pop_tit" id="h2_title">${regist.orgTitle }</h2>
        <div class="pop_wrap">
            <table class="detail_table">
                <tbody>
                    <tr>
                        <th id="th_orgCode">${regist.orgCode }</th>
                        <td>
                            <input type="text" id="code" name="code">
                            <span id="sp_Unqi">
                            <a href="javascript:jqGridFunc.fn_idCheck()" class="blueBtn">중복확인</a>
                            <input type="hidden" id="idCheck">
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <th id="th_orgCodeNm">${regist.orgCodeNm }</th>
                        <td>
                            <input type="text" id="codeNm" name="codeNm">
                        </td>
                    </tr>
                    <tr>
                        <th>상세설명</th>
                        <td>
                            <input type="text" id="codeDc" name="codeDc">
                        </td>
                    </tr>
                    <tr>
                        <th>사용 유무</th>
                        <td>
                            <label for="useAt_Y"><input name="useYn" type="radio" id="useAt_Y" value="Y"/>사용</label>
                            <label for="useAt_N"><input name="useYn" type="radio" id="useAt_N" value="N"/>사용 안함</label>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div class="right_box">
            <a href="#" onClick="jqGridFunc.fn_close()" class="grayBtn">취소</a>
            <a href="#" onClick="jqGridFunc.fn_CheckForm()" id="btnSave" class="blueBtn">저장</a>
        </div>
        <div class="clear"></div>
    </div>
</div>
    <c:import url="/backoffice/inc/popup_common.do" />
    <script type="text/javascript" src="/resources/js/common.js"></script>
    <script type="text/javascript" src="/resources/js/back_common.js"></script>
</body>
</html>