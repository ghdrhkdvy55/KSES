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
		<li class="active">관리자 관리</li>
	</ol>
</div>
<h2 class="title">관리자 관리</h2>
<div class="clear"></div>
<div class="dashboard">
  <div class="boardlist">
    <div class="whiteBox searchBox">
          <div class="sName">
            <h3>검색 옵션</h3>
          </div>
      <div class="top">
        <p>사용자 권한</p>
        <select id="searchAuthorCd" name="searchAuthorCd">
           <option value="">권한 선택</option>
           <c:forEach items="${authorCd}" var="authorCd">
              <option value="${authorCd.author_code}">${authorCd.author_nm}</option>
           </c:forEach>
        </select>
        <p>부서</p>
        <select id="searchDeptCd" name="searchDeptCd">
           <option value="">부서 선택</option>
           <c:forEach items="${dept}" var="dept">
              <option value="${dept.deptCd}">${dept.deptNm}</option>
           </c:forEach>
        </select>
        <p>검색어</p>
        <select id="searchCondition" name="searchCondition">
          <option value="ALL">선택</option>
          <option value="ADMIN_ID">아이디</option>
          <option value="b.EMP_NO">이름</option>
        </select>
        <input type="text" id="searchKeyword" name="searchKeyword" placeholder="검색어를 입력하세요.">
      </div>
      <div class="inlineBtn">
        <a href="#" onClick="javascript:jqGridFunc.fn_search();" class="grayBtn">검색</a>
      </div>
    </div>
    <div class="left_box mng_countInfo">
      <p>총 : <span id="sp_totcnt"></span>건</p>
      
    </div>
    <div class="right_box">
        <a href="#" onClick="jqGridFunc.fn_adminInfo('Ins', '')" class="blueBtn">관리자 등록</a>
        <a href="#" onClick="jqGridFunc.fn_adminDel()" class="grayBtn">삭제</a>
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
<!-- // 관리자 등록 팝업 -->
<div id="mng_admin_add" class="popup">
  <div class="pop_con">
      <a class="button b-close">X</a>
      <h2 class="pop_tit" id="h2_txt">관리자 등록</h2>
      <div class="pop_wrap">
          <table class="detail_table" id="tb_adminInfo">
              <tbody>
                <tr>
                  <th>사번</th>
                  <td>
                  
                  <input type="hidden" id="adminId" name="adminId" />
                  <span id="sp_Unqi">
                  <!-- <a href="javascript:jqGridFunc.fn_idCheck()" class="blueBtn">중복확인</a> -->
                  <input type="hidden" id="idCheck">
                  </span>   
                  <!-- <br> -->
                  
                  <input type="text" id="empNo" name="empNo" /><a href="#" onClick="jqGridFunc.fn_empSearchModel('search')" class="grayBtn" style="margin-left: 5px;" id="btn_empSarch" data-popup-open="mng_admin_search">검색</a></td>
                  <th>이름</th>
                  <td><span id="sp_empNm"></span></td>
                </tr>
                <tr>
                  <th>비밀번호</th>
                  <td><input type="password" id="adminPwd" name="adminPwd" ></td>
                  <th>비밀번호 확인</th>
                  <td><input type="password" id="adminPwd2" name="adminPwd2"></td>
                </tr>
                <tr>
                  <th>부서</th>
                  <td><span id="sp_empDeptNm"></span></td>
                  <th>연락처</th>
                  <td><span id="sp_empClphn"></span></td>
                </tr>
                <tr>
                  <th>관리등급</th>
                  <td><select id="authorCd" onChange="jqGridFunc.fn_centerSearch()">
                           <option value="">권한 선택</option>
			               <c:forEach items="${authorCd}" var="authorCd">
			                  <option value="${authorCd.author_code}">${authorCd.author_nm}</option>
			               </c:forEach>
                      </select>
                  </td>
                  <th>지점</th>
                  <td><select id="centerCd" name="centerCd" style="display:none">
                         <option value="">지점 선택</option>
			               <c:forEach items="${centerCd}" var="centerCd">
			                  <option value="${centerCd.center_cd}">${centerCd.center_nm}</option>
			               </c:forEach>
                      </select>
                  </td>
                </tr>
                <tr>
                  <th>이메일</th>
                  <td><span id="sp_empEmail"></span></td>
                  <th>사용여부</th>
                  <td>
                    <label for="useAt_Y"><input name="useYn" type="radio" id="useAt_Y" value="Y"/>사용</label>
                    <label for="useAt_N"><input name="useYn" type="radio" id="useAt_N" value="N"/>사용 안함</label>
                  </td>
              </tbody>
          </table>
      </div>
      <div class="right_box">
          <a href="#" onClick="common_modelClose('mng_admin_add')" class="grayBtn">취소</a>
          <a href="#" onClick="jqGridFunc.fn_CheckForm()" class="blueBtn">저장</a>
      </div>
      <div class="clear"></div>
  </div>
