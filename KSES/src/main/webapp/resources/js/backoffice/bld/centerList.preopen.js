$.Preopen = function() {
    this._editoptions = {
        size: 5,
        maxlength: 5
    };
};

$.Preopen.prototype.mainGridSettings = function() {
    MainGridAjaxUrl = '/backoffice/bld/preOpenInfoListAjax.do';
    EgovJqGridApi.mainGrid([
        { label: '사전예약입장시간코드', name: 'optm_cd', key: true, hidden:true },
        { label: '요일', name: 'open_day_text', align: 'center', sortable: false },
        { label: '회원오픈시간', name: 'open_member_tm', align: 'center', sortable: false, editable: true, editoptions: this._editoptions },
        { label: '회원종료시간', name: 'close_member_tm', align: 'center', sortable: false, editable: true, editoptions: this._editoptions },
        { label: '비회원오픈시간', name: 'open_guest_tm', align: 'center', sortable: false, editable: true, editoptions: this._editoptions },
        { label: '비회원종료시간', name: 'close_guest_tm', align: 'center', sortable: false, editable: true, editoptions: this._editoptions },
    ], false, false, fnSearch, false).jqGrid('setGridParam', {
        cellEdit: true,
        cellsubmit: 'clientArray'
    });
    $('#rightAreaBtn').hide();
};

$.Preopen.prototype.updateSettings = function(ajaxUpdate, changedArr) {
    ajaxUpdate.title = '사전예약 수정';
    ajaxUpdate.url = '/backoffice/bld/preOpenInfoUpdate.do';
    changedArr.forEach(x => ajaxUpdate.params.push({
        optmCd: x.optm_cd,
        openMemberTm: x.open_member_tm.replace(/\:/g,''),
        openGuestTm: x.open_guest_tm.replace(/\:/g,''),
        closeMemberTm: x.close_member_tm.replace(/\:/g,''),
        closeGuestTm: x.close_guest_tm.replace(/\:/g,'')
    }));
};

$.Preopen.prototype.centerCopy = function(ajaxCopy) {
    ajaxCopy.title = '사전예약시간 복사';
    ajaxCopy.url = '/backoffice/bld/preOpenInfoCopy.do';
};

const Preopen = new $.Preopen();