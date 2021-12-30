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
<!-- JSTree -->
<link rel="stylesheet" href="/resources/css/style.min.css">
<script type="text/javascript" src="/resources/js/jstree.min.js"></script>
<!-- //contents -->
<div class="breadcrumb">
 	<ol class="breadcrumb-item">
    	<li>기초 관리&nbsp;&gt;&nbsp;</li>
    	<li class="active">권한 관리</li>
	</ol>
</div>
<h2 class="title">권한 관리</h2>
<div class="clear"></div>
<div class="dashboard">
    <div class="boardlist">
		<div class="left_box mng_countInfo">
            <p>총 : <span id="sp_totcnt"></span>건</p>
        </div>
        <div class="right_box">
	        <a href="javascript:fnAuthInfo();" class="blueBtn">권한분류 등록</a>
	        <a href="javascript:fnAuthDelete();" class="grayBtn">권한분류 삭제</a>
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
<div data-popup="bas_auth_add" class="popup m_pop">
    <div class="pop_con">
        <a class="button b-close">X</a>
        <h2 class="pop_tit">권한코드 등록</h2>
        <div class="pop_wrap">
        	<form>
        	<input type="hidden" name="mode" value="Ins">
            <table class="detail_table">
                <tbody>
                    <tr>
                        <th>권한코드</th>
                        <td>
                            <input type="text" name="authorCode" >
                            <span id="sp_Unqi">
                            	<a href="javascript:fnIdCheck();" class="blueBtn">중복확인</a>
                            	<input type="hidden" id="idCheck" value="N">
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <th>권한명</th>
                        <td>
                            <input type="text" name="authorNm">
                        </td>
                    </tr>
                    <tr>
                        <th>상세설명</th>
                        <td>
                            <input type="text" name="authorDc">
                        </td>
                    </tr>
                </tbody>
            </table>
            </form>
        </div>
        <div class="right_box">
        	<button class="blueBtn">저장</button>
            <button class="grayBtn b-close">취소</button>            
        </div>
        <div class="clear"></div>
    </div>
</div>
<!-- 프로그램 추가 팝업-->
<div data-popup="bas_menu_setting" class="popup m_pop" style="overflow:hidden;">
    <div class="pop_con">
        <a class="button b-close">X</a>
        <h2 class="pop_tit">메뉴설정</h2>
        <div class="pop_wrap">
        	<input type="hidden" name="authorCode"> 
            <div id="jstree" style="overflow:auto; height:700px; border:1px #eee solid; margin-bottom:20px;" />
        </div>
        <div class="right_box">
        	<button onclick="fnMenuSettingSave();" class="blueBtn">저장</button>
            <button class="grayBtn b-close">취소</button>
        </div>
        <div class="clear"></div>
    </div>
