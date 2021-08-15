/* eslint-disable no-new */
import Vue from 'vue/dist/vue.esm.js';
import CustomFieldsPanel from '../custom-fields/custom-fields-panel'

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#js-custom-fields-container',
    components: {
      CustomFieldsPanel
    }
  });

  const helpRequestKindIdElem = document.getElementById('help_request_help_request_kind_id');
  window.vueEventBus.$emit('helpRequestKindIdChanged', helpRequestKindIdElem.value);
  helpRequestKindIdElem.onchange = () => {
      window.vueEventBus.$emit('helpRequestKindIdChanged', helpRequestKindIdElem.value);
  }
});