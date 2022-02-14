<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="pop_con">
    <a class="button b-close">X</a>
    <h2 class="pop_tit">층정보 수정</h2>
    <div class="pop_wrap">
        <form>
        <input type="hidden" name="mode">
        <input type="hidden" name="floorCd">
        <table class="detail_table">
            <tbody>
                <tr>
                    <th>층이름</th>
                    <td><input type="text" name="floorNm"></td>
                </tr>
                <tr>
                    <th>도면이미지</th>
                    <td><input type="file" name="floorMap1File"></td>
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
    <popup-right-button clickFunc="FloorInfo.save();" />
</div>
<script type="text/javascript">
    $.FloorInfo = function() {
    };

    $.FloorInfo.prototype.getPopup = function() {
        return $('[data-popup=bld_floorinfo_add]');
    };

    $.FloorInfo.prototype.bPopup = function(floorCd, floorNm) {
        let $popup = this.getPopup();
        let $form = $popup.find('form:first');
        $popup.find('h2:first').text(floorNm +' 층 정보 수정');
        EgovIndexApi.apiExecuteJson(
            'GET',
            '/backoffice/bld/floorInfoDetail.do', {
                floorCd: floorCd
            },
            null,
            function(json) {
                let data = json.result;
                $form.find(':hidden[name=mode]').val('Edt');
                $form.find(':hidden[name=floorCd]').val(data.floor_cd);
                $form.find(':text[name=floorNm]').val(data.floor_nm);
                $form.find(':radio[name=useYn][value='+ data.use_yn +']').prop('checked', true);
                $form.find(':radio[name=floorPartDvsn][value='+ data.floor_part_dvsn +']').prop('checked', true);
            },
            function(json) {
                toastr.warning(json.message);
            }
        );
        $popup.bPopup();
    };

    $.FloorInfo.prototype.save = function() {
        let $popup = this.getPopup();
        let $form = $popup.find('form:first');
        let formData = new FormData($form[0]);
        bPopupConfirm('층 정보 수정', '저장 하시겠습니까?', function() {
            EgovIndexApi.apiExcuteMultipart(
                '/backoffice/bld/floorInfoUpdate.do',
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

    const FloorInfo = new $.FloorInfo();
</script>