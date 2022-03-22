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
<div class="breadcrumb">
  <ol class="breadcrumb-item">
    <li>시스템 관리&nbsp;&gt;&nbsp;</li>
    <li class="active">시스템 로그</li>
  </ol>
</div>
<h2 class="title">시스템 로그</h2>
<div class="clear"></div>
<div class="dashboard">
    <div class="boardlist">
        <div class="whiteBox searchBox">
            <div class="sName">
              <h3>검색 옵션</h3>
            </div>
            <div class="top">
                <p>기간</p>
	            <input type="text" id="searchFrom" class="cal_icon"> ~
	            <input type="text" id="searchTo" class="cal_icon">
                <p>검색어</p>
                <input type="text" name="searchKeyword" id="searchKeyword"  placeholder="검색어를 입력하새요.">
            </div>
            <div class="inlineBtn ">
                <a href="javascript:fnSearch(1);" class="grayBtn">검색</a>
            </div>
        </div>
        <div class="left_box mng_countInfo">
            <p>총 : <span id="sp_totcnt"></span>건</p>
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
<!--권한분류 추가 팝업-->
<div data-popup="bas_sys_add" class="popup">
    <div class="pop_con">
        <a class="button b-close">X</a>
        <h2 class="pop_tit">시스템 상세</h2>
        <div class="pop_wrap">
            <table class="detail_table">
                <tbody>
                    <tr>
                        <th>발생일자</th>
                        <td><span id="sp_Odate"></span></td>
                        <th>요청자ID</th>
                        <td><span id="sp_ReqId"></span></td>
                    </tr>
                    <tr>
                        <th>서비스명</th>
                        <td><span id="sp_Service"></span></td>
                        <th>메소드명</th>
                        <td><span id="sp_Method"></span></td>
                    </tr>
                    <tr>
                        <th>업무구분</th>
                        <td><span id="sp_ProcessN"></span></td>
                        <th>처리시간</th>
                        <td><span id="sp_ProcessT"></span></td>
                        
                    </tr>
                    <tr>
                        <th>애러구분</th>
                        <td><span id="sp_Error"></span></td>
                        <th>애러코드</th>
                        <td><span id="sp_ErrorCd"></span></td>
                    </tr>
                    
                    
                    <tr>
                        <th>요청 파라미터</th>
                        <td colspan="3">
                           <span id="sp_Params"></span>
                        </td>
                    </tr>
                    <tr>
                        <th>요청 파라미터</th>
                        <td colspan="3">
                           <span id="sp_Result"></span>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div class="right_box">
            <a href="javascript:common_modelClose('bas_sys_add')" class="grayBtn">닫기</a>
        </div>
        <div class="clear"></div>
    </div>
</div>
<!-- popup// -->
<script type="text/javascript" src="/resources/jqgrid/jqgrid.custom.egovapi.js"></script>
<script type="text/javascript">
	$(document).ready(function() {

		// 메인 목록 정의
		EgovJqGridApi.mainGrid([

			{ label:'아이디'	, name:'requst_id'		, hidden:true},
			{ label:'업무구분'	, name:'process_se_code', align:'center'},
			{ label:'서비스명'	, name:'srvc_nm'		, align:'center'},
			{ label:'매서드명'	, name:'method_nm'		, align:'center'},
			{ label:'처리시간'	, name:'process_time'	, align:'center'},
			{ label:'애러코드'	, name:'error_code'		, align:'center'},
			{ label:'요청자IP', name:'rqester_ip'		, align:'center'},
			{ label:'요청자'	, name:'rqester_id'		, align:'center'},
			{ label:'실행일자'	, name: 'occrrnc_date'	, align:'center', 
				sortable: 'date' ,formatter: "date",formatoptions: { srcformat: 'Y-m-d H:i:s', newformat: 'm/d/Y h:i:s' }
			},
			{ name:'rqester_nm'	  , hidden:true},
			{ name:'emp_nm'		  , hidden:true},
			{ name:'sql_param'	  , hidden:true},
			{ name:'method_result', hidden:true},
			{ name:'error_se'	  , hidden:true},
		], false, false, fnSearch);

		let today = new Date();
		$('#searchFrom').val($.datepicker.formatDate('yymmdd', today))
		$("#searchTo").val($.datepicker.formatDate('yymmdd', today))
		
	 });
	
	// 메인 그리드 목록 조회.
    function fnSearch(pageNo) {

    	let params = {
   			pageIndex: pageNo,
   			pageUnit: $('.ui-pg-selbox option:selected').val(),
   			searchFrom: $("#searchFrom").val(),
			searchTo: $("#searchTo").val(),
      		searchKeyword: $("#searchKeyword").val()
   		};

    	EgovJqGridApi.mainGridAjax('/backoffice/sys/selectlogListAjax.do', params, fnSearch);

    	// 메인 그리드 더블 클릭 시 이벤트 발생.
    	EgovJqGridApi.mainGridDetail(fnSysInfo);
    }

    // 시스템 로그 상세보기.
    function fnSysInfo(rowId, rowData) { 
    	
		$("#sp_Odate").html(rowData.occrrnc_date);  //발생 일자
		$("#sp_ReqId").html(rowData.rqester_nm); //요청자
	   	$("#sp_Service").html(rowData.srvc_nm);
		$("#sp_Method").html(rowData.method_nm);
		$("#sp_ProcessN").html(rowData.process_se_code);
		$("#sp_ProcessT").html(rowData.process_time);
        $("#sp_Params").html(rowData.sql_param);
        $("#sp_Result").html(rowData.method_result);
        $("#sp_Error").html(rowData.error_se);
        $("#sp_ErrorCd").html(rowData.error_code);

        $('[data-popup=bas_sys_add]').bPopup();
    	
	}
</script>