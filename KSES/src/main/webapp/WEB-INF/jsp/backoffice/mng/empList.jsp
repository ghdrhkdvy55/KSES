<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!-- JQuery Grid -->
<link rel="stylesheet" href="/resources/jqgrid/src/css/ui.jqgrid.css">
<script type="text/javascript" src="/resources/jqgrid/src/i18n/grid.locale-kr.js"></script>
<script type="text/javascript" src="/resources/jqgrid/js/jquery.jqGrid.min.js"></script>
<style type="text/css">
.ui-jqgrid .ui-jqgrid-htable th div {
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
<<<<<<< HEAD
	<div class="boardlist">
		<div class="whiteBox searchBox">
			<div class="top">
				<p>부서</p>
				<select id="searchDepth">
					<option value="">지점 선택</option>
					<c:forEach var="item" items="${DEPT}">
						<option value="${item.code_cd}"><c:out value="${item.code_nm}"/></option>
					</c:forEach>
				</select>
				<p>검색어</p>
				<select id="searchCondition">
					<option value="EMP_NM">이름</option>
					<option value="EMP_NO">사번</option>
				</select> 
				<input type="text" id="searchKeyword" placeholder="검색어를 입력하세요.">
			</div>
			<div class="inlineBtn">
				<a href="javascript:fnSearch(1);" class="grayBtn">검색</a>
			</div>
		</div>
		<div class="left_box mng_countInfo">
			<p>총 : <span id="sp_totcnt"></span>건</p>
		</div>
		<div class="right_box">
			<a href="javascript:fnEmpInfo();" class="blueBtn">사용자 등록</a>
			<a href="javascript:fnEmpDelete();" class="grayBtn">삭제</a>
		</div>
		<div class="clear"></div>
		<div class="whiteBox">
			<table id="mainGrid"></table>
			<div id="pager"></div>
		</div>
	</div>
=======
      <div class="boardlist">
        <div class="whiteBox searchBox">
              <div class="sName">
                <h3>검색 옵션</h3>
              </div>
          <div class="top">
            <p>부서</p>
            <select id="searchDepth" name="searchDepth">
               <option value="">부서 선택</option>
               <c:forEach items="${DEPT}" var="dept">
                  <option value="${dept.code_cd}"><c:out value='${dept.code_nm}'/></option>
               </c:forEach>
            </select>
            <p>검색어</p>
            <select id="searchCondition" name="searchCondition">
              <option value="EMP_NM">이름</option>
              <option value="EMP_NO">사번</option>
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
>>>>>>> refs/remotes/origin/master
</div>
<!-- contents//-->
<!-- //popup -->
<<<<<<< HEAD
<!-- // 직원 등록 팝업 -->
<div data-popup="mng_emp_add" class="popup">
	<div class="pop_con">
		<a class="button b-close">X</a>
		<h2 class="pop_tit">사용자 등록</h2>
		<div class="pop_wrap">
			<form>
			<input type="hidden" name="mode" value="Ins">
			<table class="detail_table">
				<tbody>
					<tr>
						<th>사번</th>
						<td>
							<input type="text" name="empNo">
							<span id="sp_Unqi">
                            	<a href="javascript:fnIdCheck();" class="blueBtn">중복확인</a>
                            	<input type="hidden" id="idCheck" value="N">
                            </span>
						</td>
						<th>이름</th>
						<td><input type="text" name="empNm"></td>
					</tr>
					<tr id="trPassword">
						<th>비밀번호</th>
						<td><input type="password" name="empPassword"></td>
						<th>비밀번호 확인</th>
						<td><input type="password" name="empPassword2"></td>
					</tr>
					<tr>
						<th>부서</th>
						<td>
							<select name="deptCd">
								<option value="">부서 선택</option>
								<c:forEach var="item" items="${DEPT}">
									<option value="${item.code_cd}">${item.code_nm}</option>
								</c:forEach>
							</select>
						</td>
						<th>이메일</th>
						<td>
							<input type="text" name="empEmail">
						</td>
					</tr>
					<tr>
						<th>직책</th>
						<td>
							<span id="spPsitNm"></span>
						</td>
						<th>직급</th>
						<td>
							<span id="spGradNm"></span>
						</td>
					</tr>
					<tr>
						<th>내선번호</th>
						<td><input type="text" name="empTlphn" phoneonly></td>
						<th>핸드폰</th>
						<td><input type="text" name="empClphn" phoneonly></td>
					</tr>
					<tr>
						<th>사용여부</th>
						<td>
							<input type="radio" name="useYn" value="Y">사용</input>
							<input type="radio" name="useYn" value="N">사용 안함</input>
						</td>
						<th>사용자상태</th>
						<td>
							<select name="empState">
								<option value="">상태</option>
								<c:forEach var="item" items="${userState}">
									<option value="${item.code}">${item.codenm}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
				</tbody>
			</table>
			</form>
		</div>
		<div class="right_box">
			<button type="button" class="blueBtn">저장</button>
			<button type="button" class="grayBtn b-close">취소</a>
		</div>
		<div class="clear"></div>
	</div>
=======
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
					<th>비밀번호</th>
					<td><input type="password" id="empPassword"></td>
					<th>비밀번호 확인</th>
					<td><input type="password" id="empPassword2"></td>
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
			                  <option value="${dept.code_cd}"><c:out value='${dept.code_nm}'/></option>
			               </c:forEach>
			          </select> 
                  </td>
                  <th>직급</th>
                  <td><select id="gradCd" name="gradCd">
			               <option value="">직급 선택</option>
			               <c:forEach items="${GRAD}" var="grad">
			                  <option value="${grad.code_cd}"><c:out value='${grad.code_nm}'/></option>
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
			                  <option value="<c:out value='${post.code_cd}'/>"><c:out value='${post.code_nm}'/></option>
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
			                  <option value="${userState.code}"><c:out value='${userState.codenm}'/></option>
			               </c:forEach>
			          </select> 
			      </td>
                </tr>
              </tbody>
          </table>
      </div>
      <div class="right_box">
          <a href="#" onClick="jqGridFunc.fn_CheckForm()" id="btnUpdate" class="blueBtn">저장</a>
          <a href="#" onClick="jqGridFunc.fn_close()" class="grayBtn">취소</a>
      </div>
      <div class="clear"></div>
  </div>
>>>>>>> refs/remotes/origin/master
</div>
<!-- popup// -->
<script type="text/javascript" src="/resources/jqgrid/jqgrid.custom.egovapi.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		// 메인 JqGrid 정의
		EgovJqGridApi.mainGrid([
			{ label: '사번', name:'emp_no', align:'center', key: true },
			{ label: '이름', name:'emp_nm', align:'center' },
			{ label: '부서코드', name:'dept_cd', hidden: true },
			{ label: '부서', name:'dept_nm', align:'center' },
			{ label: '내선번호', name:'emp_tlphn', align:'center', sortable: false },
			{ label: '핸드폰', name:'emp_clphn', align:'center', sortable: false },
			{ label: '이메일', name:'emp_email', align:'left', sortable: false },
			{ label: '사용자상태', name:'emp_state', hidden: true },
			{ label: '상태', name:'code_nm', align:'center' },
			{ label: '사용유무', name:'use_yn', align:'center' },
			{ label: '관리자여부', name:'admin_dvsn', align:'center' },
			{ label: '최종수정자', name:'last_updusr_id', hidden: true },
			{ label: '최종수정일', name:'last_updt_dtm', align:'center', formatter: 'date' }
		], false, false, fnSearch);
	});
	// 메인 목록 검색
	function fnSearch(pageNo) {
		let params = {
			pageIndex: pageNo,
			pageUnit: $('.ui-pg-selbox option:selected').val(),
			searchKeyword: $('#searchKeyword').val(),
			searchCondition: $('#searchCondition').val(),
			searchDepth: $('#searchDepth').val()
		};
		EgovJqGridApi.mainGridAjax('/backoffice/mng/empListAjax.do', params, fnSearch);
		EgovJqGridApi.mainGridDetail(fnEmpInfo);
	}
	// 메인 상세 팝업 정의
	function fnEmpInfo(id, rowData) {
		let $popup = $('[data-popup=mng_emp_add]');
		let $form = $popup.find('form:first');
		if (id === undefined || id === null) {
			$popup.find('h2:first').text('사용자 등록');
			$popup.find('span#sp_Unqi').show();
			$popup.find('tr#trPassword').show();
			$popup.find('button.blueBtn').off('click').click(fnEmpInsert).show();
			$form.find(':hidden[name=mode]').val('Ins');
			$form.find(':text').val('');
			$form.find(':password').val('');
			$form.find('#spPsitNm').text('');
			$form.find('#spGradNm').text('');
			$form.find(':hidden#idCheck').val('N');
			$form.find(':text[name=empNo]').removeAttr('readonly');
			$form.find(':radio[name=useYn]:first').prop('checked', true).removeAttr('disabled');
			$form.find('select[name=deptCd]').removeAttr('disabled');
			$form.find('select[name=empState]').removeAttr('disabled');
		}
		else {
			// 직원일 경우 수정 불가
			if (rowData.last_updusr_id === 'BATCH') {
				$popup.find('h2:first').text('사용자 상세');
				$popup.find('tr#trPassword').hide();
				$popup.find('button.blueBtn').off('click').hide();
				$form.find(':text').prop('readonly', true);
				$form.find(':radio[name=useYn]').prop('disabled', true);
				$form.find('select[name=deptCd]').prop('disabled', true);
				$form.find('select[name=empState]').prop('disabled', true);
			}
			// 시스템 등록 사용자일 경우 수정 가능
			else {
				$popup.find('h2:first').text('사용자 수정');
				$popup.find('tr#trPassword').show();
	 			$popup.find('button.blueBtn').off('click').click(fnEmpUpdate).show();
	 			$form.find('select[name=useYn]').removeAttr('disabled');
	 			$form.find('select[name=deptCd]').removeAttr('disabled');
	 			$form.find('select[name=empState]').removeAttr('disabled');
			}
			$popup.find('span#sp_Unqi').hide();
			$form.find(':hidden[name=mode]').val('Edt');
			$form.find(':text[name=empNo]').prop('readonly', true).val(rowData.emp_no);
			$form.find(':text[name=empNm]').val(rowData.emp_nm);
			$form.find(':password').val('');
			$form.find('select[name=deptCd]').val(rowData.dept_cd);
			$form.find('#spPsitNm').text(rowData.psit_nm);
			$form.find('#spGradNm').text(rowData.grad_nm);
			$form.find(':text[name=empEmail]').val(rowData.emp_email);
			$form.find(':text[name=empTlphn]').val(rowData.emp_tlphn);
			$form.find(':text[name=empClphn]').val(rowData.emp_clphn);
			$form.find(':radio[name=useYn][value='+ rowData.use_yn +']').prop('checked', true);
			$form.find('select[name=empState]').val(rowData.emp_state);
		}
		$popup.bPopup();
	}
	// 중복 휴일 체크
	function fnIdCheck() {
		let $popup = $('[data-popup=mng_emp_add]');
		if ($popup.find(':text[name=empNo]').val() === '') {
			toastr.warning('사번을 입력해 주세요.');
			return;
		}
		EgovIndexApi.apiExecuteJson(
			'GET',
			'/backoffice/mng/empNoCheck.do', {
				empNo: $popup.find(':text[name=empNo]').val()
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
	// 사용자 등록
	function fnEmpInsert() {
		let $popup = $('[data-popup=mng_emp_add]');
		let $form = $popup.find('form:first');
		if ($form.find(':text[name=empNo]').val() === '') {
			toastr.warning('사번을 입력해 주세요.');
			return;
		}
		if ($form.find(':hidden#idCheck').val() !== 'Y') {
			toastr.warning('중복체크가 안되었습니다.');
			return;	
		}
		if ($form.find(':text[name=empNm]').val() === '') {
			toastr.warning('이름을 입력해 주세요.');
			return;
		}
		let password = $form.find(':password[name=empPassword]').val();
		if (password === '') {
			toastr.warning('비밀번호를 입력해 주세요.');
			return;
		} else {
			if (!EgovIndexApi.vaildPassword(password)) {
				toastr.warning('비밀번호가 유효하지 않습니다.');
				return;
			}
			let password2 = $form.find(':password[name=empPassword2]').val();
			if (password2 === '') {
				toastr.warning('비밀번호 확인을 입력해 주세요.');
				return;
			}
			if ($.trim(password) !== $.trim(password2)) {
				toastr.warning('비밀번호가 일치하지 않습니다. ');
				return;
			}
		}
		bPopupConfirm('사용자 등록', '등록 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/mng/empUpdate.do', 
				$form.serializeObject(),
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
	// 사용자 수정
	function fnEmpUpdate() {
		let $popup = $('[data-popup=mng_emp_add]');
		let $form = $popup.find('form:first');
		if ($form.find(':text[name=empNm]').val() === '') {
			toastr.warning('이름을 입력해 주세요.');
			return;
		}
		let password = $form.find(':password[name=empPassword]').val();
		if (password === '') {
			toastr.warning('비밀번호를 입력해 주세요.');
			return;
		} else {
			if (!EgovIndexApi.vaildPassword(password)) {
				toastr.warning('비밀번호가 유효하지 않습니다.');
				return;
			}
			let password2 = $form.find(':password[name=empPassword2]').val();
			if (password2 === '') {
				toastr.warning('비밀번호 확인을 입력해 주세요.');
				return;
			}
			if ($.trim(password) !== $.trim(password2)) {
				toastr.warning('비밀번호가 일치하지 않습니다. ');
				return;
			}
		}
		let email = $form.find('text[name=empEmail]').val();
		if (email === '') {
			toastr.warning('이메일을 입력해주세요.');
			return;
		} else {
			if (!EgovIndexApi.validEmail(email)) {
				toastr.warning('이메일 형식에 맞지 않습니다.');
				return;
			}
		}
		bPopupConfirm('사용자 수정', '<b>'+ $form.find(':text[name=empNo]').val() +'</b> 수정 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/mng/empUpdate.do', 
				$form.serializeObject(),
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
	// 사용자 삭제
	function fnEmpDelete() {
		let rowId = $('#mainGrid').jqGrid('getGridParam', 'selrow');
		if (rowId === null) {
			toastr.warning('사용자를 선택해 주세요.');
			return false;
		}
		bPopupConfirm('사용자 삭제', '<b>'+ rowId +'</b> 를(을) 삭제 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/mng/empDelete.do', {
					empNo: rowId
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