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
<input type="hidden" id="mode" name="mode" />
<div class="breadcrumb">
	<ol class="breadcrumb-item">
    	<li>인사 관리&nbsp;&gt;&nbsp;</li>
    	<li class="active">사용자 관리</li>
	</ol>
</div>
<h2 class="title">사용자 관리</h2>
<div class="clear"></div>
<div class="dashboard">
      <div class="boardlist">
        <div class="whiteBox searchBox">
              <div class="sName">
                <h3>검색 옵션</h3>
              </div>
          <div class="top">
            <p>부서</p>
            <select id="searchDepth" name="searchDepth">
               <option value="">지점 선택</option>
               <c:forEach items="${DEPT}" var="dept">
                  <option value="${dept.code_cd}">${dept.code_nm}</option>
               </c:forEach>
            </select>
            <p>검색어</p>
            <select id="searchCondition" name="searchCondition">
              <option value="EMP_NM">이름</option>
              <option value="EMP_NO">아이디</option>
            </select>
            <input type="text" id="searchKeyword" name="searchKeyword" placeholder="검색어를 입력하세요.">
          </div>
          <div class="inlineBtn">
            <a href="#" onClick="jqGridFunc.fn_search()" class="grayBtn">검색</a>
          </div>
        </div>
        <div class="left_box mng_countInfo">
          <p>총 : <span id="sp_totcnt"></span>건</p>
         
        </div>
        <div class="right_box">
            <a href="#" onClick="jqGridFunc.fn_empInfo('Ins', '')" class="blueBtn">사용자 등록</a> 
            <a href="#" onClick="jqGridFunc.fn_empDel()" class="grayBtn">삭제</a>
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
<!-- // 관리자ㅏ용자 등록 팝업 -->
<div data-popup="mng_user_add" id="mng_user_add" class="popup">
  <div class="pop_con">
      <a class="button b-close">X</a>
      <h2 class="pop_tit">사용자 등록</h2>
      <div class="pop_wrap">
          <table class="detail_table">
              <tbody>
                <tr>
                  <th>사번</th>
                  <td><input type="text" id="empNo" name="empNo">
                      <span id="sp_Unqi">
                      <a href="javascript:jqGridFunc.fn_idCheck()" class="blueBtn">중복확인</a>
                      <input type="hidden" id="idCheck">
                      </span>
                  </td>
                  <th>이름</th>
                  <td><input type="text" id="empNm" name="empNm"></td>
                </tr>
                <tr>
                   <th>사진</th>
                   <td><input type="file" id="empPic" name="empPic"></td>
                </tr>
                <tr>
                  <th>부서</th>
                  <td>
                     <select id="deptCd" name="deptCd">
			               <option value="">부서 선택</option>
			               <c:forEach items="${DEPT}" var="dept">
			                  <option value="${dept.code_cd}">${dept.code_nm}</option>
			               </c:forEach>
			          </select> 
                  </td>
                  <th>직급</th>
                  <td><select id="gradCd" name="gradCd">
			               <option value="">직급 선택</option>
			               <c:forEach items="${GRAD}" var="grad">
			                  <option value="${grad.code_cd}">${grad.code_nm}</option>
			               </c:forEach>
			          </select> 
			      </td>
                </tr>
                <tr>
                  <th>직책</th>
                  <td>
                     <select id="psitCd" name="psitCd">
			               <option value="">직책 선택</option>
			               <c:forEach items="${POST}" var="post">
			                  <option value="${post.code_cd}">${post.code_nm}</option>
			               </c:forEach>
			          </select> 
                  </td>
                  <th>이메일</th>
                  <td><input type="text" id="empEmail" name="empEmail" onClick="fn_join('empEmail',  'mng_user_add')"></td>
                </tr>
                <tr>
                  <th>내선번호</th>
                  <td><input type="text" id="empTlphn" name="empTlphn"></td>
                  <th>핸드폰</th>
                  <td><input type="text" id="empClphn" name="empClphn"></td>
                </tr>
                <tr>
                  <th>사용여부</th>
                  <td>
                    <label for="useAt_Y"><input name="useYn" type="radio" id="useAt_Y" value="Y"/>사용</label>
                    <label for="useAt_N"><input name="useYn" type="radio" id="useAt_N" value="N"/>사용 안함</label>
                  </td>
                  <th>사용자상태</th>
                  <td><select id="empState" name="empState">
			               <option value="">상태</option>
			               <c:forEach items="${userState}" var="userState">
			                  <option value="${userState.code}">${userState.codenm}</option>
			               </c:forEach>
			          </select> 
			      </td>
                </tr>
                
              </tbody>
          </table>
      </div>
      <div class="right_box">
          <a href="#" onClick="jqGridFunc.fn_close()" class="grayBtn">취소</a>
          <a href="#" onClick="jqGridFunc.fn_CheckForm()" id="btnUpdate" class="blueBtn">저장</a>
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
    		    	url : '/backoffice/mng/empListAjax.do' ,
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
	    		 	                { label: '사번',  key: true, name:'emp_no',    index:'emp_no',        align:'left',   width:'10%'},
	    		 	                { label: '이름',  name:'emp_nm',         index:'emp_nm',        align:'left',   width:'10%'},
	    		 	                { label: '부서',  name:'dept_nm',        index:'dept_nm',        align:'left',   width:'10%'},
	    		 	                { label: '내선번호',  name:'emp_tlphn',     index:'emp_tlphn',        align:'left',   width:'10%'},
	    		 	                { label: '핸드폰',  name:'emp_clphn',      index:'emp_clphn',        align:'left',   width:'10%'},
	    		 	                { label: '이메일',  name:'emp_email',       index:'emp_email',        align:'left',   width:'10%'},
	    		 	                { label: '상태',  name:'code_nm',        index:'code_nm',        align:'left',   width:'10%'},
	    		 	                { label: '사용유무',  name:'use_yn',        index:'use_yn',        align:'left',   width:'10%'
	    		 	                  , formatter:jqGridFunc.rowUseYn },
	    		 	                { label: '관리자',  name:'admin_dvsn',        index:'admin_dvsn',        align:'left',   width:'10%'
	    		 	                	, formatter:jqGridFunc.rowAdmin },
	    		 	                { label: '최종수정일', name:'last_updt_dtm', index:'last_updt_dtm', align:'center', width:'12%', 
	      			                  sortable: 'date' ,formatter: "date", formatoptions: { newformat: "Y-m-d"}}
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
    		        multiselect:true, 
    		        loadComplete : function (data){
    		        	 $("#sp_totcnt").text(data.paginationInfo.totalRecordCount);
    		        },loadError:function(xhr, status, error) {
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
							    		          			"searchDepth" : $("#searchDepth").val(),
							    		          			"searchCondition" : $("#searchCondition").val(),
							    		          			"searchKeyword" : $("#searchKeyword").val(),
							    		          			"pageUnit":$('.ui-pg-selbox option:selected').val()
							    		          		})
    		          	 }).trigger("reloadGrid");
    		        }, beforeSelectRow: function (rowid, e) {
    		            var $myGrid = $(this);
    		            var i = $.jgrid.getCellIndex($(e.target).closest('td')[0]);
    		            var cm = $myGrid.jqGrid('getGridParam', 'colModel');
    		            return (cm[i].name == 'cb'); // 선택된 컬럼이 cb가 아닌 경우 false를 리턴하여 체크선택을 방지
    		        }, onSelectRow: function(rowId){
    	                if(rowId != null) {  }// 체크 할떄
    	            }, ondblClickRow : function(rowid, iRow, iCol, e){
    	            	grid.jqGrid('editRow', rowid, {keys: true});
    	            }, onCellSelect : function (rowid, index, contents, action){
    	            	var cm = $(this).jqGrid('getGridParam', 'colModel');
    	                //console.log(cm);
    	                if (cm[index].name !='cb' ){
    	                	jqGridFunc.fn_empInfo("Edt", $(this).jqGrid('getCell', rowid, 'emp_no'));
            		    }
    	            }
    		    });
    		}, rowUseYn : function (cellvalue, options, rowObject){
	        	return rowObject.use_yn == "Y" ? "사용" : "사용안함";
            }, rowAdmin : function (cellvalue, options, rowObject){
            	return rowObject.admin_dvsn == "Y" ? "관리자" : "사용자";  
            },refreshGrid : function(){
	           $('#mainGrid').jqGrid().trigger("reloadGrid");
	        },fn_search: function(){
	    	   $("#mainGrid").setGridParam({
	    	    	 datatype	: "json",
	    	    	 postData	: JSON.stringify(  {
	    	    		"pageIndex": $("#pager .ui-pg-input").val(),
	    	    		"searchDepth" : $("#searchDepth").val(),
	          			"searchCondition" : $("#searchCondition").val(),
	          			"searchKeyword" : $("#searchKeyword").val(),
	         			"pageUnit":$('.ui-pg-selbox option:selected').val()
	         		}),
	    	    	loadComplete	: function(data) {$("#sp_totcnt").text(data.paginationInfo.totalRecordCount);}
	    	     }).trigger("reloadGrid");
 
	        }, clearGrid : function() {
                $("#mainGrid").clearGridData();
            }, fn_empInfo : function (mode, empNo){
            	$("#mode").val(mode);
            	if (mode == "Edt"){
		        	$("#empNo").val(empNo).prop('readonly', true);
		        	$("#btnUpdate").text("수정");
		        	var params = {"empNo" : empNo};
		        	var url = "/backoffice/mng/empDetail.do";
		        	fn_Ajax
		     	   	(
						url, 
						"GET",
						params, 
						false,
			          	    function(result) {
	     				       if (result.status == "LOGIN FAIL"){
		 				    	   common_popup(result.meesage, "Y", "mng_user_add");
		   						   location.href="/backoffice/login.do";
	       					   }else if (result.status == "SUCCESS"){
       						       var obj  = result.regist;
       						       $("#empNm").val(obj.emp_nm);
       						       $("#empNm").val(obj.emp_nm);
       						       $("#deptCd").val(obj.dept_cd);
		       					   $("#gradCd").val(obj.grad_cd);
		       					   $("#psitCd").val(obj.psit_cd);
		       					   $("#empEmail").val(obj.emp_email);
		       					   $("#empTlphn").val(obj.emp_tlphn);
		       					   $("#empClphn").val(obj.emp_clphn);
       						       $("#empState").val(obj.emp_state);
       						       $("input:radio[name='useYn']:radio[value='"+obj.use_yn+"']").prop('checked', true);
       						       $("#sp_Unqi").hide();
       						       $("#btnSave").text("수정");
	       					   }else{
	       						   common_popup(result.meesage, "Y", "mng_user_add");
	       					   }
			     			},
			     			function(request){
			     				common_popup("Error:" +request.status, "Y", "mng_user_add");
			     			}
		               );
		        }else{
		        	$("#empNo").val('').prop('readonly', false);
		        	$("#empNm").val('');
				    $("#empNm").val('');
				    $("#deptCd").val('');
					$("#gradCd").val('');
					$("#psitCd").val('');
					$("#empEmail").val('');
					$("#empTlphn").val('');
					$("#empClphn").val('');
				    $("#empState").val('');
				    $("#useAt_Y").prop("checked", true);
		        	$("#sp_Unqi").show();
		        	$("#btnSave").text("입력");
		        }
		        $("#mng_user_add").bPopup();
           },fn_CheckForm  : function (){
        	   alert("checkform");
        	   if (any_empt_line_span("mng_user_add", "empNo", "사번을 입력해 주세요.","sp_message", "savePage") == false) return;
        	   if ($("#mode").val() == "Ins" && $("#idCheck").val() != "Y"){
				   if (any_empt_line_span("mng_user_add", "empNo", "중복체크가 안되었습니다.","sp_message", "savePage") == false) return;
			   }
			   if (any_empt_line_span("mng_user_add", "empNm", "이름을 입력해 주세요.","sp_message", "savePage") == false) return;
			   if (any_empt_line_span("mng_user_add", "empEmail", "이메일을 입력해 주세요.","sp_message", "savePage") == false) return;
			   if (any_empt_line_span("mng_user_add", "empState", "사용자 상태를 선택해 주세요.","sp_message", "savePage") == false) return;
		       var commentTxt = ($("#mode").val() == "Ins") ?  "등록 하시겠습니까?" : "수정 하시겠습니까?" ;
		       $("#id_ConfirmInfo").attr("href", "javascript:jqGridFunc.fn_update()");
       		   fn_ConfirmPop(commentTxt);
		       
		  }, fn_update : function(){
			  $("#confirmPage").bPopup().close();
			  var url = "/backoffice/mng/empUpdate.do";
 			  var formData = new FormData();
 			  formData.append('empPic', $('#empPic')[0].files[0]);
 			  formData.append('empNo', $('#empNo').val());
 			  formData.append('empNm' , $("#empNm").val());
 			  formData.append('deptCd' , $("#deptCd").val());
 			  formData.append('gradCd' , $("#gradCd").val());
 			  formData.append('psitCd' , $("#psitCd").val());
 			  formData.append('empEmail' , $("#empEmail").val());
 			  formData.append('empTlphn' , $("#empTlphn").val());
 			  formData.append('mode' , $("#mode").val());
 			  formData.append('empClphn' , $("#empClphn").val());
 			  formData.append('empState' , $("#empState").val());
 			  formData.append('useYn' , fn_emptyReplace($("input[name='useYn']:checked").val(),"Y"));
 			  uniAjaxMutipart(url, formData,
 						function(result) {
 						       //결과값 추후 확인 하기 	
 						       if (result.status == "SUCCESS"){
								  common_modelCloseM(result.message, "mng_user_add");
		   						      jqGridFunc.fn_search();
 		    	               }else if (result.status == "LOGIN FAIL"){
 		    	            	  common_popup(result.meesage, "Y","mng_user_add");
 								  document.location.href="/backoffice/login.do";
 				               }else {
 				            	  common_modelCloseM("저장 도중 문제가 발생 하였습니다.", "Y", "mng_user_add");
		   						  jqGridFunc.fn_search();
 				               }
 						    },
 						    function(request){
 						    	common_modelCloseM("Error:" +request.status, "Y", "mng_user_add");	
 						    }    		
 			  );
		  }, fn_empDel : function (){
			  var empArray = new Array();
			  getEquipArray("mainGrid", empArray);
			  if (empArray.length > 0){
				  $("#hid_DelCode").val(empArray.join(","));
				  $("#id_ConfirmInfo").attr("href", "javascript:jqGridFunc.fn_del()");
       		      empArray = null;
       		   	  fn_ConfirmPop("삭제 하시겠습니까?");
			  }else {
				  empArray = null;
				  common_modelCloseM("체크된 값이 없습니다.", "savePage");
			  }
			  
		  }, fn_del: function (){
			  var params = {'empNo':$("#hid_DelCode").val() };		  
			  fn_uniDelAction("/backoffice/mng/empDelete.do", "GET",params, false, "jqGridFunc.fn_search");
		  }, fn_idCheck : function (){
	        	//공용으로 활용 할지 정리 필요 
	        	
	        	alert(any_empt_line_span("mng_user_add", "empNo", "사번을 입력해 주세요.","sp_message", "savePage"));
	        	if (any_empt_line_span("mng_user_add", "empNo", "사번을 입력해 주세요.","sp_message", "savePage") == false) return;
	        	var url = "/backoffice/mng/empNoCheck.do";
    	        var param =  {"empNo" : $("#empNo").val()};
	        	fn_Ajax(url, "GET", param, false,
        			    function(result) {	
     			           if (result != null) {	       	
     			        	   if (result.status == "SUCCESS"){
     			        		
     			        		    var message = result.result == "OK" ? '등록되지 않은 사번 입니다.' : '등록된 사번 입니다.';
     			        		    var alertIcon =  result.result == "OK" ? "Y" : "N";
     			        		    common_popup(message, alertIcon, "mng_user_add");
    			        		    	$("#idCheck").val(alertIcon);
								}else {
									common_popup('<spring:message code="common.codeFail.msg" />', "N", "mng_user_add");
									$("#idCheck").val("N");
								}
							}else{
								alert("장애");
							}
						},
					    function(request){
							common_modelCloseM("Error:" +request.status, "N", "mng_user_add");	
							$("#idCheck").val("N");	       						
					    }    		
		        ); 
	        	
		 }, fn_close : function (){
			 common_modelClose("mng_user_add");
		 } 
    }
    
</script>
<c:import url="/backoffice/inc/popup_common.do" />