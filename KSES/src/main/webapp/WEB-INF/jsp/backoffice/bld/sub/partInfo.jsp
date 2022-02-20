<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="pop_con">
    <a class="button b-close">X</a>
    <h2 class="pop_tit"></h2>
    <div class="pop_wrap">
        <form>
        <input type="hidden" name="mode">
        <input type="hidden" name="partCd">
        <table class="detail_table">
            <tbody>
                <tr>
                    <th>구역명</th>
                    <td><input type="text" name="partNm"></td>
                </tr>
                <tr>
                    <th>도면이미지</th>
                    <td><input type="file" name="partMap1File"></td>
                </tr>
                <tr>
                    <th>구역등급</th>
                    <td><select name="partClassSeq"></select></td>
                </tr>
                <tr>
                    <th>정렬순서</th>
                    <td><input type="text" name="partOrder" maxlength="3" numberonly></td>
                </tr>
                <tr>
                    <th>사용여부</th>
                    <td>
                        <input type="radio" name="useYn" value="Y">사용</input>
                        <input type="radio" name="useYn" value="N">사용 안함</input>
                    </td>
                </tr>
            </tbody>
        </table>
        </form>
    </div>
    <popup-right-button clickFunc="PartInfo.save();" />
</div>
<script type="text/javascript">
    $.PartInfo = function() {
        EgovIndexApi.numberOnly();
    };

    $.PartInfo.prototype.getPopup = function() {
        return $('[data-popup=bld_partinfo_add]');
    };

    $.PartInfo.prototype.bPopup = function(partCd) {
        let $popup = this.getPopup();
        let $form = $popup.find('form:first');
        if (partCd === undefined || partCd === null) {
            $popup.find('h2:first').text('구역 등록');
            $form.find(':hidden[name=mode]').val('Ins');
            $form.find(':hidden[name=partCd]').val('');
            $form.find(':text').val('');
            $form.find('select[name=partClassSeq]').val('');
            $form.find(':text[name=partOrder]').val('0');
            $form.find(':radio[name=useYn]:first').prop('checked', true);
        } else {
            EgovIndexApi.apiExecuteJson(
                'GET',
                '/backoffice/bld/partDetail.do', {
                    partCd: partCd
                },
                null,
                function(json) {
                    let data = json.result;
                    $popup.find('h2:first').text(data.part_nm +' 구역 수정');
                    $form.find(':hidden[name=mode]').val('Edt');
                    $form.find(':hidden[name=partCd]').val(data.part_cd);
                    $form.find(':text[name=partNm]').val(data.part_nm);
                    $form.find('select[name=partClassSeq]').val(data.part_class_seq);
                    $form.find(':text[name=partOrder]').val(data.part_order);
                    $form.find(':radio[name=useYn][value='+ data.use_yn +']').prop('checked', true);
                },
                function(json) {
                    toastr.warning(json.message);
                }
            );
        }
        $popup.bPopup();
    };

    $.PartInfo.prototype.partClassComboList = function(centerCd) {
        let $popup = this.getPopup();
        let $partClassSeq = $('select[name=partClassSeq]', $popup);
        $partClassSeq.empty();
        $partClassSeq.append('<option value="">선택</option>');
        EgovIndexApi.apiExecuteJson(
            'POST',
            '/backoffice/bld/partClassListAjax.do', {
                searchCenterCd: centerCd,
                pageIndex: '1',
                pageUnit: '10'
            },
            null,
            function(json) {
                let list = json.resultlist;
                for (let item of list) {
                    $('<option value="'+ item.part_class_seq +'">'+ item.part_class_nm +'</option>').appendTo($partClassSeq);
                }
            },
            function(json) {
                toastr.warning(json.message);
            }
        );
    };

    $.PartInfo.prototype.save = function() {
        let $popup = this.getPopup();
        let $form = $popup.find('form:first');
        let formData = new FormData($form[0]);
        bPopupConfirm('구역 정보 저장', '저장 하시겠습니까?', function() {
            EgovIndexApi.apiExcuteMultipart(
                '/backoffice/bld/partUpdate.do',
                formData,
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
    };

    const PartInfo = new $.PartInfo();
</script>