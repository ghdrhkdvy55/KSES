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
<div class="breadcrumb">
	<ol class="breadcrumb-item">
		<li>시설 관리&nbsp;&gt;&nbsp;</li>
		<li class="active">구역 관리</li>
	</ol>
</div>
<h2 class="title">구역 관리</h2>
<div class="clear"></div>
<div class="dashboard">
    <div class="boardlist">
        <div class="whiteBox searchBox">
            <div class="top">   
                <p>지점</p>
             	<select id="searchCenterCd">
                    <option value="">선택</option>
                     <c:forEach items="${centerInfo}" var="centerInfo">
						<option value="${centerInfo.center_cd}">${centerInfo.center_nm}</option>
                     </c:forEach>
            	</select>  
                <!-- <p>검색어</p>
                <input type="text" id="searchKeyword" placeholder="검색어를 입력하세요." autocomplete="off"> -->
            </div>
            <div class="inlineBtn">
                <a href="javascript:fnSearch(1);" class="grayBtn">검색</a>
            </div>
        </div>
        <div class="left_box mng_countInfo">
			<p>총 : <span id="sp_totcnt"></span>건</p>
        </div>
        <div class="right_box">
        	<a href="javascript:fnPartClassInfo()" class="blueBtn">구역 정보 등록</a>
        	<a href="javascript:fnPartClassDelete()" class="grayBtn">구역 정보삭제</a>
        </div>
        <div class="clear"></div>
        <div class="whiteBox">
            <table id="mainGrid"></table>
            <div id="pager"></div>
        </div>
    </div>
</div>
<!-- contents//-->
<!-- //popup -->
<div data-popup="bld_partClass_add" id="bld_partClass_add" class="popup">
	<div class="pop_con">
        <a class="button b-close">X</a>
        <h2 class="pop_tit">장기 예매 상세</h2>
        <div class="pop_wrap">
        	<form>
        	<input type="hidden" name="mode" value="Ins">
        	<input type="hidden" name="partSeq">
        	<input type="hidden" name="centerNm">
            <table class="detail_table">
	            <tbody>
	                <tr>
				        <th>지점명</th>
			            <td>
			            	<select name="centerCd">
								<option value="">지점 선택</option>
								<c:forEach items="${centerInfo}" var="centerInfo">
									<option value="${centerInfo.center_cd}">${centerInfo.center_nm}</option>
								</c:forEach>
			                 </select>
						</td> 
						<th>구역등급</th>
			            <td>
							<select name="partClass">
								<option value="">선택</option>
								<c:forEach items="${partClassInfo}" var="partClassInfo">
									<option value="${partClassInfo.code}">${partClassInfo.codenm}</option>
								</c:forEach>
							</select>
						</td>
	                </tr>
					<tr>
						<th>구역금액</th>
						<td>
							<input type="text" name="partPayCost">원</input>
						</td>
						<th>사용 유무</th>
					    <td>
				            <span>
			                    <input type="radio" name="useYn" value="Y">사용</input>
							</span>
						    <span>
					            <input type="radio" name="useYn" value="N">사용 안함</input>
			                </span>
		                </td>
	                </tr>
	                <tr>
                  		<th>아이콘</th>
                  		<td>
                  			<input type="file" name="partIcon">
                  		</td>
                  		<th>정렬순서</th>
                  		<td>
                  			<input type="text" name="partClassOrder">
                  		</td>
	                </tr>
	            </tbody>
            </table>
            </form>
        </div>
        <div class="right_box">
        	<button type="button" class="blueBtn">저장</button>
        	<button type="button" class="grayBtn b-close">취소</button>
        </div>
        <div class="clear"></div>
    </div>
</div>
<div data-popup="popupConfirm" class="popup m_pop">
      <div class="pop_con">
        <a id="a_closePop" class="button b-close">X</a>
        <p class="pop_tit">메세지</p>
        <p class="pop_wrap"><span></span></p>
        <div class="right_box">
		  <button class="blueBtn" style="cursor:pointer;">예</button>
          <a href="javascript:$('[data-popup=popupConfirm]').bPopup().close();" class="grayBtn">아니요</a>
      </div>
      </div>
</div>
<!-- popup// -->

