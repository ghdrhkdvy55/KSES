<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!-- JQuery Grid -->
<link rel="stylesheet" href="/resources/jqgrid/src/css/ui.jqgrid.css">
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
<!-- //contents -->
<input type="hidden" id="mode" name="mode">
<div class="breadcrumb">
  	<ol class="breadcrumb-item">
    	<li>시스템 관리&nbsp;&gt;&nbsp;</li>
    	<li class="active">게시판 등록 관리</li>
  	</ol>
</div>
<h2 class="title">게시판 등록 관리</h2>
<div class="clear"></div>
<div class="dashboard">
    <div class="boardlist">
        <div class="left_box mng_countInfo">
            <p>총 : <span id="sp_totcnt"></span>건</p>
        </div>
        <div class="right_box">
        <a href="#" onClick="jqGridFunc.fn_BoardSetInfo('Ins', '')"  class="blueBtn">게시판 등록</a> 
        <a href="#" onClick="jqGridFunc.fn_BoradDel()"  class="grayBtn">삭제</a>
       </div>
    
        <div class="clear"></div>
        <div class="whiteBox">
            <table id="mainGrid"></table>
            <div id="pager" class="scroll" style="text-align:center;"></div>  
        </div>
    </div>
</div>
<!-- contents//-->
<!-- //popup -->
<!-- // 게시판 추가 팝업 -->
<div data-popup="board_add" id="board_add" class="popup">
  <div class="pop_con">
      <a class="button b-close">X</a>
      <h2 class="pop_tit">게시판 추가</h2>
      <div class="pop_wrap">
          <table class="detail_table">
              <tbody>
                  <tr>
                      <th>게시판 아이디</th>
                      <td>
                          <input type="text" id="boardCd" name="boardCd" >
                          <span id="sp_Unqi">
                          <a href="javascript:jqGridFunc.fn_idCheck()" class="blueBtn">중복확인</a>
                          <input type="hidden" id="idCheck">
                          </span>
                      </td>
                      <th>게시판 이름</th>
                      <td><input type="text" id="boardTitle" name="boardTitle"></td>
                  </tr>
                  <tr>
                    <th>게시판 구분</th>
                    <td>
                      <select name="boardDvsn" id="boardDvsn">
                        <option value="">게시물 구분</option>
		                <c:forEach items="${boardGubun}" var="boardGubun">
		                     <option value="${boardGubun.code}">${boardGubun.codenm}</option>
					    </c:forEach>
                      </select>
                    </td>
                    <th>권한 설정</th>
                    <td>
                      <select name="boardAuthor" id="boardAuthor" onChange="jqGridFunc.fn_CenterCheck()">
                         <option value="">권한 설정</option>
                         <c:forEach items="${authorInfo}" var="authorInfo">
		                     <option value="${authorInfo.author_code}">${authorInfo.author_nm}</option>
					    </c:forEach>
                      </select> 
                    </td>
                  </tr>
                  <tr>
                    <th>지점 선택</th>
                    <td> <span id="sp_boardCenter"></span>
                    </td>
                    <th>사용 유무</th>
                    <td>
                      <label for="useAt_Y"><input name="useYn" type="radio" id="useAt_Y" value="Y"/>사용</label>
                      <label for="useAt_N"><input name="useYn" type="radio" id="useAt_N" value="N"/>사용 안함</label>
                       
                    </td>
                  </tr>

                  <tr>
                    <th>업로드 구분</th>
                    <td>
                      <label for="boardFileUploadYn_y"><input type="radio" name="boardFileUploadYn" id="boardFileUploadYn_y" value="Y">Y</label>
                      <label for="boardFileUploadYn_n"><input type="radio" name="boardFileUploadYn" id="boardFileUploadYn_n" value="N">N</label>
                    </td>
                    <th>댓글 여부</th>
                    <td>
                      <label for="boardCmntUse_y"><input type="radio" name="boardCmntUse" id="boardCmntUse_y" value="Y">Y</label>
                      <label for="boardCmntUse_n"><input type="radio" name="boardCmntUse" id="boardCmntUse_n" value="N">N</label>
                    </td>
                  </tr>
                  <tr>
                    <th>페이지 사이즈</th>
                    <td>
                       <select name="boardSize" id="boardSize">
                         <option value="">페이지 사이즈</option>
                         <c:forEach items="${boardSize}" var="boardSize">
		                     <option value="${boardSize.code}">${boardSize.codenm}</option>
					    </c:forEach>
                      </select> 
                    </td>
                    <th>공지 여부</th>
                    <td>
                      <select name="boardNoticeDvsn" id="boardNoticeDvsn">
                         <option value="">공지구분</option>
                         <c:forEach items="${boardNotice}" var="boardNotice">
		                     <option value="${boardNotice.code}">${boardNotice.codenm}</option>
					    </c:forEach>
                      </select> 
                    </td>
                  </tr>
              </tbody>
          </table>
      </div>
      <div class="right_box">
          <a href="#" onClick="jqGridFunc.fn_CheckForm()" class="blueBtn" id="btnUpdate">저장</a>
          <a href="#" onClick="common_modelClose('board_add')" class="grayBtn b-close">취소</a>
      </div>
      <div class="clear"></div>
  </div>
