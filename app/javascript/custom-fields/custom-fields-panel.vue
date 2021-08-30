<template>
<div>
  <div v-for="(field, index) in customFields" :key="field.custom_field_id">
    <text-field v-if="field.data_type === 'string'" :obj="field" :index="index" />
    <text-area v-else-if="field.data_type === 'textarea'" :obj="field" :index="index" />
    <phone v-else-if="field.data_type === 'phone'" :obj="field" :index="index" />
    <date-picker v-else-if="field.data_type === 'date'" :obj="field" :index="index" />
    <checkbox v-else-if="field.data_type === 'checkbox'" :obj="field" :index="index" />
    <address v-else-if="field.data_type === 'address'" :obj="field" :index="index" />
  </div>
</div>
</template>

<script>
import Checkbox from "./components/checkbox"
import DatePicker from "./components/date-picker"
import TextArea from "./components/textarea"
import TextField from "./components/text-field"
import Phone from "./components/phone"
import Address from "./components/address"

export default {
  components: {
    Checkbox,
    DatePicker,
    TextArea,
    TextField,
    Phone,
    Address
  },

  props: {
    requestPath: String,
  },

  data() {
    return {
      customFields: JSON.parse(this.$parent.$el.dataset.values) || []
    }
  },

  async mounted() {
    if (this.customFields.length == 0) {
      const helpRequestKindIdElem = document.getElementById('help_request_help_request_kind_id');
      this.getCustomFields(helpRequestKindIdElem.value);
    }

    window.vueEventBus.$on('helpRequestKindIdChanged', helpRequestKindId => {
      this.getCustomFields(helpRequestKindId);
    });
  },


  methods: {
    async getCustomFields(helpRequestKindId) {
      try {
        const response = await fetch(`${this.requestPath}?help_request_kind_id=${helpRequestKindId}`);
        this.customFields = await response.json();
      } catch(e) {
        console.error(e);
      } 
    }
  }
}
</script>