</div>
<!-- 관리자 등록 팝업 // -->
<!-- // 관리자 검색 팝업 -->
<div id="mng_admin_search"  class="popup">
  <div class="pop_con">
      <h2 class="pop_tit">관리자 검색</h2>
      <div class="pop_wrap">
        <fieldset class="whiteBox searchBox">
          <div class="top" style="padding: 0; border-bottom: none;">
            <p>검색구분</p>
            <select style="width: 100px;" id="searchEmpGubun">
              <option value="b.EMP_NM">이름</option>
              <option value="b.EMP_NO">사번</option>
            </select>
            <input type="text" id="txtSearch" name="txtSearch" placeholder="검색어를 입력하세요.">
            <a href="#" onClick="jqGridFunc.fn_empSearch()" class="grayBtn">검색</a>
            <a href="#" onClick="jqGridFunc.fn_empSearchModel('form')" class="grayBtn">취소</a>
          </div>
        </fieldset>
        <table id="tb_EmpSearch" class="whiteBox main_table">
        </table>
      </div>
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
    		    	url : '/backoffice/mng/adminListAjax.do' ,
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
	    		 	                { label: '권한',   name:'author_nm',    index:'author_nm',        align:'left',   width:'10%'},
	    		 	                { label: '부서',  name:'dept_nm',          index:'dept_nm',        align:'left',   width:'10%'},
	    		 	                { label: '아이디', key: true, name:'admin_id',        index:'admin_id',        align:'left',   width:'10%'},
	    		 	                { label: '이름',  name:'emp_nm',           index:'emp_nm',        align:'left',   width:'10%'},
	    		 	                { label: '연락처',  name:'emp_clphn',       index:'emp_clphn',        align:'left',   width:'10%'},
	    		 	                { label: '이메일',  name:'emp_email',       index:'emp_email',        align:'left',   width:'10%'},
	    		 	                { label: '잠김여부',  name:'admin_lockyn',   index:'admin_lockyn',        align:'left',   width:'10%'
	    		 	                	, formatter:jqGridFunc.rowLockYn },
	    		 	                { label: '사용유무',  name:'use_yn',         index:'use_yn',        align:'left',   width:'10%'
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
							    		          			"searchAuthorCd" : $("#searchAuthorCd").val(),
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
    	                if (cm[index].name !='btn' &&  cm[index].name !='cb'){
    	                	jqGridFunc.fn_adminInfo("Edt", $(this).jqGrid('getCell', rowid, 'admin_id'));
            		    }
    	            }
    		    });
    		}, rowLockYn : function(cellvalue, options, rowObject){
    			return rowObject.admin_lockyn == "Y" ? "잠김" : "사용";
    		}, rowUseYn : function (cellvalue, options, rowObject){
	        	return rowObject.use_yn == "Y" ? "사용" : "사용안함";
            }, refreshGrid : function(){
	           $('#mainGrid').jqGrid().trigger("reloadGrid");
	        }, fn_search: function(){
	    	   $("#mainGrid").setGridParam({
	    	    	 datatype	: "json",
	    	    	 postData	: JSON.stringify(  {
	    	    		"pageIndex": $("#pager .ui-pg-input").val(),
	    	    		"searchAuthorCd" : $("#searchAuthorCd").val(),
	    	    		"searchDepth" : $("#searchDepth").val(),
	          			"searchCondition" : $("#searchCondition").val(),
	          			"searchKeyword" : $("#searchKeyword").val(),
	         			"pageUnit":$('.ui-pg-selbox option:selected').val()
	         		}),
	         		loadComplete : function(data) {
	    	    		$("#sp_totcnt").text(data.paginationInfo.totalRecordCount);
	    	    	}
	    	     }).trigger("reloadGrid");
 
	        }, clearGrid : function() {
                $("#mainGrid").clearGridData();
            }, fn_adminInfo : function (mode, adminId){
            	$("#mode").val(mode);
            	if (mode == "Edt"){
		        	$("#adminId").val(adminId).prop('readonly', true);
		        	$("#btnUpdate").text("수정");
		        	var param = {"adminId" : adminId};
		        	var url = "/backoffice/mng/adminDetail.do";
		        	
		        	fn_Ajax(url, "GET", param, false,
			          	    function(result) {
	     				       if (result.status == "LOGIN FAIL"){
		 				    	   common_popup(result.meesage, "Y", "mng_admin_add");
		   						   location.href="/backoffice/login.do";
	       					   }else if (result.status == "SUCCESS"){
       						       var obj  = result.regist;
       						       $("#empNo").val(obj.emp_no);
       						       $("#sp_empNm").html(obj.emp_nm);
       						       $("#sp_empDeptNm").html(obj.dept_nm);
		       					   $("#sp_empClphn").html(obj.emp_clphn);
		       					   $("#sp_empEmail").html(obj.emp_email);
		       					   $("#authorCd").val(obj.author_cd);
		       					   if (obj.author_cd != "ROLE_ADMIN" && obj.author_cd != "ROLE_SYSTEM"){
		       						   $("#centerCd").prop('style','display:block');
		       						   $("#centerCd").val(obj.center_cd);
		       					   }else {
		       						   $("#centerCd").prop('style','display:none');
		       						   $("#centerCd").val('');
		       					   }
       						       $("input:radio[name='useYn']:radio[value='"+obj.use_yn+"']").prop('checked', true);
       						       $("#sp_Unqi").hide();
       						       $("#mng_admin_add > div >h2").text("관리자 수정");
       						       $("#btn_empSarch").hide();
       						       $("#btnSave").text("수정");
	       					   }else{
	       						  common_modelCloseM(result.message, "mng_admin_add");
	       					   }
			     			},
			     			function(request){
			     				 common_modelCloseM("Error:" +request.status, "mng_admin_add");
			     			}
		               );
		        }else{
		        	$("#adminId").val('').prop('readonly', false);
		        	$("#empNo").val('');
				    $("#adminPwd").val('');
				    $("#adminPwd2").val('');
					$("#authorCd").val('');
					$("#centerCd").val('');
					$("#centerCd").prop('style','display:none');
					$("#useAt_Y").prop("checked", true);
		        	$("#sp_Unqi").show();
		        	$("#mng_admin_add > div >h2").text("관리자 등록");
		        	$("#btn_empSarch").show();
		        	$("#btnSave").text("입력");
		        }
		        $("#mng_admin_add").bPopup();
           },fn_CheckForm  : function (){
        	   if (any_empt_line_span("mng_admin_add", "adminId", "아이디을 입력해 주세요.","sp_message", "savePage") == false) return;
        	   if ($("#mode").val() == "Ins" && $("#idCheck").val() != "Y"){
				   if (any_empt_line_span("mng_admin_add", "adminId", "중복체크가 안되었습니다.","sp_message", "savePage") == false) return;
				   if (any_empt_line_span("mng_admin_add", "adminPwd", "비밀번호를 입력해주세요.","sp_message", "savePage") == false) return;
				   if ( chkPwd($('#adminPwd').val()) == false  ){
    				   common_popup("비밀 번호 정합성이 일치 하지 않습니다.", "N", "mng_admin_add");
    				   return;
    			   }
    			   if (any_empt_line_span("mng_admin_add", "adminPwd2", "비밀번호를 입력해주세요.","sp_message", "savePage") == false) return;	  
    			   if ( $.trim($('#adminPwd').val()) !=   $.trim($('#adminPwd2').val())  ){
    				   common_popup("비밀 번호가 일지 하지 않습니다.", "N", "mng_admin_add");
    				   return;
    			   }
				   
			   }
			   if (any_empt_line_span("mng_admin_add", "authorCd", "권한을 선택해 주세요.","sp_message", "savePage") == false) return;
		       var commentTxt = ($("#mode").val() == "Ins") ?  "등록 하시겠습니까?" : "수정 하시겠습니까?" ;
		       $("#id_ConfirmInfo").attr("href", "javascript:jqGridFunc.fn_update()");
       		   fn_ConfirmPop(commentTxt);
		       
		  }, fn_update : function(){
			  $("#confirmPage").bPopup().close();
			  var url = "/backoffice/mng/adminUpdate.do";
		      var params = {   'adminId' : $("#adminId").val(),
				    		    'empNo' : $("#empNo").val(),
				    		    'adminPwd' : $("#adminPwd").val(), 
				    		    'authorCd' : $("#authorCd").val(), 
				    		    'centerCd' : fn_emptyReplace($("#centerCd").val(),""), 
				    		    'useYn' : fn_emptyReplace($("input[name='useYn']:checked").val(),"Y"),
				    		    'mode' : $("#mode").val()
		    	               }; 
		      fn_Ajax(url, "POST", params, false,
		      			function(result) {
		 				       if (result.status == "LOGIN FAIL"){
		 				    	   common_popup(result.meesage, "Y","mng_admin_add");
		   						   location.href="/backoffice/login.do";
		   					   }else if (result.status == "SUCCESS"){
		   						   //총 게시물 정리 하기'
		   						   common_modelClose("mng_admin_add");
		   						   jqGridFunc.fn_search();
		   					   }else if (result.status == "FAIL"){
		   						   common_modelCloseM("저장 도중 문제가 발생 하였습니다.", "Y", "mng_admin_add");
		   						   jqGridFunc.fn_search();
		   					   }
		 				    },
		 				    function(request){
		 				    	common_modelCloseM("Error:" + request.status,"mng_admin_add");
		 				    }    		
		        );
		  }, fn_adminDel : function (){
			  var empArray = new Array();
			  getEquipArray("mainGrid", empArray);
			  if (empArray.length > 0){
				  $("#hid_DelCode").val(empArray.join(","))
				  $("#id_ConfirmInfo").attr("href", "javascript:jqGridFunc.fn_del()");
       		      empArray = null;
       		      fn_ConfirmPop("삭제 하시겠습니까?");
			  }else {
				  empArray = null;
				  common_modelCloseM("체크된 값이 없습니다.", "savePage");
			  }
			  
		  }, fn_del: function (){
			  var params = {'adminNoDel': $.trim($("#hid_DelCode").val()) };
   		      fn_uniDelAction("/backoffice/mng/adminDelete.do","POST", params, false, "jqGridFunc.fn_search");
   		      empArray = null;
		  }, fn_idCheck : function (){
	        	//공용으로 활용 할지 정리 필요 
	        	if (any_empt_line_span("mng_admin_add", "adminId", "사번을 입력해 주세요.","sp_message", "savePage") == false) return;
	        	var url = "/backoffice/mng/adminIdCheck.do"
    	        var param =  {"adminId" : $("#adminId").val()};
	        	fn_Ajax(url, "GET", param, false,
        			    function(result) {	
     			           if (result != null) {	       	
     			        	   if (result.status == "SUCCESS"){
     			        		    var message = result.result == "OK" ? '등록되지 않은 아이디 입니다.' : '등록된 아이디 입니다.';
     			        		    var alertIcon =  result.result == "OK" ? "Y" : "N";
     			        		    common_popup(message, alertIcon, "mng_admin_add");
    			        		    	$("#idCheck").val(alertIcon);
								}else {
									common_popup('<spring:message code="common.codeFail.msg" />', "N", "mng_admin_add");
									$("#idCheck").val("N");
								}
							}else{
								common_modelCloseM(result.message,"mng_admin_add");
							}
						},
					    function(request){
							common_popup('<spring:message code="common.codeFail.msg" />', "N", "mng_admin_add");
							$("#idCheck").val("N");	       						
					    }    		
		        ); 
	        	
		 }, fn_empSearchModel : function(gubun){
			 if (gubun == "search"){
				 $("#tb_EmpSearch").clearGridData();
				 $("#txtSearch").val('');
				 
				 $("#mng_admin_add").bPopup().close();
				 $("#mng_admin_search").bPopup();
			 }else {
				 $("#mng_admin_add").bPopup();
				 $("#mng_admin_search").bPopup().close();
			 }
		 }, fn_empInfo : function (empNo, empNm, empClphn, empEmail, deptNm){
			 $("#adminId").val(empNo);
			 $("#empNo").val(empNo);
			 $("#sp_empNm").html(empNm);
			 $("#sp_empDeptNm").html(deptNm);
			 $("#sp_empClphn").html(empClphn);
			 $("#sp_empEmail").html(empEmail);
			 jqGridFunc.fn_empSearchModel('form');
			 
		 }, fn_empSearch : function (){
			   if (any_empt_line_span("mng_admin_search", "txtSearch", "검색어을 입력해 주세요.","sp_message", "savePage") == false) return;
			   $("#mng_admin_search").bPopup();
			   var gridEmp = $('#tb_EmpSearch');
			 
	   		   var postData = {"pageIndex": "1", "mode": "search", "searchCondition" : $("#searchEmpGubun").val(), "searchKeyword" : $("#txtSearch").val()};
	   		   gridEmp.jqGrid({
		  		    	url : '/backoffice/mng/empListAjax.do' ,
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
		   		 	                { label: '부서',  name:'dept_nm',          index:'dept_nm',          align:'left',   width:'150px'},
		   		 	                { label: '사번',  name:'emp_no',           index:'emp_no',           align:'left',   width:'150px'},
		   		 	                { label: '이름',  name:'emp_nm',           index:'emp_nm',           align:'left',   width:'150px'},
		   		 	                { label: '전화번호',  name:'emp_clphn',     index:'emp_clphn',         align:'left',   width:'0px', hidden:true},
		   		 	                { label: '이메일',  name:'emp_email',       index:'emp_email',        align:'left',   width:'0px', hidden:true}
		  			                ],  //상단면 
		  		        rowNum : 1000,  //레코드 수
		  		        refresh : false,
		  	            rownumbers : false, // 리스트 순번
		  		        viewrecord : true,    // 하단 레코드 수 표기 유무
		  		        loadui : "enable",
		  		        loadtext:'데이터를 가져오는 중...',
		  		        emptyrecords : "조회된 데이터가 없습니다", //빈값일때 표시 
		  		        height : "100%",
		  		        autowidth:false,
		  		        frozen:true, 
		  		        shrinkToFit : false,
		  		        refresh : true,
		  		        multiselect:false, 
		  		        loadComplete : function (data){
		  		        	//완료 표시 
		  		        	$("#sp_totcnt").text(data.paginationInfo.totalRecordCount);
		  		        }, loadError:function(xhr, status, error) {
		  		        	loadtext:'시스템 장애... '
		  		        }, onSelectRow: function(rowId){
		  	                if(rowId != null) {  }// 체크 할떄
		  	            }, onCellSelect : function (rowid, index, contents, action){
		  	            	var cm = $('#tb_EmpSearch').jqGrid('getGridParam', 'colModel');
		  	                //console.log(cm);
		  	                if (cm[index].name !='btn' ){
		  	                	
		  	                	//등록된 값이지 조회 후 update /insert 하기 
		  	                	
		  	                	var empNo = $(this).jqGrid('getCell', rowid, 'emp_no');
		  	                	
		  	                	var url = "/backoffice/mng/adminIdCheck.do"
				    	        var param =  {"adminId" : empNo};
		  	                	//여기 부분 수정 필요 
					        	fn_Ajax(url, "GET", param, false,
				        			    function(result) {	
				     			           if (result != null) {	       	
				     			        	   if (result.status == "SUCCESS"){
				     			        		   $("#mng_admin_search").bPopup().close(); 
				     			        		   /*
				     			        		        추후 팝업창 으로 수정 예정 
				     			        		    var message = result.result == "OK" ? '등록되지 않은 사번 입니다.' : '등록된 사번 입니다.';
				     			        		    var alertIcon =  result.result == "OK" ? "Y" : "N";
				     			        		    
				     			        		    common_popup(message, alertIcon, "mng_admin_add").trigger("alert('1')");
				     			        		    */
				     			        		    if ($("#mode").val() == "Ins"  && result.result == "OK"){
				     			        		    	jqGridFunc.fn_empInfo($("#tb_EmpSearch").jqGrid('getCell', rowid, 'emp_no'),
				     			        		    			$("#tb_EmpSearch").jqGrid('getCell', rowid, 'emp_nm'),
				     			        		    			$("#tb_EmpSearch").jqGrid('getCell', rowid, 'emp_clphn'),
				     			        		    			$("#tb_EmpSearch").jqGrid('getCell', rowid, 'emp_email'),
				     			        		    			$("#tb_EmpSearch").jqGrid('getCell', rowid, 'dept_nm')
						  	                			);
				     			        		    	$("#idCheck").val("Y");
				     			        		    }else if ($("#mode").val() == "Ins"  && result.result != "OK"){
				     			        		    	jqGridFunc.fn_adminInfo("Edt", empNo);
				     			        		    }
				     			        		    
												}else {
													common_popup('<spring:message code="common.codeFail.msg" />', "N", "mng_admin_add");
													$("#idCheck").val("N");
												}
											}else{
												common_modelCloseM(result.message,"mng_admin_add");
											}
										},
									    function(request){
											common_popup('<spring:message code="common.codeFail.msg" />', "N", "mng_admin_add");
											$("#idCheck").val("N");	       						
									    }    		
						        ); 
					        	
		          		    }
		  	            }
	  		    });
	   		    //추후 변경 예정 
	   		    $("#tb_EmpSearch").setGridParam({
	    	    	 datatype	: "json",
	    	    	 postData	: JSON.stringify(  {
	    	    		"pageIndex":"1",
	    	    		"mode" : 'search',
	          			"searchCondition" : $("#searchEmpGubun").val(),
	          			"searchKeyword" : $("#txtSearch").val()
	         		}),
	    	    	loadComplete	: function(data) {}
	    	     }).trigger("reloadGrid");
		 }, fn_centerSearch : function (){
			 if ($("#authorCd").val() != "ROLE_SYSTEM" && $("#authorCd").val() != "ROLE_ADMIN" &&  $("#authorCd").val()  != ""){
				 $("#centerCd").val('');
				 $("#centerCd").prop('style','display:block');
			 } else {
				 $("#centerCd").prop('style','display:none');
				 
			 }
		 }
    }
</script>
<c:import url="/backoffice/inc/popup_common.do" />