</div>
<!-- popup// -->
<script type="text/javascript">
	$(document).ready(function() { 
		   jqGridFunc.setGrid("mainGrid");
	 });
   var jqGridFunc  = {
   		
   		setGrid : function(gridOption){
   			var grid = $('#'+gridOption);
   		    var postData = {"pageIndex": "1"};
   		    grid.jqGrid({
   		    	url : '/backoffice/sys/boardSetListAjax.do' ,
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
    		 	                { label: '게시 아이디', key: true,  name:'board_cd', index:'board_cd', align:'left'},
    		 	                { label: '게시판 타이틀',  name:'board_title', index:'board_title', align:'left'},
    		 	                { label: '권한 설정',  name:'board_author', index:'board_author', align:'left'},
    		 	                { label: '관련지점', name:'board_center_id', index:'board_center_id', align:'center'},
      			                { label: '파일업로드', name:'board_file_upload_yn', index:'board_file_upload_yn', align:'center',
      			                  formatter:jqGridFunc.fileUp},
	      			            { label: '댓글사용', name:'board_cmnt_use', index:'board_cmnt_use', align:'center', 
      			                  formatter:jqGridFunc.comment},
		      			        { label: '사용유무', name:'use_yn', index:'use_yn', align:'center', 
      			                  formatter:jqGridFunc.useYn},
      			                { label: '페이지사이즈',  name:'board_size',         index:'board_size',        align:'left'},
      			                { label: '최종수정일자',  name:'last_updt_dtm',         index:'last_updt_dtm',        align:'left'

      			                	, sortable: 'date' ,formatter: "date", formatoptions: { newformat: "Y-m-d"}},
      			                { label: '수정자', name: 'last_updusr_id',  index:'last_updusr_id', align:'center', fixed:true}
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
   		        multiselect: true,
   		        loadonce: true,
   				viewrecords: true,
                   footerrow: true,
                   loadComplete : function (data){
   		        	 $("#sp_totcnt").text(data.paginationInfo.totalRecordCount);
   		        }, loadError:function(xhr, status, error) {
   		            alert(error); 
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
   	                if (cm[index].name != 'cb'){
   	                	jqGridFunc.fn_BoardSetInfo("Edt", $(this).jqGrid('getCell', rowid, 'board_cd'));
           		    }
   	            }, beforeSelectRow: function (rowid, e) {
   		            var $myGrid = $(this);
   		            var i = $.jgrid.getCellIndex($(e.target).closest('td')[0]);
   		            var cm = $myGrid.jqGrid('getGridParam', 'colModel');
   		            return (cm[i].name == 'cb'); // 선택된 컬럼이 cb가 아닌 경우 false를 리턴하여 체크선택을 방지
   		        }	            
   		    });
   		}, fileUp : function(cellvalue, options, rowObject){
   			return rowObject.board_file_upload_yn == "Y" ? "사용" : "사용 안함";
   		}, comment : function(cellvalue, options, rowObject){
   			return rowObject.board_cmnt_use == "Y" ? "사용" : "사용 안함";
   		}, useYn: function (cellvalue, options, rowObject){
   			return rowObject.use_yn == "Y" ? "사용" : "사용 안함";
           },refreshGrid : function(){
           $('#mainGrid').jqGrid().trigger("reloadGrid");
        },fn_search: function(){
    	   $("#mainGrid").setGridParam({
    	    	 datatype	: "json",
    	    	 postData	: JSON.stringify(  {
    	    		"pageIndex": $("#pager .ui-pg-input").val(),
         			"searchKeyword" : $("#searchKeyword").val(),
         			"pageUnit":$('.ui-pg-selbox option:selected').val()
         		}),
    	    	loadComplete	: function(data) {$("#sp_totcnt").text(data.paginationInfo.totalRecordCount);}
    	     }).trigger("reloadGrid");

        }, fn_BoradDel : function (){
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
           }, fn_del: function (){
			var params = {'delCd': $.trim($("#hid_DelCode").val()) };
			fn_uniDelAction("/backoffice/sys/boardSetDelete.do", "GET", params, false, "jqGridFunc.fn_search");
	    }, clearGrid : function() {
               $("#mainGrid").clearGridData();
           }, fn_BoardSetInfo : function (mode, boardCd){
           	$("#mode").val(mode);
       	    if (mode == "Edt"){
	        	$("#boardCd").val(boardCd).prop('readonly', true);
	        	$("#btnUpdate").text("수정");
	        	var params = {"boardCd" : boardCd};
	        	var url = "/backoffice/sys/boardSetListDetail.do";
	        	
	        	fn_Ajax(url, "GET", params, true,
		          	    function(result) {
     				       if (result.status == "LOGIN FAIL"){
	 				    	   common_popup(result.meesage, "Y", "board_add");
	   						   location.href="/backoffice/login.do";
       					   }else if (result.status == "SUCCESS"){
      						       var obj  = result.regist;
      						       var obj  = result.regist;
    						       $("#boardTitle").val(obj.board_title);
    						       $("#boardDvsn").val(obj.board_dvsn);
    						       $("#boardAuthor").val(obj.board_author);  
    						       $("#boardSize").val(obj.board_size);
    						       $("#boardNoticeDvsn").val(obj.board_notice_dvsn);
    						       $("input:radio[name='useYn']:radio[value='"+obj.use_yn+"']").prop('checked', true);
    						       $("input:radio[name='boardFileUploadYn']:radio[value='"+obj.board_file_upload_yn+"']").prop('checked', true);
    						       $("input:radio[name='boardCmntUse']:radio[value='"+obj.board_cmnt_use+"']").prop('checked', true);
    						       $("#board_add > div >h2").text("게시판 수정");
    						       $("#sp_Unqi").hide();
    						       if (obj.board_center_id != ""){
    						    	   var url = "/backoffice/bld/centerCombo.do"
    	    						   var returnVal = uniAjaxReturn(url, "GET", false, null, "lst");
    	    						   fn_checkboxListJson("sp_boardCenter", returnVal,obj.board_center_id, "boardCenterId");  
    						       }
      						   }else{
       						  common_modelCloseM(result.message, "board_add");
       					   }
		     			},
		     			function(request){
		     				 common_modelCloseM("Error:" +request.status, "board_add");
		     			}
	               );
	        }else{
	        	$("#boardCd").val('').prop('readonly', false);
	        	$("#boardTitle").val('');
	        	$("#boardDvsn").val('');
	        	$("#boardAuthor").val('');
	        	$("#boardSize").val('');
	        	$("#boardNoticeDvsn").val('');
	        	$("#boardAuthor").val('');
	        	$("input:radio[name='useYn']:radio[value='Y']").prop('checked', true);
	        	$("#sp_Unqi").show();
	        	$("#btnUpdate").text("등록");
	        	$("#board_add > div >h2").text("게시판 등록");
	        	
	        	fn_EmptyField("sp_boardCenter");
	        	
	        }
	        $("#board_add").bPopup();
          },fn_CheckForm  : function (){
       	   if (any_empt_line_span("board_add", "boardCd", "게시물 아이디를 입력해 주세요.","sp_message", "savePage") == false) return;

      	   if ($("#mode").val() == "Ins" && $("#idCheck").val() != "Y"){
		      if (any_empt_line_span("board_add", "idCheck", "중복체크가 안되었습니다.","sp_message", "savePage") == false) return;
		   }
       	   if (any_empt_line_span("board_add", "boardTitle", "게시판명을 입력해 주세요.","sp_message", "savePage") == false) return;
       	   if (any_empt_line_span("board_add", "boardSize", "게시판 페이지 수를  선택해 주세요.","sp_message", "savePage") == false) return;
		   var commentTxt = ($("#mode").val() == "Ins") ?  "등록 하시겠습니까?" : "수정 하시겠습니까?" ;
	       $("#id_ConfirmInfo").attr("href", "javascript:jqGridFunc.fn_update()");
      		   fn_ConfirmPop(commentTxt);
	      
	  }, fn_update : function (){
		   $("#confirmPage").bPopup().close();
		   var url = "/backoffice/sys/boardSetUpdate.do";
		   var boardCenterId = "";
		   if ($("#boardAuthor").val() != "ROLE_SYSTEM" && $("#boardAuthor").val() != "ROLE_ADMIN"){
			   boardCenterId = ckeckboxValue("체크된 지점이 없습니다.", "boardCenterId", "board_add");
		   }
		   
	       var params = {'boardCd' : $("#boardCd").val(),
			    		 'boardTitle' : $("#boardTitle").val(),
			    		 'boardDvsn' : $("#boardDvsn").val(), 
			    		 'boardAuthor' : $("#boardAuthor").val(), 
			    		 'boardDvsn' : $("#boardDvsn").val(), 
			    		 'boardSize' : $("#boardSize").val(), 
			    		 'boardFileUploadYn' :fn_emptyReplace($("input[name='boardFileUploadYn']:checked").val(),"Y"), 
			    		 'boardCmntUse' :fn_emptyReplace($("input[name='boardCmntUse']:checked").val(),"Y"), 
			    		 'useYn' :fn_emptyReplace($("input[name='useYn']:checked").val(),"Y"), 
			    		 'boardNoticeDvsn' : $("#boardNoticeDvsn").val(), 
			    		 'boardCenterId' :  boardCenterId, 
			    		 'mode' : $("#mode").val()
	    	             }; 
	       fn_Ajax(url, "POST", params, true,
	      			function(result) {
	 				       if (result.status == "LOGIN FAIL"){
	 				    	   common_popup(result.message, "Y","board_add");
	   						   location.href="/backoffice/login.do";
	   					   }else if (result.status == "SUCCESS"){
	   						   //총 게시물 정리 하기'
	   						   common_modelCloseM(result.message ,"board_add");
	   						   jqGridFunc.fn_search();
	   					   }else if (result.status == "FAIL"){
	   						   common_popup("저장 도중 문제가 발생 하였습니다.", "Y", "board_add");
	   						   jqGridFunc.fn_search();
	   					   }
	 				    },
	 				    function(request){
	 				    	common_modelCloseM("Error:" + request.status,"board_add");
	 				    }    		
	        );
	    	
	  }, fn_idCheck : function (){
        	//공용으로 활용 할지 정리 필요 
		 	var url = "/backoffice/sys/boadCdCheck.do"
        	var param =  {"boardCd" : $("#boardCd").val()};
        	if ($("#boardCd").val() != ""){
        		fn_Ajax(url, "GET", param, false, 
        			    function(result) {	
       			              if (result != null) {
       			                if (result.status == "SUCCESS"){
       			        		    var message = result.result == "OK" ? '<spring:message code="common.codeOk.msg" />' : '<spring:message code="common.codeFail.msg" />';
       			        		    var alertIcon =  result.result == "OK" ? "Y" : "N";
       			        		    common_popup(message, alertIcon, "board_add");
      			        		    	$("#idCheck").val(alertIcon);
								}else {
									common_popup('<spring:message code="common.codeFail.msg" />', "N", "board_add");
									$("#idCheck").val("N");
								}
       			              }
						},
					    function(request){
							common_popup('서버 장애 입니다.', "N", "board_add");
							$("#idCheck").val("N");	          						
					    }    		
	            ); 
        	}else {
        		 common_popup('<spring:message code="common.alertcode.msg" />', "N", "board_add");
   		    	 $("#boardCd").focus();
   		    	 return;	
	        }
	 }, fn_CenterCheck : function (){
		 //체크 박스 보여 주기 
		 if ($("#boardAuthor").val() != "ROLE_SYSTEM" && $("#boardAuthor").val() != "ROLE_ADMIN"){
			 var url = "/backoffice/bld/centerCombo.do"
		     var returnVal = uniAjaxReturn(url, "GET", false, null, "lst");
			 fn_checkboxListJson("sp_boardCenter", returnVal, "", "boardCenterId");
		 }else {
			 fn_EmptyField("sp_boardCenter");
		 }
		 
	 }   
   }
</script>
<c:import url="/backoffice/inc/popup_common.do" />