<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
<input type="hidden" name="mode" id="mode" >
<div class="breadcrumb">
	<ol class="breadcrumb-item">
    	<li>고객 관리&nbsp;&gt;&nbsp;</li>
    	<li class="active">고객 정보 관리</li>
	</ol>
</div>
<h2 class="title">고객 정보 관리</h2>
<div class="clear"></div>
<div class="dashboard">
	<div class="boardlist">
      	<div class="whiteBox searchBox">
            <div class="sName">
              <h3>옵션 선택</h3>
            </div>
            <div class="top">
                <p>검색어</p>
                <select id="searchCondition" name="searchCondition">
                    <option value="ALL">전체</option>
					<option value="USER_ID">아이디</option>
					<option value="USER_NM">이름</option>
					<option value="USER_PHONE">전화번호</option>
                </select>
                <input type="text" name="searchKeyword" id="searchKeyword" placeholder="검색어를 입력하새요.">
            </div>
            <div class="inlineBtn ">
                <a href="javascript:jqGridFunc.fn_search();" class="grayBtn">검색</a>
            </div>
        </div>
        <div class="left_box mng_countInfo">
          <p>총 : <span id="sp_totcnt"></span>건</p>
        </div>
        <div class="right_box">	            	
        </div>
        <div class="clear"></div>
        <div class="whiteBox"></div>
	</div>
</div>
<div class="Swrap tableArea">
	<table id="mainGrid">
	</table>
	<div id="pager" class="scroll" style="text-align:center;"></div>     
	<br />
	<div id="paginate"></div>   
</div>
<!-- contents// -->
<!-- //popup -->
<!-- 휴일 정보 팝업 -->
<div id='rsv_user_add' class="popup">
	<div class="pop_con">
		<a class="button b-close">X</a>
    	<h2 class="pop_tit">고객 정보 수정</h2>
    	<div class="pop_wrap">
    		<table class="detail_table">
           		<tbody>
               		<tr>
						<th>아이디</th>
	                    <td>
	                    	<span id="sp_userId"></span>
	                    </td>
	                    <th>이름</th>
			            <td>
		                    <span id="sp_userNm"></span>
						</td>
					</tr>
					<tr>
				        <th>전화번호</th>
			            <td>
		                    <span id="sp_userPhone"></span>
						</td>
						<th>메일</th>
			            <td>
		                    <span id="sp_userEmail"></span>
						</td>
					</tr>
					<tr>
						<th>성별</th>
			            <td>
		                    <span id="sp_userSexMf"></span>
						</td>
						<th>생년월일</th>
			            <td>
		                    <span id="sp_userBirthDy"></span>
						</td>
					</tr>
					<tr>
						<th>개인정보동의여부</th>
			            <td>
		                    <span id="sp_indvdlinfoAgreYn"></span>
						</td>
						<th>개인정보동의일자</th>
			            <td>
		                    <span id="sp_indvdlinfoAgreDt"></span>
						</td>
					</tr>
					<tr>
						<th>백신 차수</th>
						<td>
							<select name="vacntnRound" id="vacntnRound">
								<option value="">선택</option>
								<c:forEach items="${vacntnRound}" var="vacntnRound">
									<option value="${vacntnRound.code}">${vacntnRound.codenm}</option>
				               	</c:forEach>
							</select>
						</td>
						<th>백신 종류</th>
			            <td>
							<select id="vacntnDvsn" name="vacntnDvsn">
								<option value="">선택</option>
								<c:forEach items="${vacntnDvsn}" var="vacntnDvsn">
									<option value="${vacntnDvsn.code}">${vacntnDvsn.codenm}</option>
			               		</c:forEach>
							</select> 
						</td>
					</tr>
					<tr>     
						<th>접종 일자</th>
			            <td>
	                    	<input type="text" name="vacntnDt" id="vacntnDt" class="cal_icon">
						</td> 
					</tr>	
				</tbody>
			</table>
		</div>
	    <div class="right_box">
	    	<a href="javascript:jqGridFunc.fn_CheckForm();" id="btnUpdate" class="blueBtn">저장</a>
        	<a href="#" onClick="common_modelClose('rsv_user_add')" id="btnUpdate" class="grayBtn b-close">취소</a>
		</div>
		<div class="clear"></div>
	</div>
