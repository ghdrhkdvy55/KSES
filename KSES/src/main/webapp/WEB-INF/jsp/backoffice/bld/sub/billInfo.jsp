<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="pop_con">
    <a class="button b-close">X</a>
    <h2 class="pop_tit">현금영수증 설정 [<span id="spCenterNm"></span>] - <span id="spModeNm"></span></h2>
    <div class="pop_wrap">
        <form>
        <input type="hidden" name="mode" value="Ins">
        <input type="hidden" name="billSeq">
        <input type="hidden" name="centerCd">
        <table class="detail_table">
            <tbody>
                <tr>
                    <th>발급구분 *</th>
                    <td style="width:280px;">
                        <select name="billDvsn">
                            <option value="">선택</option>
                            <c:forEach var="item" items="${billDvsnInfoComboList}">
                                <option value="${item.code}"><c:out value="${item.codenm}"/></option>
                            </c:forEach>
                        </select>
                    </td>
                    <th>사업자번호 *</th>
                    <td><input type="text" name="billNum" maxlength="12" style="width:100%;" numberonly></td>
                </tr>
                <tr>
                    <th>법인명 *</th>
                    <td><input type="text" name="billCorpName" style="width:100%;"></td>
                    <th>대표자명</th>
                    <td><input type="text" name="billCeoName" style="width:100%;"></td>
                </tr>
                <tr>
                    <th>주소</th>
                    <td><input type="text" name="billAddr" style="width:100%;"></td>
                    <th>연락처</th>
                    <td><input type="text" name="billTel" style="width:100%;"></td>
                </tr>
                <tr>
                    <th>이메일</th>
                    <td><input type="text" name="billEmail" style="width:100%;"></td>
                    <th>팝빌ID</th>
                    <td><input type="text" name="billUserId" style="width:100%;"></td>
                </tr>
            </tbody>
        </table>
        </form>
        <div id="divBillInsert" style="float:left;margin-top:10px;display:none;">
            <a href="javascript:BillInfo.createView();" class="orangeBtn" style="font-size:16px;padding:6px 16px;">등록</a>
        </div>
        <div class="right_box" style="margin-top:10px;">
            <a href="javascript:BillInfo.save();" class="blueBtn">저장</a>
        </div>
        <div class="clear"></div>
        <div style="width:700px;">
            <table id="billInfoGrid"></table>
        </div>
        <div class="right_box" style="margin-top:10px;">
            <button type="button" class="grayBtn b-close">닫기</button>
        </div>
    </div>