<script type="text/javascript" src="/resources/js/temporary.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		EgovJqGridApi.mainGrid([
            { label: '구역 시퀀스', name:'part_seq', align:'center', key: true, hidden:true},
            { label: '지점 코드', name:'center_cd', align:'center', hidden:true},
            { label: '구역', name:'part_icon', align:'center', formatter: imageFomatter},
			{ label: '지점명', name:'center_nm', align: 'center'},
			{ label: '구역 등급',  name:'part_class_nm', align: 'center'},
			{ label: '구역 등급',  name:'part_class', align: 'center', hidden:true},
			{ label: '구역 비용', name:'part_pay_cost', align:'center'},
			{ label: '사용유무', name:'use_yn_value', align:'center', hidden:true},
			{ label: '사용유무', name:'use_yn', align:'center'},
			{ label: '정렬순서', name:'part_class_order', align:'center', hidden: true},
			{ label: '수정자', name:'last_updusr_id', align:'center'},
            { label: '수정일자', name:'last_updt_dtm', align:'center'},
		], false, false, fnSearch);
	});
	
	function fnSearch(pageNo) {
		let params = {
			pageIndex: pageNo,
			pageUnit: $('.ui-pg-selbox option:selected').val(),
			searchCenterCd: $('#searchCenterCd').val()
		};
		EgovJqGridApi.mainGridAjax('/backoffice/bld/partClassListAjax.do', params, fnSearch, '');
		EgovJqGridApi.mainGridDetail(fnPartClassInfo);
	}
	
  	
	function fnPartClassInfo(id, rowData) {
		let $popup = $('[data-popup=bld_partClass_add]');
		let $form = $popup.find('form:first');
		if (id === undefined || id === null) {
			$popup.find('h2:first').text('구역 정보 등록');
			$popup.find('select').prop('selectedIndex', 0);
			$popup.find('select').prop('disabled', false);
			$popup.find('button.blueBtn').off('click').click(fnPartClassInsert);
			$form.find(':hidden[name=mode]').val('Ins');
			$form.find(':hidden[name=partSeq]').val('');
			$form.find(':text').val('');
			$form.find(':radio[name=useYn]:first').prop('checked', true);
		}
		else {
			$popup.find('h2:first').text('구역 정보 수정');
			$popup.find('button.blueBtn').off('click').click(fnPartClassUpdate);
			$form.find(':hidden[name=mode]').val('Edt');
			$form.find(':hidden[name=partSeq]').val(rowData.part_seq);
			$form.find(':hidden[name=centerNm]').val(rowData.center_nm);
			$form.find('select[name=centerCd]').val(rowData.center_cd).prop('disabled', true);
			$form.find('select[name=partClass]').val(rowData.part_class).prop('disabled', true);
			$form.find(':text[name=partPayCost]').val(rowData.part_pay_cost);
			$form.find(':text[name=partClassOrder]').val(rowData.part_class_order);
			$form.find(':radio[name=useYn][value='+ rowData.use_yn_value +']').prop('checked', true);
		}
		$popup.bPopup();
	}

	// 구역 정보 등록
	function fnPartClassInsert() {
		let $popup = $('[data-popup=bld_partClass_add]');
		let $form = $popup.find('form:first');
		if ($popup.find('select[name=centerCd]').val() === '') {
			//toastr.warning('지점명을 선택해 주세요.');
			alert('지점명을 선택해 주세요.');
			return;
		}
		if ($popup.find('select[name=partClass]').val() === '') {
			//toastr.warning('구역 등급을 선택해 주세요.');
			alert('구역 등급을 선택해 주세요.');
			
			return;	
		}
		if ($popup.find(':text[name=partPayCost]').val() === '') {
			//toastr.warning('구역 금액을 입력해 주세요.');
			alert('구역 금액을 입력해 주세요.');
			return;
		}	
		if ($popup.find(':text[name=partClassOrder]').val() === '') {
			//toastr.warning('정렬 순서를 입력해 주세요.');
			alert('정렬 순서를 입력해 주세요.');
			return;
		}
		
		bPopupConfirm('구역 정보 등록', '등록 하시겠습니까?', function() {
			//체크 박스 체그 값 알아오기 
			var formData = new FormData();
			//formData.append('partIcon', $('#centerImg')[0].files[0]);
			formData.append('partIcon', $form.find(':file[name=partIcon]')[0].files[0]);
	 	    formData.append('centerCd' , $form.find('select[name=centerCd]').val());
	 	    formData.append('partClass' , $form.find('select[name=partClass]').val());
	 	    formData.append('partPayCost' , $form.find(':text[name=partPayCost]').val());
	 	    formData.append('partClassOrder' , $form.find(':text[name=partClassOrder]').val());
	 	   	formData.append('useYn', $form.find('input[name=useYn]:checked').val());
	 	   	formData.append('mode' , $form.find(':hidden[name=mode]').val());
	 	   
	 	    uniAjaxMutipart
	 	    (
				"/backoffice/bld/partClassUpdate.do", 
				formData, 
				function(result) {
					//결과값 추후 확인 하기 	
					if (result.status == "SUCCESS"){
						common_modelCloseM(result.message, "bld_partClass_add");
						fnSearch(1);
					} else if (result.status == "OVERLAP FAIL"){
						common_modelCloseM(result.message, "bld_partClass_add");
						fnSearch(1);
					} else if (result.status == "LOGIN FAIL") {
						common_modelClose("bld_partClass_add");
						    document.location.href="/backoffice/login.do";
					} else {
						common_modelCloseM("저장 도중 문제가 발생 하였습니다.", "Y", "bld_partClass_add");
					}
				},
				function(request){
					common_modelCloseM("Error:" +request.status, "N", "bld_partClass_add");	
				}    		
			);
		});
	}
	
	// 구역정보 수정
	function fnPartClassUpdate() {
		let $popup = $('[data-popup=bld_partClass_add]');
		let $form = $popup.find('form:first');
		if ($popup.find('select[name=centerCd]').val() === '') {
			//toastr.warning('지점명을 선택해 주세요.');
			alert('지점명을 선택해 주세요.');
			return;
		}
		if ($popup.find('select[name=partClass]').val() === '') {
			//toastr.warning('구역 등급을 선택해 주세요.');
			alert('구역 등급을 선택해 주세요.');
			
			return;	
		}
		if ($popup.find(':text[name=partPayCost]').val() === '') {
			//toastr.warning('구역 금액을 입력해 주세요.');
			alert('구역 금액을 입력해 주세요.');
			return;
		}
		if ($popup.find(':text[name=partClassOrder]').val() === '') {
			//toastr.warning('정렬 순서를 입력해 주세요.');
			alert('정렬 순서를 입력해 주세요.');
			return;
		}
		
		bPopupConfirm('구역 정보 수정', '<b>'+ $popup.find(':hidden[name=centerNm]').val() + '</b>을(를) 수정 하시겠습니까?', function() {
			$("select[name=centerCd]").removeAttr('disabled');
			//체크 박스 체그 값 알아오기 
			var formData = new FormData();
			console.log($form.find(':file[name=partIcon]')[0].files[0]);
			//formData.append('partIcon', $('#centerImg')[0].files[0]);
			formData.append('partSeq', $form.find(':hidden[name=partSeq]').val());;
			formData.append('partIcon', $form.find(':file[name=partIcon]')[0].files[0]);
	 	    formData.append('centerCd' , $form.find('select[name=centerCd]').val());
	 	    formData.append('partClass' , $form.find('select[name=partClass]').val());
	 	    formData.append('partPayCost' , $form.find(':text[name=partPayCost]').val());
	 	    formData.append('partClassOrder' , $form.find(':text[name=partClassOrder]').val());
	 	   	formData.append('useYn', $form.find('input[name=useYn]:checked').val());
	 	   	formData.append('mode' , $form.find(':hidden[name=mode]').val());
	 	   
	 	    uniAjaxMutipart
	 	    (
				"/backoffice/bld/partClassUpdate.do", 
				formData, 
				function(result) {
					//결과값 추후 확인 하기 	
					if (result.status == "SUCCESS"){
						common_modelCloseM(result.message, "bld_partClass_add");
						alert(result.message);
						fnSearch(1);
					} else if (result.status == "LOGIN FAIL") {
						common_modelClose("bld_partClass_add");
						    document.location.href="/backoffice/login.do";
					} else {
						common_modelCloseM("저장 도중 문제가 발생 하였습니다.", "Y", "bld_partClass_add");
					}
				},
				function(request){
					common_modelCloseM("Error:" +request.status, "N", "bld_partClass_add");	
				}    		
			);
		});
	}
	
	function fnPartClassDelete() {
		let rowId = $('#mainGrid').jqGrid('getGridParam', 'selrow');
		if (rowId === null) {
			toastr.warning('구역 정보를 선택해 주세요.');
			return false;
		}
		let rowData = $('#mainGrid').jqGrid('getRowData', rowId);
		bPopupConfirm('구역 정보 삭제', '<b>'+ rowData.center_nm +' '+ rowData.part_class_nm +'</b> 를(을) 삭제 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/bld/partClassDelete.do', {
					partSeq: rowId
				},
				null,
				function(json) {
					common_modelCloseM(json.message, "bld_partClass_add");
					fnSearch(1);
				},
				function(json) {
					common_modelClose("bld_partClass_add");
				}
			);
		});
	}

	function imageFomatter (cellvalue, options, rowObject) {
		//이미지 URL	
		var partIcon = (rowObject.part_icon === undefined) ? "/resources/img/no_image.png": "/upload/"+ rowObject.part_icon;
		return '<img src="' + partIcon + ' " style="width:120px">';
	}

	function bPopupConfirm(title, message, fnOk) {
		let $popup = $('[data-popup=popupConfirm]');
		$popup.find('.pop_tit').text(title);
		$popup.find('.pop_wrap span').html(message);
		$popup.find('.blueBtn').off('click').click(function() {
			$('[data-popup=popupConfirm]').bPopup().close();
			fnOk();
		});
		$popup.bPopup();
	}
	 
</script>
<c:import url="/backoffice/inc/popup_common.do" />