</div>
<!-- popup// -->
<script type="text/javascript">
	$(document).ready(function() { 
		jqGridFunc.setGrid("mainGrid");
		
		var clareCalendar = {
		monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
		dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
		weekHeader: 'Wk',
		dateFormat: 'yymmdd', //형식(20120303)
		autoSize: false, //오토리사이즈(body등 상위태그의 설정에 따른다)
		changeMonth: true, //월변경가능
		changeYear: true, //년변경가능
		showMonthAfterYear: true, //년 뒤에 월 표시
		buttonImageOnly: false, //이미지표시
		yearRange: '1970:2030' //1990년부터 2020년까지
        };	       
	    $("#vacntnDt").datepicker(clareCalendar);
		$("img.ui-datepicker-trigger").attr("style", "margin-left:3px; vertical-align:middle; cursor:pointer;"); //이미지버튼 style적용
		$("#ui-datepicker-div").hide(); //자동으로 생성되는 div객체 숨김
		
 	});
   	
	var jqGridFunc  = 
	{
   		setGrid : function(gridOption) {
   			var grid = $('#'+gridOption);
   		    //ajax 관련 내용 정리 하기 
   			
               var postData = {};
   		    grid.jqGrid({
   		    	url : '/backoffice/rsv/userListAjax.do' ,
   		        mtype :  'POST',
   		        datatype :'json',
   		        pager: $('#pager'),  
   		        ajaxGridOptions: { contentType: "application/json; charset=UTF-8" },
   		        ajaxRowOptions: { contentType: "application/json; charset=UTF-8", async: true },
   		        ajaxSelectOptions: { contentType: "application/json; charset=UTF-8", dataType: "JSON" }, 
   		       
   		        postData :  JSON.stringify(postData),
   		        jsonReader : 
   		        {
					root : 'resultlist',
					"page":"paginationInfo.currentPageNo",
					"total":"paginationInfo.totalPageCount",
					"records":"paginationInfo.totalRecordCount",
					repeatitems:false
  		            },
  		         	//상단면
   		        colModel :  
				[
					{ label: '아이디',  name:'user_id', index:'user_id', align:'center', key:true, width:'20%'},
					{ label: '이름',  name:'user_nm', index:'user_nm', align:'center', width:'20%'},
					{ label: '전화번호', name:'user_phone', index:'user_phone', align:'center', width:'20%'},
					{ label: '이메일', name:'user_email', index:'user_email', align:'center', width:'20%'},
					{ label: '성별', name:'user_sex_mf', index:'user_sex_mf', align:'center', width:'20%'},
					{ label: '생년 월일', name: 'user_birth_dy',  index:'user_birth_dy', align:'center', width: '20%'}
				],
				//레코드 수
   		        rowNum : 10,
   		     	// 페이징 수
   		        rowList : [10,20,30,40,50,100],  
   		        pager : pager,
   		        refresh : true,
   		     	// 리스트 순번
   	            rownumbers : false,
   	         	// 하단 레코R드 수 표기 유무
   		        viewrecord : true,
   		     	// true 데이터 한번만 받아옴
   		        loadonce : false,      
   		        loadui : "enable",
   		        loadtext:'데이터를 가져오는 중...',
   		      	//빈값일때 표시
   		        emptyrecords : "조회된 데이터가 없습니다", 
   		        height : "100%",
   		        autowidth:true,
   		        shrinkToFit : true,
   		        refresh : true,
   		        multiselect: false,
   				viewrecords: true,
                   footerrow: true,
   		        userDataOnFooter: true, // use the userData parameter of the JSON response to display data on footer
   		        
   		        loadComplete : function (data){
   		        	$("#sp_totcnt").text(data.paginationInfo.totalRecordCount);
   		        },
   		        beforeSelectRow: function (rowid, e) {
   		            var $myGrid = $(this);
   		            var i = $.jgrid.getCellIndex($(e.target).closest('td')[0]);
   		            var cm = $myGrid.jqGrid('getGridParam', 'colModel');
   		            return (cm[i].name == 'cb'); // 선택된 컬럼이 cb가 아닌 경우 false를 리턴하여 체크선택을 방지
   		        },
   		        loadError:function(xhr, status, error) {
   		            alert(error); 
   		        }, 
   		        onPaging: function(pgButton){
					var gridPage = grid.getGridParam('page'); //get current  page
					var lastPage = grid.getGridParam("lastpage"); //get last page 
					var totalPage = grid.getGridParam("total");
   		              
					if (pgButton == "next"){
						/* gridPage = gridPage < lastPage ? gridPage +=1 : gridPage; */
						if (gridPage < lastPage ){
							gridPage += 1;
						} else {
							gridPage = gridPage;
						}
					} else if (pgButton == "prev") {
						/* gridPage = gridPage > 1 ? gridPage -=1 : gridPage; */
						if (gridPage > 1 ) {
							gridPage -= 1;
						} else {
							gridPage = gridPage;
						}
					} else if (pgButton == "first"){
						gridPage = 1;
					} else if (pgButton == "last") {
						gridPage = lastPage;
					} else if (pgButton == "user"){
						var nowPage = Number($("#pager .ui-pg-input").val());
   		            	  
						if (totalPage >= nowPage && nowPage > 0 ){
							gridPage = nowPage;
   		            	} else {
   		            		$("#pager .ui-pg-input").val(nowPage);
   		            		gridPage = nowPage;
   		            	}
					} else if (pgButton == "records") {
   		            	  gridPage = 1;
					}
					
					grid.setGridParam
					({
						page : gridPage,
						rowNum : $('.ui-pg-selbox option:selected').val(),
						postData : JSON.stringify
						({
							"pageIndex": gridPage,
							"searchKeyword" : $("#searchKeyword").val(),
							"pageUnit":$('.ui-pg-selbox option:selected').val()
						})
					}).trigger("reloadGrid");
				},
				onSelectRow: function(rowId){
   	                if(rowId != null) {  }// 체크 할떄
   	            },
   	            ondblClickRow : function(rowid, iRow, iCol, e){
   	            	grid.jqGrid('editRow', rowid, {keys: true});
   	            },
   	            //셀 선택시 이벤트 등록
   	            onCellSelect : function (rowid, index, contents, action) {
   	            	var cm = $(this).jqGrid('getGridParam', 'colModel');
   	                if (cm[index].name != 'cb'){
   	                	jqGridFunc.fn_userInfo($(this).jqGrid('getCell', rowid, 'user_id'));
           		    }
   	            }
   		    });
   		},
   		refreshGrid : function() {
			$('#mainGrid').jqGrid().trigger("reloadGrid");
       	},
       	clearGrid : function() {
			$("#mainGrid").clearGridData();
		}, 
        fn_userInfo : function (userId) {
	        $("#userId").val(userId);
			var params = {"userId" : userId};
			var url = "/backoffice/rsv/userInfoDetail.do";
			fn_Ajax
			(
				url, 
				"GET",
				params, 
				false,
				function(result) {
					if (result.status == "LOGIN FAIL"){
						common_modelCloseM(result.message, "rsv_user_add");
						location.href="/backoffice/login.do";
					} else if (result.status == "SUCCESS") {
						//총 게시물 정리 하기
						var obj = result.regist;
						$("#sp_userId").html(obj.user_id);
						$("#sp_userNm").html(obj.user_nm);
						$("#sp_userPhone").html(obj.user_phone);
						$("#sp_userEmail").html(obj.user_email);								
						$("#sp_userSexMf").html(obj.user_sex_mf);								
						$("#sp_userBirthDy").html(obj.user_birth_dy);								
						$("#sp_indvdlinfoAgreYn").html(obj.indvdlinfo_agre_yn);								
						$("#sp_indvdlinfoAgreDt").html(obj.indvdlinfo_agre_dt);														
						$("#vacntnRound").val(obj.vacntn_round);
						$("#vacntnDvsn").val(obj.vacntn_dvsn);
						$("#vacntnDt").val(obj.vacntn_dt);
					}else {
					    common_modelCloseM(result.message, "rsv_user_add");
					}
			
				},
				function(request){
					common_modelCloseM("ERROR : " +request.status, "rsv_user_add");
				}
			),
			$("#rsv_user_add").bPopup();
        },
		fn_CheckForm  : function () {
			if (any_empt_line_id("vacntnRound", "접종 차수를 선택해주세요.") == false) return;
			if (any_empt_line_id("vacntnDvsn", "백신 종류를 선택해주세요.") == false) return;
			if (any_empt_line_id("vacntnDt", "접종 일자를 선택해주세요.") == false) return;
			var commentTxt = "수정 하시겠습니까?";
		    $("#id_ConfirmInfo").attr("href", "javascript:jqGridFunc.fn_update()");
       		fn_ConfirmPop(commentTxt);
		}, fn_update : function (){
			//확인 
			$("#confirmPage").bPopup().close();
			var url = "/backoffice/rsv/userUpdate.do";
			var params = 
			{ 	
				'userId' : $("#sp_userId").html(),
				'vacntnRound' : $("#vacntnRound").val(),
				'vacntnDvsn' : $("#vacntnDvsn").val(),
				'vacntnDt' : $("#vacntnDt").val()
			}; 
			fn_Ajax(url, "POST", params, true,
	      			function(result) {
	 				       if (result.status == "LOGIN FAIL"){
	 				    	   common_popup(result.meesage, "Y","rsv_user_add");
	   						   location.href="/backoffice/login.do";
	   					   }else if (result.status == "SUCCESS"){
	   						   //총 게시물 정리 하기'
	   						   common_modelCloseM(result.message, "rsv_user_add");
	   						   jqGridFunc.fn_search();
	   					   }else if (result.status == "FAIL"){
	   						   common_modelCloseM("저장 도중 문제가 발생 하였습니다.", "rsv_user_add");
	   						   jqGridFunc.fn_search();
	   					   }
	 				    },
	 				    function(request){
	 				    	common_modelCloseM("Error:" + request.status,"rsv_user_add");
	 				    }    		
	        );
		},
	  	fn_search: function(){
			//검색 
    	  	$("#mainGrid").setGridParam({
    	    	datatype : "json",
    	    	postData : JSON.stringify
    	    	({
          			"pageIndex": $("#pager .ui-pg-input").val(),
          			"searchCondition" : $("#searchCondition").val(),
          			"searchKeyword" : $("#searchKeyword").val(),
         			"pageUnit":$('.ui-pg-selbox option:selected').val()
         		}),
    	    	loadComplete : function(data) {
    	    		$("#sp_totcnt").text(data.paginationInfo.totalRecordCount);
    	    	}
    	  }).trigger("reloadGrid");
		},


   	}
</script>
<c:import url="/backoffice/inc/popup_common.do" />