</div>
<script type="text/javascript">
    $.BillInfo = function () {
        EgovIndexApi.numberOnly();
        EgovJqGridApi.defaultGrid('billInfoGrid', [
            {label: '현금영수증코드', name: 'bill_seq', key: true, hidden: true},
            {label: '발급구분코드', name: 'bill_dvsn', hidden: true },
            {label: '대표자명', name: 'bill_ceo_name', hidden: true },
            {label: '주소', name: 'bill_addr', hidden: true },
            {label: '연락처', name: 'bill_tel', hidden: true },
            {label: '이메일', name: 'bill_email', hidden: true },
            {label: '발급구분', name: 'bill_dvsn_text', align: 'center', sortable: false},
            {label: '사업자번호', name: 'bill_num', align: 'center', sortable: false},
            {label: '법인명', name: 'bill_corp_name', align: 'center', sortable: false},
            {label: '팝빌ID', name: 'bill_user_id', align: 'center', sortable: false},
            {label: '삭제', align:'center', width: 50, fixed: true, formatter: (c, o, row) =>
                '<a href="javascript:BillInfo.delete(\''+ row.bill_seq +'\');" class="del_icon"></a>'
            }
        ], false).jqGrid('setGridParam', {
            onSelectRow: function (rowId, status, e) {
                let $popup = BillInfo.getPopup();
                let rowData = EgovJqGridApi.getGridRowData('billInfoGrid', rowId);
                $popup.find('#spModeNm').text('수정');
                $popup.find(':hidden[name=mode]').val('Edt');
                $popup.find(':hidden[name=billSeq]').val(rowData.bill_seq);
                $popup.find('select[name=billDvsn]').val(rowData.bill_dvsn);
                $popup.find(':text[name=billCeoName]').val(rowData.bill_ceo_name);
                $popup.find(':text[name=billAddr]').val(rowData.bill_addr);
                $popup.find(':text[name=billTel]').val(rowData.bill_tel);
                $popup.find(':text[name=billEmail]').val(rowData.bill_email);
                $popup.find(':text[name=billNum]').val(rowData.bill_num);
                $popup.find(':text[name=billCorpName]').val(rowData.bill_corp_name);
                $popup.find(':text[name=billUserId]').val(rowData.bill_user_id);
                $popup.find('#divBillInsert').show();
            }
        });
    };

    $.BillInfo.prototype.getPopup = function() {
        return $('[data-popup=bld_billinfo_add]');
    };

    $.BillInfo.prototype.bPopup = function (centerCd, centerNm) {
        let $popup = this.getPopup();
        $popup.find('#spCenterNm').text(centerNm);
        $popup.find(':hidden[name=centerCd]').val(centerCd);
        this.selectList();
        this.createView();
        $popup.bPopup();
    };

    $.BillInfo.prototype.selectList = function() {
        let $popup = this.getPopup();
        EgovJqGridApi.defaultGridAjax('billInfoGrid', '/backoffice/bld/billInfoListAjax.do', {
            centerCd: $popup.find(':hidden[name=centerCd]').val()
        });
    };

    $.BillInfo.prototype.createView = function () {
        let $popup = this.getPopup();
        $popup.find('#spModeNm').text('등록');
        $popup.find(':hidden[name=mode]').val('Ins');
        $popup.find(':hidden[name=billSeq]').val('');
        $popup.find('select[name=billDvsn] option:first').prop('selected', true);
        $popup.find(':text').val('');
        $popup.find('#divBillInsert').hide();
        EgovJqGridApi.selection('billInfoGrid');
    };

    $.BillInfo.prototype.save = function() {
        let $popup = this.getPopup();
        if ($popup.find('select[name=billDvsn]').val() === '') {
            toastr.warning('발급구분을 선택해 주세요.');
            return;
        }
        if ($popup.find(':text[name=billNum]').val() === '') {
            toastr.warning('사업자번호를 입력해 주세요.');
            return;
        }
        if ($popup.find(':text[name=billCorpName]').val() === '') {
            toastr.warning('법인명을 입력해 주세요.');
            return;
        }
        bPopupConfirm('현금영수증 '+ ($popup.find(':hidden[name=mode]').val() === 'Ins' ? '등록' : '수정'), '저장 하시겠습니까?', function() {
            EgovIndexApi.apiExecuteJson(
                'POST',
                '/backoffice/bld/billInfoUpdate.do',
                $popup.find('form:first').serializeObject(),
                null,
                function(json) {
                    toastr.success(json.message);
                    BillInfo.selectList();
                },
                function(json) {
                    toastr.error(json.message);
                }
            );
        });
    };

    $.BillInfo.prototype.delete = function(key) {
        let $popup = this.getPopup();
        bPopupConfirm('현금영수증 삭제', '삭제 하시겠습니까?', function() {
            EgovIndexApi.apiExecuteJson(
                'POST',
                '/backoffice/bld/billInfoDelete.do', {
                    centerCd: $popup.find(':hidden[name=centerCd]').val(),
                    billSeq: key
                },
                null,
                function(json) {
                    toastr.success(json.message);
                    BillInfo.selectList();
                },
                function(json) {
                    toastr.error(json.message);
                }
            );
        });
    };

    const BillInfo = new $.BillInfo();
</script>