</div>
<!-- popup// -->
<script type="text/javascript" src="/resources/jqgrid/jqgrid.custom.egovapi.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		EgovJqGridApi.mainGrid([
			{ label: '권한코드', name: 'author_code', align: 'center', fixed: true, key: true },
			{ label: '권한명',  name: 'author_nm', align: 'center', fixed: true },
			{ label: '상세설명', name: 'author_dc', align: 'left' },
			{ label: '생성일', name: 'author_creat_de',  align:'center', width:'120', fixed: true, formatter: 'date' },
			{ label: '메뉴설정여부', align:'center', width:'100', fixed: true, sortable: false, formatter: (c, o, row) => 
				row.chk_menu === 0 ? '미생성' : '생성' 
			},
			{ label: '메뉴설정', align:'center', width:'120', fixed: true, sortable: false, formatter: (c, o, row) =>
				'<a href="javascript:fnMenuSetting(\''+ row.author_code +'\');" class="blueBtn">메뉴설정</a>'
			}
		], false, false, fnSearch);
		EgovIndexApi.apiExecuteJson(
			'POST',
			'/backoffice/bas/menuListAjax.do',{
				pageIndex: '1',
				pageUnit: '100'	
			},
			null,
			function(json) {
				let arr = new Array();
				for (var m of json.resultlist) {
					let obj = {
						id: m.menu_no,
						parent: m.upper_menu_no == null ? '#' : m.upper_menu_no,
						text: m.upper_menu_no == null ? '관리자' : $.trim(m.menu_nm),
						state: {
							opened: true
						}
					};
					arr.push(obj);
				}
				$('#jstree').jstree({
					core: {
						data: arr,
						themes: {
							icons: true,
							dots: true
						}
					},
					types: {
						valid_children: [ 'default' ],
						'default': {
							icon: 'jstree-folder'
						}
					},
					checkbox: {
						keep_selected_style: false
					},
					plugins : [ 'types', 'checkbox' ]
				});
			},
			function(json) {
				toastr.error(json.message);
			}
		);
	});
	
	function fnSearch(pageNo) {
		let params = {
			pageIndex: pageNo,
			pageUnit: $('.ui-pg-selbox option:selected').val()
		};
		EgovJqGridApi.mainGridAjax('/backoffice/bas/authListAjax.do', params, fnSearch, null);
		EgovJqGridApi.mainGridDetail(fnAuthInfo);
	}
	
	function fnAuthInfo(id, rowData) {
		let $popup = $('[data-popup=bas_auth_add]');
		let $form = $popup.find('form:first');
		if (id === undefined || id === null) {
			$popup.find('h2:first').text('권한코드 등록');
			$popup.find('span#sp_Unqi').show();
			$popup.find('button.blueBtn').off('click').click(fnAuthInsert);
			$form.find(':hidden[name=mode]').val('Ins');
			$form.find(':text').val('');
			$form.find(':hidden#idCheck').val('N');
			$form.find(':text[name=authorCode]').removeAttr('readonly');
		}
		else {
			$popup.find('h2:first').text('권한코드 수정');
			$popup.find('span#sp_Unqi').hide();
			$popup.find('button.blueBtn').off('click').click(fnAuthUpdate);
			$form.find(':hidden[name=mode]').val('Edt');
			$form.find(':text[name=authorCode]').prop('readonly', true).val(rowData.author_code);
			$form.find(':text[name=authorNm]').val(rowData.author_nm);
			$form.find(':text[name=authorDc]').val(rowData.author_dc);
		}
		$popup.bPopup();
	}
	
	function fnIdCheck() {
		let $popup = $('[data-popup=bas_auth_add]');
		if ($popup.find(':text[name=authorCode]').val() === '') {
			toastr.warning('코드를 입력해 주세요.');
			return;
		}
		EgovIndexApi.apiExecuteJson(
			'GET',
			'/backoffice/bas/authorIDCheck.do', {
				authorCode: $popup.find(':text[name=authorCode]').val()
			},
			null,
			function(json) {
				$popup.find(':hidden#idCheck').val('Y');
				toastr.info(json.message);
			},
			function(json) {
				toastr.warning(json.message);
			}
		);
	}
	
	function fnAuthInsert() {
		let $popup = $('[data-popup=bas_auth_add]');
		if ($popup.find(':text[name=authorCode]').val() === '') {
			toastr.warning('코드를 입력해 주세요.');
			return;
		}
		if ($popup.find(':hidden#idCheck').val() !== 'Y') {
			toastr.warning('중복체크가 안되었습니다.');
			return;	
		}
		if ($popup.find(':text[name=authorNm]').val() === '') {
			toastr.warning('권한명을 입력해 주세요.');
			return;
		}
		bPopupConfirm('권한코드 등록', '등록 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/bas/authUpdate.do', 
				$popup.find('form').serializeObject(),
				null,
				function(json) {
					toastr.success(json.message);
					$popup.bPopup().close();
					fnSearch(1);
				},
				function(json) {
					toastr.error(json.message);
				}
			);
		});
	}
	
	function fnAuthUpdate() {
		let $popup = $('[data-popup=bas_auth_add]');
		if ($popup.find(':text[name=authorCode]').val() === '') {
			toastr.warning('코드를 입력해 주세요.');
			return;
		}
		bPopupConfirm('권한코드 수정', '<b>'+ $popup.find(':text[name=authorCode]').val() +'</b> 수정 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/bas/authUpdate.do', 
				$popup.find('form').serializeObject(),
				null,
				function(json) {
					toastr.success(json.message);
					$popup.bPopup().close();
					fnSearch(1);
				},
				function(json) {
					toastr.error(json.message);
				}
			);
		});
	}
	
	function fnAuthDelete() {
		let rowId = $('#mainGrid').jqGrid('getGridParam', 'selrow');
		if (rowId === null) {
			toastr.warning('분류코드를 선택해 주세요.');
			return false;
		}
		bPopupConfirm('권한코드 삭제', '<b>'+ rowId +'</b> 를(을) 삭제 하시겠습니까?', function() {
			fnAuthDeleteConfirm(rowId);
		});
	}
	
	function fnAuthDeleteConfirm(code) {
		bPopupConfirm('권한코드 삭제', '<b>'+ code +'</b> 를(을) 삭제하시면 시스템에 영향이 있을 수 있습니다.<br>정말로 삭제하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/bas/authDelete.do', {
					authorCode: code
				},
				null,
				function(json) {
					toastr.success(json.message);
					fnSearch(1);
				},
				function(json) {
					toastr.error(json.message);
				}
			);
		});
	}
	
	function fnMenuSetting(code) {
		let $popup = $('[data-popup=bas_menu_setting]');
		$('#jstree').jstree('uncheck_all');
		EgovIndexApi.apiExecuteJson(
			'GET',
			'/backoffice/bas/menuCreateMenuListAjax.do', {
				authorCode: code
			},
			null,
			function(json) {
				for (var m of json.resultlist) {
					$('#jstree').jstree('select_node', m.menu_no);
				}
				$popup.find(':hidden[name=authorCode]').val(code);
				$popup.bPopup();
			},
			function(json) {
				toastr.error(json.message);
			}
		);
	}
	
	function fnMenuSettingSave() {
		let $popup = $('[data-popup=bas_menu_setting]');
		let authorCode = $popup.find(':hidden[name=authorCode]').val();
		let checkedMenuNo = $('#jstree').jstree('get_selected', false);
		if (checkedMenuNo.length === 0) {
			toastr.warning('체크된 값이 없습니다.');
			return;
		}
		bPopupConfirm('메뉴설정 저장', '<b>'+ authorCode +'</b> 메뉴설정 저장 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/bas/menuCreateUpdateAjax.do', {
					authorCode: authorCode,
					checkedMenuNo: checkedMenuNo.join(',')
				},
				null,
				function(json) {
					toastr.success(json.message);
					$popup.bPopup().close();
					fnSearch(1);
				},
				function(json) {
					toastr.error(json.message);
				}
			);
		});
	}
</script>
<c:import url="/backoffice/inc/popup_common.do" />